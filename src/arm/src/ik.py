from openravepy import *
from math import *
import numpy, time, sys

env = Environment()
env.SetViewer('qtcoin')
env.Load('env.env.xml')

robot = env.GetRobots()[0] # get the first robot

manip = robot.SetActiveManipulator('RC_LC') # set the manipulator to leftarm
ikmodel = databases.inversekinematics.InverseKinematicsModel(robot,iktype=IkParameterization.Type.Transform6D)
if not ikmodel.load():
	print "Making kinematics model..."
	ikmodel.autogenerate()
x=-10
y=10
z=-10

theta = pi #yaw
phi = pi/4#pitch
rho = 0#roll

rot =  numpy.array([[cos(theta)*cos(phi),-cos(theta)*sin(phi)*cos(rho)+sin(theta)*sin(rho),cos(theta)*sin(phi)*sin(rho)+sin(theta)*cos(rho)],[sin(phi), cos(phi)*cos(rho), -cos(phi)*sin(rho)],[-sin(theta)*cos(phi), sin(theta)*sin(phi)*cos(rho)+cos(theta)*sin(rho), -sin(theta)*sin(phi)*sin(rho)+cos(theta)*cos(rho)]])#numpy.array([[sin(theta),0,0],[sin(phi),-cos(rho),sin(rho)],[-cos(theta),0,0]])



for i in range(0, 3000):
	x = 15*sin(i/10.0)
	y += 0.1
	z = 15*cos(i/10.0)
	print x, y, z
	with env: # lock environment
		t = numpy.hstack((rot, numpy.array([[x],[y],[z]])))
		t = numpy.vstack((t,numpy.array([0,0,0,1])))
		print t
		Tgoal = t#numpy.array([[0,-1,0,x],[-1,0,0,y],[0,0,-1,z],[0,0,0,1]])
		sol = manip.FindIKSolution(Tgoal, IkFilterOptions.CheckEnvCollisions) # get collision-free solution
		print sol
		with robot: # save robot state
		    robot.SetDOFValues(sol,manip.GetArmIndices()) # set the current solution
		    Tee = manip.GetEndEffectorTransform()
		    env.UpdatePublishedBodies() # allow viewer to update new robot
		    raw_input('press any key')
