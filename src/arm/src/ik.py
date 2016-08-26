from openravepy import *
import numpy, time, rospy

env = Environment()
env.SetViewer('qtcoin')
env.Load('/home/ubuntu/ros_idx6dof/src/arm/src/armbot.kinbody.xml')

robot = env.GetRobots()[0] # get the first robot

manip = robot.SetActiveManipulator('RC_LC') # set the manipulator to leftarm
ikmodel = databases.inversekinematics.InverseKinematicsModel(robot,iktype=IkParameterization.Type.Transform6D)
if not ikmodel.load():
    ikmodel.autogenerate()
x=10
y=10
z=10
for i in range(0, 3000):
	x += 0.01
	y += 0.01
	z += 0.01
	#robot.SetDOFValues([x,y,z])
	print x, y, z
	with env: # lock environment
		Tgoal = numpy.array([[0,-1,0,x],[-1,0,0,y],[0,0,-1,z],[0,0,0,1]])
		sol = manip.FindIKSolution(Tgoal, IkFilterOptions.CheckEnvCollisions) # get collision-free solution
		with robot: # save robot state
		    robot.SetDOFValues(sol,manip.GetArmIndices()) # set the current solution
		    Tee = manip.GetEndEffectorTransform()
		    env.UpdatePublishedBodies() # allow viewer to update new robot
		    raw_input('press any key')
	print sol
