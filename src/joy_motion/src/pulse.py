#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Joy
from motion_control.msg import MotionCommand, Segment, SegmentResponse
from trajectory import freq_map
from time import sleep
from math import copysign, sin, pi
from random import randint


N_AXES =6

args = dict(param_space=MotionCommand.JOINT_SPACE,
                    command_type=MotionCommand.V_COMMAND,
                    exec_type=MotionCommand.IMMEDIATE,
                    t=.08)

def message_callback(msg, memo):
    memo['queue_time'] = float(msg.queue_time) / 1e6

def timed_callback(event, memo, pub):
    
    
    if memo['queue_time'] < .5:
        
        memo['index'] += 1
        
        v = int(sin( memo['index'] * (pi/20) )* 600 )

        msg = MotionCommand(joints=[v,0,0,0,0,0], **args)
        msg.header.stamp = rospy.Time.now()
        
        pub.publish(msg)



def do_pulse():

    rospy.init_node('motion_pulse_gen')

    pub = rospy.Publisher('motion_control/segment_command', MotionCommand, queue_size=4)

    memo = {
        'toggle': True,
        'index': 0,
        'queue_time': 0
    }

    rospy.Timer(rospy.Duration(.05), lambda event: timed_callback(event, memo, pub))


    rospy.Subscriber("motion_control/responses", SegmentResponse, message_callback, memo)

    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()

if __name__ == '__main__':
    do_pulse()