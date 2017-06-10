#!/usr/bin/python

import rospy
from std_msgs.msg import String as StringMessage
from pendant import switch_pos, axes_positions

def recieve_switch(data):
    
    print switch_pos('speed', data), switch_pos('step', data), axes_positions(data)

rospy.init_node('pendant_mover', anonymous=False)
rospy.Subscriber('pendant_str', StringMessage, recieve_switch)
ticker = rospy.Rate(4) #Per second.

while not rospy.is_shutdown():
	ticker.sleep()