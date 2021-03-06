
#include <AccelStepper.h>
#include <limits.h>
#include <ros.h>

#include <idxrobot/Command.h>
#include <idxrobot/Position.h>
#include <idxrobot/Log.h>

#define NUM_AXES 6
#define STEP_DWELL 40 // Delay, in microseconds, to dwell on the step pulses
#define UPDATE_DELAY 100 // time, in milliseconds, between velocity updates
#define ACCEL 1000 // Acceleration for moving forward or back
#define STOP_ACCEL 2000 // Acceleration for stopping

// NOTE! These only work on the SAM3X, or possibly other ARM Chips, but certainly the Arduino DUE. 
#define fastSet(pin) (digitalPinToPort(pin)->PIO_SODR |= digitalPinToBitMask(pin) ) 
#define fastClear(pin) (digitalPinToPort(pin)->PIO_CODR |= digitalPinToBitMask(pin) )

AccelStepper motors[] = {
  AccelStepper(AccelStepper::DRIVER, 2, 3), AccelStepper(AccelStepper::DRIVER, 4, 5),
  AccelStepper(AccelStepper::DRIVER, 6, 7), AccelStepper(AccelStepper::DRIVER, 8, 9), 
  AccelStepper(AccelStepper::DRIVER, 10, 11), AccelStepper(AccelStepper::DRIVER, 12, 13)
};

int max_speed = 500; // Configure with 'ms' command
bool accelerate = true; // Use acceleration


ros::NodeHandle nh;

idxrobot::Log log_msg;
ros::Publisher pub_motion_log("idx_motion/log", &log_msg);

idxrobot::Position pos_msg;
ros::Publisher pub_motion_pos("idx_motion/pos", &pos_msg);

struct xvt_max {
  float x;
  float v;
  float t;
};

struct xvt_max max_xvt(const idxrobot::Command &cmd, AccelStepper motors[], int max_speed){

    struct xvt_max maxes;
  
    // Speed is set as a % of the configured max 0-100
    float v_max = (float)max_speed * ((float)cmd.common_arg /100.0);
    float x_max = 0; // Maximum distance traveled
    
    for (int i = 0; i < NUM_AXES; i++){
      if(cmd.axes[i] != LONG_MIN ){
        x_max = max(x_max, abs(cmd.axes[i]-motors[i].currentPosition()));
      }
      
    }

    maxes.x = x_max;
    maxes.v = v_max;
    maxes.t = ((float)x_max) / v_max;

    return maxes;
}

void clear_log_message(idxrobot::Log &log_msg){
  log_msg.value = -1;
  log_msg.message = "";
}

void cmd_id(const idxrobot::Command& cmd){
  log_msg.message = "stepper";
  log_msg.value = -1;
  log_msg.stamp = nh.now();
  pub_motion_log.publish(&log_msg);
}

void cmd_info(const idxrobot::Command& cmd){
  log_msg.message = "max_speed";
  log_msg.value = max_speed;
  log_msg.stamp = nh.now();
  pub_motion_log.publish(&log_msg);

}

void cmd_maxspeed(const idxrobot::Command& cmd){

      max_speed = cmd.common_arg;

      for( int i = 0; i < NUM_AXES; i++){
        motors[i].setMaxSpeed(max_speed);
      }
}

void cmd_position(const idxrobot::Command& cmd){

  pos_msg.code = "position";
  
  for (int i = 0; i < NUM_AXES; i++){
    pos_msg.axes[i] = motors[i].currentPosition(); 
  }
  
  pos_msg.stamp = nh.now();
  pub_motion_pos.publish(&pos_msg);
    
}

void cmd_stop(const idxrobot::Command& cmd){
  for (int i = 0; i < NUM_AXES; i++){
    motors[i].setAcceleration(STOP_ACCEL);
    motors[i].setMaxSpeed(0);
    motors[i].stop();
  }
}

void cmd_move_abs(const idxrobot::Command& cmd){
  accelerate = true;
  
  struct xvt_max maxes = max_xvt(cmd, motors, max_speed);
  
  for (int i = 0; i < NUM_AXES; i++){
    int param = cmd.axes[i];
    if(param != LONG_MIN ){
      float x = (float)param -  motors[i].currentPosition();
      float v = abs(x) / maxes.t;
      
      motors[i].move(x);
      motors[i].setMaxSpeed(v);
    }
  }
}

void cmd_move_rel(const idxrobot::Command& cmd){
    accelerate  = true;

    struct xvt_max maxes = max_xvt(cmd, motors, max_speed);
    
    for (int i = 0; i < NUM_AXES; i++){
      int param = cmd.axes[i];
      if(param != LONG_MIN ){
        float x = (float)param;
        float v = abs(x) / maxes.t;
        
        motors[i].move(x);
        motors[i].setMaxSpeed(v);

      }
    }
}

void cmd_move_time(const idxrobot::Command& cmd){
      // Param 0 is the time to move, in miliseconds. 
      // Params 1-6 are the % of max speed. Use negative numbers to run backwards

      accelerate = false;

      float t = (float)cmd.common_arg / 1000.0 ;

      for (int i = 0; i < NUM_AXES; i++){
        int param = cmd.axes[i];
        if(param != LONG_MIN  ){

          if (param == 0){
            motors[i].setMaxSpeed(0);
            motors[i].stop();
          } else {
            float v = (float)abs(param)/100.0 * max_speed;
            
            float x =  copysign(v * t, param);
           
            motors[i].move(x);
            motors[i].setMaxSpeed(v);
          }
        }
      }
}

void cmd_no_cmd(const idxrobot::Command& cmd){
  
}

struct command_func {
  const char * command_code;
  void (&command_f)(const idxrobot::Command& cmd);
};

struct command_func commands[] = {
  {"id", cmd_id},
  {"info", cmd_info},
  {"max_speed", cmd_maxspeed},
  {"position", cmd_position},
  {"stop", cmd_stop},
  {"move_abs", cmd_move_abs},
  {"rel", cmd_move_rel},
  {"move_time", cmd_move_time},
  {0, cmd_no_cmd}
};


void messageCb( const idxrobot::Command& cmd){
  nh.loginfo("Motion Command");
  nh.loginfo( cmd.command_code);

  return;

  for ( int i=0;  commands[i].command_code != 0; i++ ){
    if (strcmp(commands[i].command_code,cmd.command_code) == 0){
      commands[i].command_f(cmd);
    }
  }

}

ros::Subscriber<idxrobot::Command> sub_motion_commands("idx_motion/commands", &messageCb );

void setup() {
  pinMode(13, OUTPUT);
  //for( int i = 0; i < NUM_AXES; i++){
  //  motors[i].setMaxSpeed(max_speed);
  //  motors[i].setAcceleration(ACCEL);
  //}
  //nh.getHardware()->setBaud(115200);
  nh.initNode();
  nh.subscribe(sub_motion_commands);
  //nh.advertise(pub_motion_log);
  //nh.advertise(pub_motion_pos);
}

void loop()
{
  if (Serial.available()){
    nh.spinOnce();
  }
  digitalWrite(13, HIGH-digitalRead(13));   // blink the led
  delay(500);
  
  //for( int i = 0; i < NUM_AXES; i++){
  //  if( motors[i].run() && accelerate){
  //    motors[i].computeNewSpeed();
  //  }
  //}
}


