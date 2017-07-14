int8 JOINT_SPACE=1
int8 XYZ_SPACE=2

int8 X_COMMAND=1 # Joint values are distances
int8 V_COMMAND=2 # Joint values are velocities

int8 IMMEDIATE=1 # Execute command immediately, and discard if too old. 
int8 QUEUED=2    # Command should be queued

Header header
int8 command_type   # X_COMMAND or # V_COMMAND
int8 param_space    # JOINT_SPACE or XYZ_SPACE
int8 exec_type      # IMMEDIATE or QUEUED
float32 t           # Common time for either X_COMMAND or V_COMMAND
float32 x           # Common X distance for V_COMMAND
float32 v           # Common Velocity for X_COMMAND
float32[6] joints   # Joint values, either distance or velocity
