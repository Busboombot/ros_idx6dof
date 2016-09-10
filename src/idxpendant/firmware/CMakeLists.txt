# To Make: catkin_make idxpendant_firmware_pendant
# To Upload: catkin_make idxpendant_firmware_pendant-upload
# To Install Prerequisites: sudo apt-get install gcc-avr avr-libc arduino avrdude
# RUn the gateway: rosrun rosserial_python serial_node.py /dev/ttyACM0
# See https://github.com/queezythegreat/arduino-cmake for more about
# how to configure this CMake file

cmake_minimum_required(VERSION 2.8.3)

include_directories(${ROS_LIB_DIR})

# Remove this if using an Arduino without native USB (eg, other than Leonardo)
#add_definitions(-DUSB_CON)

generate_arduino_firmware(pendant
  SRCS pendant.cpp ${ROS_LIB_DIR}/time.cpp idx_pendant.cpp
  BOARD uno
  PORT /dev/ttyACM0
)