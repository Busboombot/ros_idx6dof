#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Joy
from motion_control.msg import MotionCommand, Segment
from trajectory import freq_map
from time import sleep
from math import copysign

N_AXES =6


def timed_callback(event, memo, pub):
    
    sgn = -1 if memo[0] else 1
    memo[0] = not memo[0]

    x = 10000

    args = dict(param_space=MotionCommand.JOINT_SPACE,
                        command_type=MotionCommand.X_COMMAND,
                        exec_type=MotionCommand.IMMEDIATE,
                        t=2)

    msg = MotionCommand(joints=[sgn*x,0,0,0,0,0], **args)
    

    pub.publish(msg)
    

def do_pulse():

    rospy.init_node('motion_pulse_gen')

    pub = rospy.Publisher('motion_control', MotionCommand, queue_size=4)

    memo = [True]

    rospy.Timer(rospy.Duration(.95), lambda event: timed_callback(event, memo, pub))


    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()

if __name__ == '__main__':
    do_pulse()