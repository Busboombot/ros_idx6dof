#!/usr/bin/env python
#  Runs serial clients on any USB TTY devices that are plugged in, 
# ignoring the ones that don't sync with rosserial

__author__ = 'Eric Busboom <eric@busboom.org>'

import rospy
from SerialClient import SerialClient, RosSerialServer, SerialError
import multiprocessing
import Queue
import termios
import time
import sys

        
if __name__=="__main__":
                 
    sys.argv = rospy.myargv(argv=sys.argv)

    port_name  = sys.argv[1]
    baud = int(rospy.get_param('~baud','57600'))
    
    rospy.init_node("serial_node_{}".format(port_name.replace('/','_')))

    rospy.loginfo("Connecting to %s at %d baud" % (port_name,baud) )

    try:
        client = SerialClient(port_name, baud, timeout=1)
        client.run()
    except termios.error:
        rospy.loginfo("disconnected: {}".format(port_name) )
        sys.stdout.flush()
        sys.exit(0)

    except SerialError as e:
        rospy.logerr("failed: {}: {}".format(e.message, port_name) )
        sys.stdout.flush()
        sys.exit(1)




        