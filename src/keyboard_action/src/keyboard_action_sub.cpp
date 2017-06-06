#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include <keyboard/Key.h>
#include <keyboard_action/controls.h>




int vel=500;
int dist=512;
int count = 0;

void Key_IP(const keyboard::Key::ConstPtr& k){
	
	 if(k->code == 311 || k->code == 312) {
                  dist = 2048;

             } else if(k->code == 307 || k->code == 308) {

                dist = 8192;

             } else if(k->code == 305 || k->code == 306) {

                  vel = 4000;

             } else if(k->code == 304 ||k->code == 303) {

                  vel =  4000;

             } else {
                
                  vel = 500;
                  dist = 512;
            }

	}




int main(int argc, char **argv)
{

    ros::init(argc, argv, "key_pub");
    ros::NodeHandle n;


  
    ros::Publisher control_pub = n.advertise<keyboard_action::controls>("control", 2);


    ros::Subscriber sub = n.subscribe("keyboard/key", 10,Key_IP);


keyboard_action::controls msg;
	/* 

        L.cmd = 311, R.cmd = 312 | Distance = 2048 steps
        L.opt = 307, R.opt = 308 | Distance = 8192 steps
        L.ctl = 306, R.ctl = 305 | Speed + 1 = 4000 steps/s
        L.shift = 304, R.shift = 303 | Speed + 2 = 8000 steps/s

        /**/
  
        while (ros::ok()){

		msg.velocity = vel;
		
		msg.step_dist = dist;

 		control_pub.publish(msg);

	        ros::spinOnce();
	
        	++count;

           
        }

       
	
  
    ros::spin();

    return 0;
}
