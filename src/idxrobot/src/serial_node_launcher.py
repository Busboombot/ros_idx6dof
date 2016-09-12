#!/usr/bin/env python
#  Runs serial clients on any USB TTY devices that are plugged in, 
# ignoring the ones that don't sync with rosserial

__author__ = 'Eric Busboom <eric@busboom.org>'

import rospy
import time
import sys
import subprocess
from pyudev import Context
from serial import Serial

                
    
if __name__=="__main__":

    rospy.init_node("serial_node_launcher")
    rospy.loginfo("ROS Serial Python Node")

    port_name = rospy.get_param('~port','/dev/ttyUSB0')
    baud = int(rospy.get_param('~baud','57600'))

    processes = {}

    ignore_devices = set()


    try:
        while True and not rospy.is_shutdown():
        
            for device, process in processes.items():
                if process.poll() is not None:
                    del processes[device]
                    if process.returncode > 0:
                        rospy.loginfo("Device {} failed, marking as ignored".format(device))
                        ignore_devices.add(device)
                    else:
                        rospy.loginfo("Device {} disconnected".format(device))
                        
            time.sleep(.5)
                
            new_devices = [device.device_node for device in Context().list_devices(subsystem='tty', ID_BUS='usb')
                           if device.device_node not in processes and device.device_node not in ignore_devices]
        
            for d in new_devices:

                p = subprocess.Popen("rosrun idxrobot serial_node.py {}".format(d), shell=True)
                processes[d] = p
                rospy.loginfo("New device {} added".format(d))

            
    finally:      
        for device, process in processes.items():
            rospy.loginfo("Shutting down process %r", process)
            process.terminate()
            process.wait()
        

        