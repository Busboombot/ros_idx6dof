#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Joy
from motion_control.msg import MotionCommand, Segment, JointState, SegmentResponse
from trajectory import freq_map
from time import sleep
from math import copysign
from math import ceil

N_AXES =6

def response_callback(msg, memo):
    
    memo['queue_time'] = float(msg.queue_time ) / 1e6

def timed_callback(event, memo):

    if memo['last_message'] is not None:
        
        data = memo['last_message']

        # Don't repeatedly send if there is no motion. 
        if sum(abs(e) for e in data.axes ) > 0:
            data.header.stamp.secs = event.current_real.secs
            data.header.stamp.nsecs = event.current_real.nsecs
            callback(data, memo)
        else:
            memo['last_message'] = None
   
def callback(data, memo):
    
    
    memo['last_message']  = data
     
    time = data.header.stamp.secs +  data.header.stamp.nsecs/1000000000.
  
    dt = time-memo['last_time']
    
    dt = min(dt,1)
    
    if dt > 100:
        memo['last_time'] = time
        return 
    
    memo['last_time'] = time
    
    if memo['queue_time'] > .5:
        return 
    
    try:
        button = max([i for i,b in enumerate(data.buttons[:4])if b])
    except ValueError:
        button = 0
    
    m =  memo['freq_map'][button]
      
    velocities = [copysign(m(abs(a)), a) for a in data.axes ]     
     
    # if both the previous and the next velocities are all zero, then there is no message to send. 
    if sum(abs(e) for e in (velocities + memo['last_velocities']) ) > 0:
        
        msg = MotionCommand(param_space=MotionCommand.JOINT_SPACE,
                            command_type=MotionCommand.V_COMMAND,
                            exec_type=MotionCommand.IMMEDIATE,
                            t=.1,
                            joints=velocities)

        msg.header.stamp = rospy.Time.now()

        memo['pub'].publish(msg)
            
            
    memo['last_velocities'] = velocities

def listener():

    rospy.init_node('joy_motion_gen')

    #rate = rospy.Rate(10) # In messages per second

    pub = rospy.Publisher('motion_control/segment_command', MotionCommand, queue_size=4)

    memo = {
        'pub': pub, 
        'queue_time': 0,
        'last_message' : None,
        'last_time': 0,
        'freq_map': freq_map,
        'last_velocities': [0]*6
    }

    rospy.Subscriber("joy", Joy, callback, memo)

    rospy.Subscriber("motion_control/responses", SegmentResponse, response_callback, memo)

    rospy.Timer(rospy.Duration(.1), lambda event: timed_callback(event, memo))

    rospy.spin()

if __name__ == '__main__':
    listener()