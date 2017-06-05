#!/usr/bin/env python
from __future__ import print_function
import rospy
from motion_control.msg import MotionCommand, Segment, SegmentResponse
from trajectory import Proto, Command, freq_map, TimeoutException, SegmentList, SegmentIterator, SegmentError
from time import sleep
from Queue import Queue, Empty
from threading import Thread


def add_segment_from_message(memo, segment_list, msg):
    
    if (msg.exec_type == MotionCommand.IMMEDIATE and len(segment_list)  > 3):
        
        # drop the message
        print("Dropping")
        return 
    
    
    if msg.command_type == MotionCommand.V_COMMAND:
        
        if msg.t > 0:
            try:
                segment_list.add_velocity_segment(msg.joints,t=msg.t)
            except SegmentError as e:
                print("ERROR", e)
        else:
            pass
        
    else:
        if msg.t > 0:
            try:
                segment_list.add_distance_segment(msg.joints,t=msg.t)
            except SegmentError as e:
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
    last_done = None
    last_qt = None
    
    while True:
        
        while True:
            if proto.read_next() is False:
                break
            
        if last_done != proto.last_done:
         
            last_done = proto.last_done

        try:
            msg = queue.get_nowait()
          
            add_segment_from_message(memo, sl, msg)
        except Empty:
            pass
        
        # Try to leave a message in the segment list, so that the next one that comes in 
        # can be linked to it without taking velocity to 0. 
        if memo['queue_time'] < .3:
    
            try:
                s = next(si)
            
                msg = Command(seq, 10, 
                        segment_time=int(s.t_seg*1000000), 
                        v0=[ int(sj.v0) for sj in s.joints ],
                        v1=[ int(sj.v1) for sj in s.joints ], 
                        steps= [ int(sj.x) for sj in s.joints ])
                    
                proto.write(msg)
                print(memo['queue_time'], len(sl), msg)
            
                seq += 1
            
            except StopIteration:
                pass
        elif last_qt != memo['queue_time']:
            print(memo['queue_time'], len(sl))
            
        last_qt = memo['queue_time']
            

def message_callback(msg, memo):
    memo['queue'].put(msg)


def recv_callback(memo, proto, resp):
  
    msg = SegmentResponse(
           seq=resp.seq,
           code=resp.code,
           queue_size=resp.queue_size,
           queue_time=resp.queue_time,
           queue_min_seq=resp.queue_min_seq,
           min_char_read_time=resp.min_char_read_time,
           max_char_read_time=resp.max_char_read_time,
           min_loop_time=resp.min_loop_time,
           max_loop_time=resp.max_loop_time,
           #steps=resp.steps,
           #encoder_diffs=resp.encoder_diffs
    )

    memo['pub'].publish(msg)
   
    memo['queue_time'] = float(resp.queue_time ) / 1e6
   
def shutdown(memo):
     
    memo['proto'].close
    
def listener():

    rospy.init_node('motion_controller')


    pub = rospy.Publisher('motion_control/responses', SegmentResponse, queue_size=10)

    memo = {
        'queue': Queue(),
        'proto': None,
        'pub': pub, 
        'seq': 0,
        'queue_time': 0,
        'last_v': [0]*6,
        'timer': None,
        'position': [0]*6,
        'timer': None
    }
    
    def recv_callback_wrapper(proto, resp):
        recv_callback(memo, proto, resp) 

    proto = Proto('/dev/arduino_due_host', a_max=50000, v_max=10000, callback=recv_callback_wrapper )
    memo['proto'] = proto
    proto.purge()
    
  
    worker = Thread(target=send_command_thread, args=(memo,))
    worker.setDaemon(True)
    worker.start()

    #memo['timer'] = rospy.Timer(rospy.Duration(1), lambda event: timed_callback( event, memo))
    
    rospy.Subscriber("motion_control/commands", MotionCommand, message_callback, memo)

    rospy.on_shutdown(lambda: shutdown(memo))


    rospy.spin()

if __name__ == '__main__':
    listener()