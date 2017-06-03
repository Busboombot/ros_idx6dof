#!/usr/bin/env python
import rospy
from motion_control.msg import VelocityCommand, Segment, JointState
from trajectory import Proto, Command, freq_map, TimeoutException
from time import sleep

def send_command(proto, memo, d, v0, v1, x):

    seq = memo['seq']
    
    msg = Command(seq, 10, d, v0, v1, x)

    proto.write(msg)

    memo['seq'] = seq + 1


    #try:
    #    proto.wait_done(seq-2) # Wait until there are only 2 outstanding segments
    #except TimeoutException:
    #    pass

def zero_velocity(event, proto, memo):
    
    v0 =  memo['last_v']
    
    if sum(v0) != 0: 
        print("Zeroing Velocity")
        dt = .25
        v1 = [0]*6
        x = [ .5*(v0_+v1_)*dt  for v0, v1 in zip(v0, v1) ]
        send_command(proto, memo, dt, v0, v1, x)
        memo['last_v'] = v1


def send_callback(msg, args):

    proto,memo = args

    proto.wait_backlog(2)
        
    #if memo['timer'] is not None:
    #    memo['timer'].shutdown()

    v0 = memo['last_v'] # The last velocity
    v1 = list(msg.v) # New velocity, from the velocity command, such as the joy_motion node 
    
    duration = msg.segment_duration * 1.1
   
    # x = vt 
    x = [ .5*(v0_+v1_)*(duration/1000000.) for v0_, v1_ in zip(v0, v1) ]
    
    
    # Advance the position
    memo['position'] = [ x_+xp_ for x_, xp_ in zip(x, memo['position'])]
    
    # Send the command to the step controller
    # .
  
    send_command(proto, memo, duration, v0, v1, x)
        
    # set a timer to zero the velocity if we don't get another message in time. 
    #memo['timer'] = rospy.Timer(rospy.Duration(msg.segment_duration-.05), 
    #            lambda event: zero_velocity(event, proto, memo), oneshot=True)
        
    
    
    jm = JointState(joints=memo['position'] ) 
    jm.header.stamp = rospy.Time.now()
    memo['pub'].publish(jm)
      
    memo['last_v'] = v1
       
    if memo['timer']:
        memo['timer'].shutdown()
    
    memo['timer'] = rospy.Timer(rospy.Duration(1), lambda event: timed_callback(event, memo), oneshot=True)

def timed_callback(event, memo):

    if memo['timer']:
        memo['timer'].shutdown()
        memo['timer'] = None
        
    
def recv_callback(m, resp):
    pass
    #print(m, resp)
    
def listener():

    rospy.init_node('motion_controller')

    proto = Proto('/dev/arduino_due_host', callback=recv_callback)

    proto.purge()

    pub = rospy.Publisher('motion_control/joints', JointState, queue_size=4)

    memo = {
        'pub': pub, 
        'seq': 0,
        'last_v': [0]*6,
        
        'timer': None,
        'position': [0]*6,
        'timer': None
    }
    
    rospy.Subscriber("motion_control", VelocityCommand, send_callback, (proto,memo))

    rospy.on_shutdown(lambda: proto.close())


    rospy.spin()

if __name__ == '__main__':
    listener()