#!/usr/bin/python



import rospy
from pendant import IDXPendant, find_pendant
from idxpendant.msg import SwitchPos
from idxpendant.srv import SwitchSrv, SwitchesSrv



def handle_switch_request(pendant, req):
    
    from idxpendant.srv import SwitchSrvResponse

    (n, name, state ) = pendant[req.switch_ref]
    
    r =  SwitchSrvResponse(
        time = rospy.Time.now(),
        switch_no = n,
        switch_pos = state,
        switch_name = name
    )
    
    print r
    
    return r
    
def handle_switches_request(pendant):
    
    from idxpendant.srv import SwitchesSrvResponse

    switches = []
    
    for n, state in enumerate(pendant.switch_states):
        switches.append(
            SwitchPos(
                switch_no = n,
                switch_pos = state,
                switch_name = pendant.switch_names[n])
        )

    
    return switches
    
    
def run_publisher(pendant, publisher):
    for n, name, state in pendant.run():
        msg = SwitchPos(
            time = rospy.Time.now(),
            switch_no = n,
            switch_pos = state,
            switch_name = name
        )
  
        publisher.publish(msg)


rospy.init_node("pendant", anonymous=False)

publisher = rospy.Publisher('pendant', SwitchPos, queue_size=50)
#rospy.on_shutdown(self.onShutdown)

s1 = rospy.Service('pendant_switch', SwitchSrv, lambda req: handle_switch_request(pendant, req) )

s2 = rospy.Service('pendant_switches', SwitchesSrv, lambda req: handle_switches_request(pendant) )

dn = find_pendant()

if not dn:
    raise Exception("Failed to open pendant serial port")

pendant = IDXPendant(dn)


run_publisher(pendant, publisher)


   