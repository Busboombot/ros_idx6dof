#!/usr/bin/python

import rospy
from pendant import IDXPendant, find_pendant
from idxpendant.msg import SwitchPos

axes = [0]*6

def recieve_switch(data):
    
    import re
    
    g = re.match(r'axis(\d)', data.switch_name)
    if g:
        axis_n = int(g.groups()[0])
        axes[axis_n] = data.switch_pos
        
        print axes
        

rospy.init_node('pendant_mover', anonymous=False)
rospy.Subscriber('pendant', SwitchPos, recieve_switch)
ticker = rospy.Rate(4) #Per second.

while not rospy.is_shutdown():
	ticker.sleep()
