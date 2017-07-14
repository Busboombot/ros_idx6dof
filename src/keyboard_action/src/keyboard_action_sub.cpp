#include "ros/ros.h"
#include <keyboard/Key.h>
//#include <keyboard_action/controls.h>
#include <motion_control/MotionCommand.h>
//#include <motion_control/MotorCommand.h>
#include <algorithm>
#include <iterator>
#include "math.h"



float vel[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
float dist[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
int pressed;

struct axis{
int axis;
int dir;
}ax;

int paxcodes[6] = {113, 97, 122, 101, 100, 99};
int naxcodes[6] = {119, 115, 120, 114, 102, 118};
int upvel[4] = {303, 304, 305, 306};

//int N_Axes = 6;

void Key_IP(const keyboard::Key::ConstPtr& k){

  bool pax = std::find(paxcodes, paxcodes+6, k->code) != paxcodes+6;
  bool nax = std::find(naxcodes, naxcodes+6, k->code) != naxcodes+6;
  bool hvel = std::find(upvel, upvel+6, k->code) != upvel+6;


  	if(pax)
		 ax.dir = 1;
	   else if(nax)
		 ax.dir = -1;

	if(k->code == 113 || k->code == 119)
	   ax.axis=0;
	   else if(k->code == 97 || k->code == 115)
	   ax.axis=1;
	   else if(k->code == 122 || k->code == 120)
	   ax.axis=2;
	   else if(k->code == 101 || k->code == 114)
	   ax.axis=3;
	   else if(k->code == 100 || k->code == 102)
	   ax.axis=4;
	   else if(k->code == 99 || k->code == 118)
	   ax.axis=5;

  /*
  L.cmd = 311, R.cmd = 312 | Distance = 2048 steps
  L.opt = 307, R.opt = 308 | Distance = 8192 steps
  L.ctl = 306, R.ctl = 305 | Speed + 1 = 4000 steps/s
  L.shift = 304, R.shift = 303 | Speed + 2 = 8000 steps/s
  /**/

  /* if (pax || nax) {
   vel[ax.axis] = 500*ax.dir;
   }
	 if((k->code == 305 || k->code == 306)) {
   vel[ax.axis] = 4000*ax.dir;
   }
    else if((k->code == 304 || k->code == 303)) {
    vel[ax.axis] =  8000*ax.dir;
   }

/**/
 if (pax || nax) {
   dist[ax.axis] = 800*ax.dir;
  }
/*
	 if((k->code == 305 || k->code == 306)) {
   dist[ax.axis] = *ax.dir;
   }
    else if((k->code == 304 || k->code == 303)) {
    dist[ax.axis] =  8000*ax.dir;
   }
/**/

   if(k->pressed == 0 && (pax == 1 || nax == 1 ))
   dist[ax.axis]=0;
/*
    else if(k->pressed == 0 && hvel == 1)
    dist[ax.axis]=500*ax.dir;
/**/


  }


int main(int argc, char **argv)
{

  ros::init(argc, argv, "key_pub");
  ros::NodeHandle n;


  ros::Rate loop_rate(1);


  ros::Publisher control_pub = n.advertise<motion_control::MotionCommand>("motion_control/segment_command", 1);


  ros::Subscriber sub = n.subscribe("keyboard/key", 10,Key_IP);


  motion_control::MotionCommand msg;


  while (ros::ok()){

  msg.command_type = motion_control::MotionCommand::X_COMMAND;
  msg.param_space = motion_control::MotionCommand::JOINT_SPACE;
  msg.exec_type = motion_control::MotionCommand::IMMEDIATE;
  msg.v = 600;
  msg.t = abs(dist[ax.axis])/msg.v; //seconds, Mx Velocity = 600 st./s

    for (int i=0;i<6;i++){
    msg.joints[i]=dist[i];
    }

  control_pub.publish(msg);
  msg.header.stamp = ros::Time::now();
  ros::spinOnce();
  loop_rate.sleep();


  }






    return 0;
}
