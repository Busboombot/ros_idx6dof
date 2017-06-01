#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Joy
from motion_control.msg import VelocityCommand, Segment
from trajectory import freq_map
from time import sleep
from math import copysign

N_AXES =6

def timed_callback(event, memo):

    if memo['last_message'] is not None:
        data = memo['last_message']
        data.header.stamp.secs = event.current_real.secs
        data.header.stamp.nsecs = event.current_real.nsecs
        callback(data, memo)
        
def callback(data, memo):
    
    memo['last_message']  = data
     
    time = data.header.stamp.secs +  data.header.stamp.nsecs/1000000000.
  
    dt = time-memo['last_time']
    
    dt = min(dt,1)
    
    if dt > 100:
        memo['last_time'] = time
        return 
    
    if dt >= .1 :
        memo['last_time'] = time
        
        try:
            button = max([i for i,b in enumerate(data.buttons[:4])if b])
        except ValueError:
            button = 0
        
        m =  memo['freq_map'][button]
          
        velocities = [copysign(m(abs(a)), a) for a in data.axes ]     
         
        # if both the previous and the next velocities are all zero, then there is no message to send. 
        if sum(abs(e) for e in (velocities + memo['last_velocities']) ) > 0:
            
            msg = VelocityCommand(segment_duration=dt*1e6, param_space=VelocityCommand.JOINT_SPACE )
            
            msg.v = velocities
        
            memo['pub'].publish(msg)
            memo['seq'] = memo['seq'] + 1
      
            
        memo['last_velocities'] = velocities


def listener():

    # In ROS, nodes are uniquely named. If two nodes with the same
    # node are launched, the previous one is kicked off. The
    # anonymous=True flag means that rospy will choose a unique
    # name for our 'listener' node so that multiple listeners can
    # run simultaneously.
    rospy.init_node('joy_motion_gen')

    rate = rospy.Rate(10) # In messages per second

    pub = rospy.Publisher('motion_control', VelocityCommand, queue_size=4)

    memo = {
        'pub': pub, 
        'seq': 0,
        'last_message' : None,
        'last_time': 0,
        'freq_map': freq_map,
        'last_velocities': [0]*6
    }

    rospy.Subscriber("joy", Joy, callback, memo)

    rospy.Timer(rospy.Duration(.1), lambda event: timed_callback(event, memo))

    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()

if __name__ == '__main__':
    listener()