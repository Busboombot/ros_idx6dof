#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Joy
from motion_control.msg import MotionCommand, Segment, SegmentResponse
from trajectory import freq_map
from time import sleep
from math import copysign
from random import randint

N_AXES =6



def message_callback(msg, memo):
    memo['queue_time'] = msg.queue_time

def timed_callback(event, memo, pub):
    
    if memo['queue_time'] < 1e6:
        
        sgn = -1 if memo['toggle'] else 1
        memo['toggle'] = not memo['toggle']

        x = randint(50,300)

        for i in range(4):
            args = dict(param_space=MotionCommand.JOINT_SPACE,
                                command_type=MotionCommand.X_COMMAND,
                                exec_type=MotionCommand.IMMEDIATE,
                                t=.5)

            msg = MotionCommand(joints=[sgn*x,0,0,0,0,0], **args)
    

            pub.publish(msg)
    

def do_pulse():

    rospy.init_node('motion_pulse_gen')

    pub = rospy.Publisher('motion_control/commands', MotionCommand, queue_size=4)

    memo = {
        'toggle': True,
        'queue_time': 0
    }

    rospy.Timer(rospy.Duration(.2), lambda event: timed_callback(event, memo, pub))


    rospy.Subscriber("motion_control/responses", SegmentResponse, message_callback, memo)

    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()

if __name__ == '__main__':
    do_pulse()