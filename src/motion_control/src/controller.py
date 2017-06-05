#!/usr/bin/env python
from __future__ import print_function
import rospy
from motion_control.msg import MotionCommand, Segment, JointState
from trajectory import Proto, Command, freq_map, TimeoutException, SegmentList, SegmentIterator, SegmentError
from time import sleep
from Queue import Queue, Empty
from threading import Thread


def add_segment_from_message(segment_list, msg):
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
            pass
        else:
            pass

def send_command_thread(memo):
    
    queue = memo['queue']
    proto = memo['proto']
    sl = memo['proto'].segment_list
    seq = 0

    si  = SegmentIterator(sl)
    last_done = None
    
    while True:
        
        while True:
            if proto.read_next() is False:
                break
            
            
        if last_done != proto.last_done:
            print(proto.queue_length, proto.queue_time, len(proto.sent) )
            last_done = proto.last_done
            
       

        try:
            msg = queue.get_nowait()
            add_segment_from_message(sl, msg)
        except Empty:
            pass
        
    
        try:
            s = next(si)
            
            msg = Command(seq, 10, 
                    segment_time=int(s.t_seg*1000000), 
                    v0=[ int(sj.v0) for sj in s.joints ],
                    v1=[ int(sj.v1) for sj in s.joints ], 
                    steps= [ int(sj.x) for sj in s.joints ])
                    
            proto.write(msg)
            #print(msg)
            
            seq += 1
            
        except StopIteration:
            pass



def message_callback(msg, memo):

    memo['queue'].put(msg)
    
    return 

    for i, s in enumerate(SegmentIterator(proto.segment_list)):
        memo['queue'].put(
            dict(
                
                )
        )


            

    #jm = JointState(joints=memo['position'] ) 
    #jm.header.stamp = rospy.Time.now()
    #memo['pub'].publish(jm)


def recv_callback(m, resp):
    pass
    #print(m, resp)
   
   
def shutdown(memo):
     
    memo['proto'].close
    
def listener():

    rospy.init_node('motion_controller')

    proto = Proto('/dev/arduino_due_host', a_max=50000, v_max=10000, callback=recv_callback)

    proto.purge()

    pub = rospy.Publisher('motion_control/joints', JointState, queue_size=4)

    memo = {
        'queue': Queue(),
        'proto': proto,
        'pub': pub, 
        'seq': 0,
        'last_v': [0]*6,
        'timer': None,
        'position': [0]*6,
        'timer': None
    }

    worker = Thread(target=send_command_thread, args=(memo,))
    worker.setDaemon(True)
    worker.start()

    #memo['timer'] = rospy.Timer(rospy.Duration(1), lambda event: timed_callback( event, memo))
    
    rospy.Subscriber("motion_control", MotionCommand, message_callback, memo)

    rospy.on_shutdown(lambda: shutdown(memo))


    rospy.spin()

if __name__ == '__main__':
    listener()