#!/usr/bin/env python
from __future__ import print_function
import rospy
from motion_control.msg import MotionCommand, MotorCommand, Segment, SegmentResponse
from trajectory import ( Proto, Command, freq_map, TimeoutException, SegmentList, SegmentIterator, 
                         SegmentError, VrOutOfRangeError ) 
from time import sleep
from Queue import Queue, Empty
from threading import Thread


def add_segment_from_message(memo, segment_list, msg):
    
    
    # Drop IMMEDIATE messages when the queue is full
    if (msg.exec_type == MotionCommand.IMMEDIATE and (len(segment_list)  > 1) or memo['queue_time'] > .7):
        
        # But don't drop stop messages
        if sum (abs(e) for e in msg.joints) != 0:
            return 
    
    if msg.command_type == MotionCommand.V_COMMAND:
        
        if msg.t > 0:
            try:
                segment_list.add_velocity_segment(msg.joints,t=msg.t)
            except SegmentError as e:
                print("ERROR", e)
            except VrOutOfRangeError as e:
                print("ERROR", e)
        else:
            pass
        
    else:
        if msg.t > 0:
            try:
                segment_list.add_distance_segment(msg.joints,t=msg.t)
            except SegmentError as e:
                print("ERROR", e)
            except VrOutOfRangeError as e:
                print("ERROR", e)
        else:
            pass
            

def send_command_thread(memo):
    
    queue = memo['queue']
    proto = memo['proto']
    
    if not proto:
        return
    
    sl = proto.segment_list
    seq = 0

    si  = SegmentIterator(sl)
    
    while True:
        
        no_data = False
        queue_empty = False
        
        while True:
            if proto.read_next() is False:
                no_data = False
                break
        try:
            msg = queue.get_nowait()
          
            add_segment_from_message(memo, sl, msg)
        except Empty:
            queue_empty = True
        

        # Try to leave a message in the segment list, so that the next one that comes in 
        # can be linked to it without taking velocity to 0. 
        # Also, allow the queue to exhaust if the final velocity is zero. 
        if len(sl) > 1 or (len(sl) == 1 and sl.segments[0].x == 0): #if memo['queue_time'] < .3:
    
            try:
                s = next(si)
            
                segment_time = int(s.t_seg*1000000)
                
                if segment_time > 0:
            
                    msg = Command(seq, 10, 
                            segment_time=int(s.t_seg*1000000), 
                            v0=[ int(sj.v0) for sj in s.joints ],
                            v1=[ int(sj.v1) for sj in s.joints ], 
                            steps= [ int(sj.x) for sj in s.joints ])
                    
                    proto.write(msg)
                    #print(memo['queue_time'], len(sl), msg)
            
            
                    mcmsg = MotorCommand(
                            seq = seq, 
                            segment_time=int(s.t_seg*1000000), 
                            v0=[ int(sj.v0) for sj in s.joints ],
                            v1=[ int(sj.v1) for sj in s.joints ], 
                            steps= [ int(sj.x) for sj in s.joints ])

                    mcmsg.header.stamp = rospy.Time.now()

                    memo['mcpub'].publish(mcmsg)
                
            
                seq += 1
            
            except StopIteration:
                pass
        elif no_data and queue_empty:
            print ("HERE")

            
        last_qt = memo['queue_time']
            

def message_callback(msg, memo):
    memo['queue'].put(msg)


def recv_callback(memo, proto, resp):
  
    msg = SegmentResponse(
           seq=resp.seq,
           code=resp.code,
           queue_size=resp.queue_size,
           queue_time=float(resp.queue_time) / 1e6,
           queue_min_seq=resp.queue_min_seq,
           min_char_read_time=resp.min_char_read_time,
           max_char_read_time=resp.max_char_read_time,
           min_loop_time=resp.min_loop_time,
           max_loop_time=resp.max_loop_time,
           #steps=resp.steps,
           #encoder_diffs=resp.encoder_diffs
    )

    msg.header.stamp = rospy.Time.now()
    
    memo['pub'].publish(msg)
   
    memo['queue_time'] = float(resp.queue_time ) / 1e6
   
def shutdown(memo):
     
    memo['proto'].close
    
def listener():

    rospy.init_node('motion_controller')

    pub = rospy.Publisher('motion_control/responses', SegmentResponse, queue_size=5)
    
    mcpub = rospy.Publisher('motion_control/motor_command', MotorCommand, queue_size=5)
    
    memo = {
        'queue': Queue(),
        'proto': None,
        'pub': pub, 
        'mcpub': mcpub,
        'seq': 0,
        'queue_time': 0,
        'last_v': [0]*6,
        'timer': None,
        'position': [0]*6,
        'timer': None
        
    }
    
    def recv_callback_wrapper(proto, resp):
        recv_callback(memo, proto, resp) 

    proto = Proto('/dev/arduino_due_host', a_max=100000, v_max=10000, callback=recv_callback_wrapper )
    memo['proto'] = proto
    proto.purge()
    
    worker = Thread(target=send_command_thread, args=(memo,))
    worker.setDaemon(True)
    worker.start()

    rospy.Subscriber("motion_control/segment_command", MotionCommand, message_callback, memo)


    rospy.on_shutdown(lambda: shutdown(memo))


    rospy.spin()

if __name__ == '__main__':
    listener()