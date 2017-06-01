#!/usr/bin/env python
import rospy
from motion_control.msg import VelocityCommand, Segment, JointState
from trajectory import Proto, Command, freq_map
from time import sleep

def send_command(proto, memo, d, v0, v1, x):

    
    seq = memo['seq']
    
    msg = Command(seq, 10, d, v0, v1, x)

    print(msg)

    proto.write(msg)

    memo['seq'] = seq + 1


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

    #if memo['timer'] is not None:
    #    memo['timer'].shutdown()

    v0 = memo['last_v'] # The last velocity
    v1 = list(msg.v) # New velocity, from the velocity command, such as the joy_motion node 
    
    # x = vt 
    x = [ .5*(v0_+v1_)*(msg.segment_duration/1000000.) for v0_, v1_ in zip(v0, v1) ]
    
    # Advance the position
    memo['position'] = [ x_+xp_ for x_, xp_ in zip(x, memo['position'])]
    
    # Send the command to the step controller
    # .
    send_command(proto, memo, msg.segment_duration, v0, v1, x)
        
    # set a timer to zero the velocity if we don't get another message in time. 
    #memo['timer'] = rospy.Timer(rospy.Duration(msg.segment_duration-.05), 
    #            lambda event: zero_velocity(event, proto, memo), oneshot=True)
        
    #print msg
    #jm = JointState(joints=memo['position'] ) 
    #jm.header.stamp = rospy.Time.now()
    #memo['pub'].publish(jm)
      
    memo['last_v'] = v1
      
    sleep_tick = 0
    while len(proto)>2: # Allow the recieve buffer thread to clear
        print("Sleeping", sleep_tick)
        sleep(.05)
        sleep_tick += 1
        
    
def recv_callback(m, resp):
    pass
    #print(m, resp)
    
def listener():

    rospy.init_node('motion_controller')

    proto = Proto('/dev/arduino_due_host', callback=recv_callback).open()

    pub = rospy.Publisher('motion_control/joints', JointState, queue_size=4)

    memo = {
        'pub': pub, 
        'seq': 0,
        'last_v': [0]*6,
        'timer': None,
        'position': [0]*6
    }

    
    rospy.Subscriber("motion_control", VelocityCommand, send_callback, (proto,memo))

    rospy.on_shutdown(lambda: proto.proto.close())

    rospy.spin()

if __name__ == '__main__':
    listener()