
N_SWITCHES = 17
UP = 1
OFF = 0
DOWN = -1

switch_names = ('speed tool axis0 axis1 axis2 axis3 axis4 axis5 tool_open  '+
                       'tool_on tool_detach vac_on where set home step axis').split()
    
switch_codes =  "abcdefghijhlmnopq"
    
def switch_pos(sw_name, sw_string):

    

    swcode = switch_codes[switch_names.index(sw_name)]

    if swcode in sw_string.data:
        return DOWN
    elif swcode.upper() in sw_string.data:
        return UP
    else:
        return OFF


def axes_positions(sw_string):
    
    axes = [OFF]*6
    
    for ax_n, sw_n in enumerate((2,3,4,5,6,7)):
        swcode = switch_codes[sw_n]
        
        if swcode in sw_string.data:
            axes[ax_n] = DOWN
        elif swcode.upper() in sw_string.data:
            axes[ax_n] = UP
            
    return axes
       
        
        