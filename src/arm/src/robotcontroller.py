#!/usr/bin/python

import rospy, time
from arm.msg import Command
from serial import Serial
from pyudev import Context

def query(ser, q):
	ser.write(q + '\r\n')
	resp = ser.readline()
	if len(resp) >= 2:
		return resp[:-2]
	ser.flushInput()
	ser.flushOutput()
	return resp
	
def send(ser, msg):
	ser.flushInput()
	ser.flushOutput()
	ser.write(msg + '\r\n')

class RobotController:

	bot = None
	
	context = None

	maxSpeed = None

	def onShutdown(self):
		send(self.bot, 's')
		print 'Interrupted, sending stop signal.'
 

	def findRobot(self):
		ignored = []
		while self.bot == None and not rospy.is_shutdown():
			devices = self.context.list_devices(subsystem='tty', ID_BUS='usb')
			for device in devices:
				dn = device.device_node
				if dn in ignored:
					continue
				ser = Serial(dn, timeout=0.1, baudrate=115200)
				time.sleep(2)
				resp = query(ser, 'id')
				if resp == 'stepper':
					self.bot = ser
					send(ser, 'ms ' + str(self.maxSpeed))
					print 'Found robot controller at %s'%dn
					return
				elif resp != '':
					ignored += dn
				ser.close()
			print 'Did not find a robot controller, trying again...'
			time.sleep(2)
		print 'Interrupted'
		
	def unpackCommand(self, cmd):
		out = str(chr(cmd.cmd))
		for param in cmd.params:
			out += ' ' + str(param)
		return out
		
	def receiveCommand(self, cmd):
		cmdStr = self.unpackCommand(cmd)
		print 'Sending command string to bot: %s'%cmdStr
		send(self.bot, cmdStr)
	
	def __init__(self):
		rospy.init_node('robotController', anonymous=False)
		self.maxSpeed = rospy.get_param('max_joint_speed') if rospy.has_param('max_joint_speed') else 500
		self.context = Context()
		self.findRobot()
		rospy.Subscriber('robotCommands', Command, self.receiveCommand)
		rospy.on_shutdown(self.onShutdown)

		
		
rc = RobotController()
rospy.spin()
	
