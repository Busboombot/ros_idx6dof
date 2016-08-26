#!/usr/bin/python

import rospy, sys, signal
from pyudev import Context
from serial import Serial
from std_msgs.msg import String
from arm.msg import SwitchPos, Switches, Command

class CommandInterpreter:

	currentCommand = None
	
	updateRate = None
	ticker = None
	
	cmdPublisher = None

	stop = None

	def onShutdown(self):
		self.currentCommand = self.stop
		self.sendCommand()
	
	def makeCommandMessage(self, cmd):
		posArr = cmd.positions
		speed = 35 if posArr[0].pos == -1 else 70 if posArr[0].pos == 0 else 100
		cmdMsg = Command()
		cmdMsg.cmd = ord('t')
		params = [0]*7
		params[0] = 2000/self.updateRate
		for i in range(2, 8):
			params[i-1] = posArr[i].pos*speed
		cmdMsg.params = params
		self.currentCommand = cmdMsg
		print "Sending command to Robot Controller: %s"%cmdMsg
	
	def sendCommand(self):
		self.cmdPublisher.publish(self.currentCommand)
	
	def commandReceiver(self, data):
		self.makeCommandMessage(data)
		self.sendCommand()
		
	

	def loop(self):
		while not rospy.is_shutdown():
			self.sendCommand()
			self.ticker.sleep()
		print 'Interrupted. Sending stop command.'	
		
	def __init__(self):
		rospy.init_node('commandInterpreter', anonymous=False)
		rospy.Subscriber('controllerCommands', Switches, self.commandReceiver)
		self.cmdPublisher = rospy.Publisher('robotCommands', Command, queue_size=15)
		self.context = Context()
		self.speed = 0
		self.stop = Command()
		self.stop.cmd = ord('s')
		self.currentCommand = self.stop
		self.updateRate = rospy.get_param('cmd_send_rate') if rospy.has_param('cmd_send_rate') else 4
		self.ticker = rospy.Rate(self.updateRate) #Per second.
		rospy.on_shutdown(self.onShutdown)
		
	
ci = CommandInterpreter()
ci.loop()
