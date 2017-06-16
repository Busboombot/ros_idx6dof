#include <ros.h>
#include <std_msgs/String.h>

#include <Arduino.h>
#include "idx_pendant.h"

ros::NodeHandle nh;

IDXPendant pendant  = IDXPendant();

std_msgs::String str_msg;
ros::Publisher pendant_pub("pendant_str", &str_msg);

long nextTime;

void setup()
{
  nh.initNode();
  nh.advertise(pendant_pub);
  nh.loginfo("Starting pendant arduino node");
  pendant.begin() ;
  nextTime = millis();    
}

void loop()
{
  
  //nh.loginfo("Loop");
  
  //Wait for the delay time if nothing changes, 
  // but break immedialy if it does
  while( millis() < nextTime){
      if(pendant.run_once()){
          break;
      }
  }
      
  str_msg.data = pendant.outstr();
  pendant_pub.publish( &str_msg );
  nh.spinOnce();
  
  nextTime = millis() + 100;
}
