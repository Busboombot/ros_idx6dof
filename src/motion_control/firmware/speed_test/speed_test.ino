
//
// Requires
//  idxlib, https://github.com/Busboombot/idxlib

// RAMPS 1.4 pins
#define X_STEP_PIN         54
#define X_DIR_PIN          55
#define X_ENABLE_PIN       38
#define X_MIN_PIN           3
#define X_MAX_PIN           2

#define Y_STEP_PIN         60
#define Y_DIR_PIN          61
#define Y_ENABLE_PIN       56
#define Y_MIN_PIN          14
#define Y_MAX_PIN          15

#define Z_STEP_PIN         46
#define Z_DIR_PIN          48
#define Z_ENABLE_PIN       62
#define Z_MIN_PIN          18
#define Z_MAX_PIN          19

#define E_STEP_PIN         26
#define E_DIR_PIN          28
#define E_ENABLE_PIN       24

#define SDPOWER            -1
#define SDSS               53
#define LED_PIN            13

#define FAN_PIN            9

#define PS_ON_PIN          12
#define KILL_PIN           -1

#define HEATER_0_PIN       10
#define HEATER_1_PIN       8
#define TEMP_0_PIN          13   // ANALOG NUMBERING
#define TEMP_1_PIN          14   // ANALOG NUMBERING

#include <Arduino.h>
#include <limits.h>
#include "fastset.h"

#include "debug.h"

#define QUADRATURE_OUTPUT false

// N_AXES, defined in idx_command.h, is 6, 
// but this program can be defined to not iterate over all of them.  
//#define AXES_USED N_AXES
#define AXES_USED 1

#include "idx_command.h"
#include "idx_stepper.h"
#include "idx_quadgen.h"
#include "bithacks.h"


bool starvedToggle = false;

/*
 * Initialize the board, serial ports, etc. 
 */
void init_board(){
  watchdogSetup();
  init(); // Initialize the board, probably

  Serial.begin(115200); // For debugging

  init_debug();

}

void init_steppers(  IDXStepGenerator *steppers[] ){

  steppers[0] = new IDXStepper(0,2,3);
  steppers[1] = new IDXStepper(1,4,5);
  steppers[2] = new IDXStepper(2,6,7);
  steppers[3] = new IDXStepper(3,7,8);
  steppers[4] = new IDXStepper(4,10,11);
  steppers[5] = new IDXStepper(5,12,13);

}
  
struct command * msg = (struct command*)malloc(sizeof(*msg));



int main(void) {
  
  
  uint32_t now;
  uint8_t active_axes = 0;
  int last_time = 0;

  init_board();
  
  IDXStepGenerator *steppers[N_AXES];

  init_steppers(steppers);

  msg->segment_time = 500000;
  msg->v0[0] = 10000;
  msg->v1[0] = 100000;
  msg->steps[0] = (msg->v0[0] +   msg->v1[0])/2 * ( (float)msg->segment_time / 1000000) ;


  for (;;) {


    fastDebugSet(EXTRA_DEBUG_TICK_PIN);
    if (active_axes == 0){
      fastDebugSet(PARAMS_TICK_PIN);

      for (int axis = 0; axis < AXES_USED; axis ++){
        steppers[axis]->setParams(micros(), msg->segment_time, msg->v0[axis], msg->v1[axis], msg->steps[axis]);
      }
      fastDebugClear(PARAMS_TICK_PIN);
    }
    fastDebugClear(EXTRA_DEBUG_TICK_PIN);
    

    fastDebugSet(LOOP_STEP_TICK_PIN);
    
    active_axes = 0;
    now = micros();
    for (int axis = 0; axis < AXES_USED; axis ++){    
      
      if(steppers[axis]->stepMaybe(now)){
         active_axes ++;
      } 
      
    }
    fastDebugClear(LOOP_STEP_TICK_PIN);

    //Serial.print(steppers[0]->stepsLeft);
    //Serial.print(' ');
    //Serial.println(active_axes);
  }

  return 0;
}
