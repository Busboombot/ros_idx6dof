#!/usr/bin/python

import rospy
from arm.srv import IKService, IKServiceResponse

rospy.init_node("asdf", anonymous=True)

rospy.wait_for_service('IKService')

srv = rospy.ServiceProxy('IKService', IKService)

resp = srv([5, 16, 8, 0, 0, 0], None)

print resp
