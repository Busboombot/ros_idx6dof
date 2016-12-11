#include <limits.h>
#include <ros.h>

#include <idxrobot/Command.h>
#include <idxrobot/Position.h>
#include <idxrobot/Log.h>


ros::NodeHandle nh;

idxrobot::Log log_msg;
ros::Publisher pub_motion_log("idx_motion/log", &log_msg);

idxrobot::Position pos_msg;
ros::Publisher pub_motion_pos("idx_motion/pos", &pos_msg);


void messageCb( const idxrobot::Command& cmd){
  nh.loginfo("Motion Command");
  nh.loginfo( cmd.command_code);
}

ros::Subscriber<idxrobot::Command> sub_motion_commands("idx_motion/commands", &messageCb );

void setup() {

  nh.initNode();
  nh.subscribe(sub_motion_commands);
  //nh.advertise(pub_motion_log);
  //nh.advertise(pub_motion_pos);
}

void loop()
{
  nh.spinOnce();

  delay(500);
}


