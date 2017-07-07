import vrep
import math
import time

print 'Program started'
vrep.simxFinish(-1) # just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19997,True,True,5000,5)

if clientID!=-1:
    print 'Connected to remote API server'

    opm = vrep.simx_opmode_blocking

    #res,objects=vrep.simxGetObjects(clientID,vrep.sim_handle_all, opm)

    code, handles, int_d, float_d, str_d = \
       vrep.simxGetObjectGroupData(clientID, vrep.sim_object_joint_type, 0, opm)


    for s, h in zip(str_d, handles):
       vrep.simxSetJointPosition(clientID, h, 0, opm)

    for s, h in zip(str_d, handles):
       print(s)
       vrep.simxSetJointTargetPosition(clientID, h, math.radians(5), opm)

    dt = 0.01

    vrep.simxSetFloatingParameter(clientID,
            vrep.sim_floatparam_simulation_time_step,
            dt, # specify a simulation time step
            vrep.simx_opmode_oneshot)

    vrep.simxSynchronous(clientID,True)

    vrep.simxStartSimulation(clientID, vrep.simx_opmode_oneshot)


    t = 0

    while t < 1:

        for s, h in zip(str_d, handles):
           ret, p = vrep.simxGetJointPosition(clientID, h, opm)
           print(h,p)
        print("-----")

        vrep.simxSynchronousTrigger(clientID)
        t += dt

        time.sleep(1)

    vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot_wait);
    vrep.simxFinish(clientID)
else:

    print 'Failed connecting to remote API server'

print 'Program ended'
