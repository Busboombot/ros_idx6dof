
def find_arduinos():
    """Using udev, return a set of all of the arduinos attached to USB ports"""
    
    from pyudev import Context
    from serial import Serial

    devices = Context().list_devices(subsystem='tty', ID_BUS='usb')

    arduinos = set()

    for device in devices:

        # Assume that all of our Arduinos implement the id command
        if  device['ID_MODEL'].startswith('Arduino'):
            arduinos.add((device.device_node,device['ID_MODEL']) )
        else:
            print (device.device_node,device['ID_MODEL']) 

    return arduinos
    

if __name__ == '__main__':
    print find_arduinos()