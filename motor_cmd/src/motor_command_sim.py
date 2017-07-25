#!/usr/bin/env python
from __future__ import print_function
import rospy
from time import sleep
from motor_cmd.msg import MotionCommand, MotorCommand, Segment, SegmentResponse
import vrep
import math
import time
from functools import partial

def callback(clientID, msg):

    #############################
    ONE_REV = 360 #degrees
    STEPS_TO_REV = 65536 # Steps in one rev
    
    # 360 degrees = STEPS_TO_REV Dteps 
    # POS_DEGREES = POS_STEPS
    # POS_DEGREES = (ONE_REV * POS_STEPS) / STEPS_TO_REV
    
    
    opm = vrep.simx_opmode_blocking

        #res,objects=vrep.simxGetObjects(clientID,vrep.sim_handle_all, opm)

    code, handles, int_d, float_d, str_d = \
       vrep.simxGetObjectGroupData(clientID, vrep.sim_object_joint_type, 0, opm)
           
        # Extracting handle for the waist
    errorCode,waist=vrep.simxGetObjectHandle(clientID,'waist',vrep.simx_opmode_oneshot_wait)
        # Extracting handle for shoulder 1
    errorCode,shoulder_1=vrep.simxGetObjectHandle(clientID,'shoulder1',vrep.simx_opmode_oneshot_wait)
        # Extracting handle for shoulder 2
    errorCode,shoulder_2=vrep.simxGetObjectHandle(clientID,'shoulder2',vrep.simx_opmode_oneshot_wait)
        # Extracting handle for the elbow
    errorCode,elbow=vrep.simxGetObjectHandle(clientID,'elbow',vrep.simx_opmode_oneshot_wait)
        # Extracting handle for the wrist 1
    errorCode,wrist_1=vrep.simxGetObjectHandle(clientID,'wrist1',vrep.simx_opmode_oneshot_wait)
        # Extracting handle for the wrist 2
    errorCode,wrist_2=vrep.simxGetObjectHandle(clientID,'wrist2',vrep.simx_opmode_oneshot_wait)
        
        #for s, h in zip(str_d, handles):
           #print(s,h)
           #vrep.simxSetJointTargetPosition(clientID, h, math.radians(60), opm)
           #vrep.simxSetJointTargetVelocity(clientID, h, (memo['last_v'][0]*ONE_REV)/STEPS_TO_REV, opm)
    for y in range(0,6):
        print(msg.steps[y]) 
    print("Updating joint positions!")
    vrep.simxSetJointTargetPosition(clientID, waist, msg.steps[0]*ONE_REV/STEPS_TO_REV, opm)
    vrep.simxSetJointTargetPosition(clientID, shoulder_1, math.radians(msg.steps[1]*ONE_REV/STEPS_TO_REV), opm)
    vrep.simxSetJointTargetPosition(clientID, shoulder_2, msg.steps[2]*ONE_REV/STEPS_TO_REV, opm)
    vrep.simxSetJointTargetPosition(clientID, elbow, msg.steps[3]*ONE_REV/STEPS_TO_REV, opm)
    vrep.simxSetJointTargetPosition(clientID, wrist_1,msg.steps[4]*ONE_REV/STEPS_TO_REV, opm)
    vrep.simxSetJointTargetPosition(clientID, wrist_2, msg.steps[5]*ONE_REV/STEPS_TO_REV, opm)
          
    
    dt = 0.05
    vrep.simxSetFloatingParameter(clientID,
             vrep.sim_floatparam_simulation_time_step,
             dt, # specify a simulation time step
             vrep.simx_opmode_oneshot)

    vrep.simxSynchronous(clientID,True)

    vrep.simxStartSimulation(clientID, vrep.simx_opmode_oneshot)


    t = 0.0

    while t < (msg.segment_time/1000000):
     
        for s, h in zip(str_d, handles):
           ret, p = vrep.simxGetJointPosition(clientID, h, opm)
           print(h,p)
		       
        for y in range(0,6):
           print(msg.steps[y]*ONE_REV/STEPS_TO_REV) 

        print("-----")

        vrep.simxSynchronousTrigger(clientID)
        t += dt
        time.sleep(0.1)



    

    
        
    #############################



def listener():

    rospy.init_node('mtr_cmd_sim')
    print ("Program started")
    vrep.simxFinish(-1) # just in case, close all opened connections
    ip='192.168.6.175'#rospy.get_param("/vrep_ip") # Gets ip from the param server
    clientID=vrep.simxStart(ip,19997,True,True,5000,5)
    if clientID!=-1:
        print ("Connected to remote API server")
        rospy.Subscriber("motion_control/motor_command", MotorCommand, partial(callback, clientID))
        print("Back @ listener")
        rospy.spin()
    else:
        print ("Failed connecting to remote API server")

    while not rospy.is_shutdown():
        print ("Program ended")
        vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot_wait);
        vrep.simxFinish(clientID)


if __name__ == '__main__':
    listener()




