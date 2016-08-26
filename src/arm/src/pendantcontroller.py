#!/usr/bin/python

import rospy, sys, signal, time
from pyudev import Context
from serial import Serial
from arm.msg import SwitchPos, Switches

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

class PendantController:

	context = None

	controller = None
	
	publisher = None

	def onShutdown(self):
		self.publisher.publish(self.makeMSG(''))
		self.controller.close()
	
	def findController(self):
		ignored = []
		while self.controller == None and not rospy.is_shutdown():
			devices = self.context.list_devices(subsystem='tty', ID_BUS='usb')
			for device in devices:
				dn = device.device_node
				if dn in ignored:
					continue
				ser = Serial(dn, timeout=0.1, baudrate=115200)
				time.sleep(2)
				resp = query(ser, 'id')
				if resp == 'pendant':
					self.controller = ser
					print 'Found controller at %s'%dn
					return
				elif resp != '':
					ignored += dn
				ser.close()
			print 'Did not find a controller, trying again...'
			time.sleep(2)
		print 'Interrupted'
		
	def makeMSG(self, cmd):
		values = [None]*17
		msg = Switches()
		for c in cmd:
			cL = c.lower()
			if 97 <= ord(cL) <= 123:
				switch = SwitchPos()
				cI = ord(cL) - 97
				switch.pos = SwitchPos.UP if c.isupper() else SwitchPos.DOWN
				values[cI] = switch
		for i in range(len(values)):
			if values[i] == None:
				switch = SwitchPos()
				switch.pos = SwitchPos.NEUTRAL
				values[i] = switch
		msg.positions = values
		return msg
				
	def setupController(self):
		send(self.controller, 'ao')
				
	def setup(self):
		self.findController()
		self.setupController()

	def __init__(self):
		self.context = Context()
		self.publisher = rospy.Publisher('controllerCommands', Switches, queue_size=50)
		rospy.on_shutdown(self.onShutdown)
		
	def loop(self):
		while not rospy.is_shutdown():
			while self.controller.inWaiting():
				line = self.controller.readline()
				if line != '':
					print 'Sending current pendant state: %s'%line[:-2]
					self.publisher.publish(self.makeMSG(line[:-2]))
			time.sleep(0.1)
		print 'Interrupted. Sending stop command.'
		

rospy.init_node("pendantController", anonymous=False)
contr = PendantController()
contr.setup()
contr.loop()
