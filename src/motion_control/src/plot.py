#!/usr/bin/env python
from __future__ import print_function
import rospy

from motion_control.msg import  SegmentResponse

from streamplot import PlotManager

def callback(data, memo):
    
    
    memo.plot.add(name="queue_time", x=data.header.stamp.secs, y=data.queue_size)
    memo.plot.update()
    
    print(data.header.stamp.secs,data.queue_size)
    

class Memo(object):
    
    def __init__(self):
        
        self.plot = PlotManager(title="Motion")
        self.start_time  =  rospy.Time.now()
        
        
    

def listener():

    rospy.init_node('motion_plot')
    
    memo = Memo()

    rospy.Subscriber("motion_control/responses", SegmentResponse, callback, memo)


    rospy.spin()

if __name__ == '__main__':
    listener()