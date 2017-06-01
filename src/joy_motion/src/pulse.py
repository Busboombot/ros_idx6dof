#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Joy
from motion_control.msg import VelocityCommand, Segment
from trajectory import freq_map
from time import sleep
from math import copysign

N_AXES =6


def timed_callback(event, memo, pub):
    
    v = 600 if memo[0] else 0
    memo[0] = not memo[0]

    print v, memo

    msg = VelocityCommand(segment_duration=1*1e6, 
                          param_space=VelocityCommand.JOINT_SPACE,
                          v=[v,0,0,0,0,0])
    pub.publish(msg)
    

def do_pulse():

    rospy.init_node('motion_pulse_gen')

    rate = rospy.Rate(6) # In messages per second

    pub = rospy.Publisher('motion_control', VelocityCommand, queue_size=4)

    memo = [True]

    rospy.Timer(rospy.Duration(1), lambda event: timed_callback(event, memo, pub))


    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()

if __name__ == '__main__':
    do_pulse()