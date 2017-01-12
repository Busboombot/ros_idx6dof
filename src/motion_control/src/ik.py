#!/usr/bin/env python
import rospy
from motion_control.msg import VelocityCommand, Segment
from trajectory import Proto, Command, freq_map
from time import sleep

def send_command(proto, memo, d, v0, v1, x):
    
    seq = memo['seq']
    
    msg = Command(seq, 10, d, v0, v1, x)
    proto.write(msg)

    memo['seq'] = seq + 1
    
    print memo['position']

def zero_velocity(event, proto, memo):
    
    v0 =  memo['last_v']
    
    if sum(v0) != 0: 
        dt = .25
        v1 = [0]*6
        x = [ .5*(v0_+v1_)*dt  for v0, v1 in zip(v0, v1) ]
        send_command(proto, memo, dt, v0, v1, x)
        memo['last_v'] = v1


def callback(msg, args):

    proto,memo = args

    #if memo['timer'] is not None:
    #    memo['timer'].shutdown()

    v0 = memo['last_v'] # [int(s.v0) for s in msg.segments]
    v1 = [int(s.v1) for s in msg.segments]
    x = [int(s.steps) for s in msg.segments]
    
    memo['position'] = [ x_+xp_ for x_, xp_ in zip(x, memo['position'])]
    
    send_command(proto, memo, msg.segment_duration, v0, v1, x)
        
    # set a timer to zero the velocity if we don't get another message in time. 
    memo['timer'] = rospy.Timer(rospy.Duration(msg.segment_duration-.05), 
                lambda event: zero_velocity(event, proto, memo), oneshot=True)
        
    #print msg
      
    memo['last_v'] = v1
      
    while len(proto)>2: # Allow the recieve buffer thread to clear
        sleep(.05)
    
def listener():

    rospy.init_node('motion_controller')

    proto = Proto('/dev/ttyACM0').open()

    memo = {
        'seq': 0,
        'last_v': [0]*6,
        'timer': None
        'position': [0]*6
    }

    rospy.Subscriber("motion_control", VelocityCommand, callback, (proto,memo))

    rospy.on_shutdown(lambda: proto.proto.close())

    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()

if __name__ == '__main__':
    listener()