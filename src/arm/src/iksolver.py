#!/usr/bin/python

import rospy
import numpy as np
from openravepy import *
from math import sin, cos
from arm.srv import IKService, IKServiceResponse

class IKSolver:
	
	env = None
	bot = None
	manip = None  #There isn't actually a claw defined, but whatever.

	ik3DOF = None
	ik6DOF = None
	
	def find6DOFSol(self, inputs):
		self.ik6DOF.load()
		theta = inputs[3] #yaw
		phi = inputs[4] #pitch
		rho = inputs[5] #roll
		x = inputs[0]
		y = inputs[1]
		z = inputs[2]
		ct = cos(theta)
		st = sin(theta)
		cp = cos(phi)
		sp = sin(phi)
		cr = cos(rho)
		sr = sin(rho)
		t =  np.array([[ct*cp,-ct*sp*cr+st*sr,ct*sp*sr+st*cr, x],[sp, cp*cr, -cp*sr, y],[-st*cp, st*sp*cr+ct*sr, -st*sp*sr+ct*cr, z],[0, 0, 0, 1]]) 	
		return self.manip.FindIKSolution(t, IkFilterOptions.CheckEnvCollisions)
	
	def find3DOFSol(self, inputs):
		self.ik3DOF.load()
		param = IkParameterization(np.array([[0,0,0],inputs]), IkParameterization.Type.TranslationLocalGlobal6D)#The y value magic numbered in here should be the location of the tip of the arm relative to wristB's joint. Or maybe not, I'm not quite sure if there's a difference between using TranslationLocalGlobal or Translation3D as they both lock three joints. A program could probably be written to take the best solution using Transform6DOF using various
		return self.manip.FindIKSolution(param, IkFilterOptions.CheckEnvCollisions)
	
	def findIKSolService(self, req):
		dat = req.target
		if len(dat) == 3: #Given only three values (x,y,z), IK will be solved for regardless of orientation.
			return IKServiceResponse(self.find3DOFSol(dat))
		elif len(dat) == 6: #Given six values (x,y,z,theta,phi,rho), IK will be solved ensuring an orientation.
			return IKServiceResponse(self.find6DOFSol(dat))
		else: #Otherwise, what are you giving me?
			return IKServiceResponse(None)
			
	def start(self):
			
		rospy.init_node("IKSolver", anonymous=False)
		rospy.Service("IKService", IKService, self.findIKSolService)
		rospy.spin()
		
	
	def __init__(self):
		self.env = Environment()
		self.env.Load('env.env.xml')
		self.bot = self.env.GetRobots()[0]
		self.manip = self.bot.SetActiveManipulator("RC_LC")
		self.ik6DOF = databases.inversekinematics.InverseKinematicsModel(self.bot,iktype=IkParameterization.Type.Transform6D)
		self.ik3DOF = databases.inversekinematics.InverseKinematicsModel(self.bot,iktype=IkParameterization.Type.TranslationLocalGlobal6D) #A 3DOF solution must have only three joints. These can (and probably should) be tampered with using freejoints=["jointA","jointB"...]. The defaults seem to be the waist and wrists.
		if not self.ik3DOF.load(): #Generating a new one takes several minutes.
			print "Making point-only IK model..."
			self.ik3DOF.autogenerate()
			print "Made point-only IK model."
		if not self.ik6DOF.load(): #If there isn't a model in the database, this will make a new one for each. For some reason it is impossible to have both loaded.
			print "Making 6DOF IK model..."
			self.ik6DOF.autogenerate()
			print "Made 6DOF IK model."
		

solver = IKSolver()
solver.start()
		
	
