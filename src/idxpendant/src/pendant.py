
from serial import Serial
from time import sleep
from sys import exit



N_SWITCHES = 17
UP = 1
OFF = 0
DOWN = -1


    

class IDXPendant(object):
    
    def __init__(self, serial_device):
        self.serial_device = serial_device
        self.switch_states = [OFF] * N_SWITCHES
        self.last_switch_states = list(self.switch_states)
        
        self.switch_names = ('speed tool axis0 axis1 axis2 axis3 axis4 axis5 tool_open  '+
                       'tool_on tool_detach vac_on where set home step axis').split()
        
        self.ser = Serial(self.serial_device, timeout=1, baudrate=115200)
        

    def set_states(self):
        r = self.ser.readline()
        if r:
            for i in range(N_SWITCHES):
                c = r[i]
                if c.isdigit():
                    self.switch_states[i] = OFF
                elif c.isupper():
                    self.switch_states[i] = UP
                else:
                    self.switch_states[i] = DOWN

    def init_pendant(self):
        for i in range(20):
            self.ser.write('id\r\n')
            if self.ser.readline().strip() == 'pendant':
                self.ser.write('pp\r\n')
                self.set_states()
                return True
            sleep(.1)
        return False

    def __getitem__(self, i):
        
        try:
            index = int(i)
            state =  self.switch_states[index]
            
        except (TypeError, ValueError, IndexError):
            try:
                index = self.switch_names.index(i)
                state = self.switch_states[index]
            except:
                raise KeyError("Unknown index or name: {}".format(i))


        return (index, self.switch_names[index], state)

    def run(self, timeout = None):
        
        from time import time
        
        if not self.init_pendant():
            raise Exception('Failed to init pendant on {}'.format(self.serial_device))

        last_time = time()

        self.ser.write('ao\r\n')
        while True:
            
            self.set_states()
            
            for i, (cur, last, name) in enumerate(zip(self.switch_states, 
                                                      self.last_switch_states, self.switch_names )):
                if cur != last:
                    yield ( i, name, cur)

            self.last_switch_states = list(self.switch_states)
            
            if timeout and (last_time + timeout < time()):
                for i, (cur, name) in enumerate(zip(self.switch_states,self.switch_names )):
                    yield ( i, name, cur)
                    
                last_time = time()
                    

 
if __name__ == '__main__':
    import sys 
    
    dn = find_pendant()
    
    if not dn:
        print 'Failed to find pendant serial port'
        sys.exit(1)

    print 'Found serial port {} '.format(dn)

    pendant = IDXPendant(dn)

    for n, name, state in pendant.run():
        print n, name, state
  

