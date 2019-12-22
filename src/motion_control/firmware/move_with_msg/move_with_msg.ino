
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

#define DEBUG_PRINT_ENABLED false
#define DEBUG_TICK_ENABLED true
#include "debug.h"

#define QUADRATURE_OUTPUT false

// N_AXES, defined in idx_command.h, is 6, 
// but this program can be defined to not iterate over all of them.  
//#define AXES_USED N_AXES
#define AXES_USED 6

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
  delay(1);
  USBDevice.attach(); // Initialize the SerialUSB device. 

  Serial.begin(115200); // For debugging
  SerialUSB.begin(115200); // For control messages. Max speed 1050000

  init_debug();

}

void init_steppers(  IDXStepGenerator *steppers[] ){
  // This  program can generate quadrature outputs instead of stepper
  // outputs. 
  if(QUADRATURE_OUTPUT){
    steppers[0] = new QuadratureGenerator(0,22,23,24,25,1000);
    steppers[1] = new QuadratureGenerator(1,26,27,28,29,1000);
    steppers[2] = new QuadratureGenerator(2,30,31,32,33,1000);
    steppers[3] = new QuadratureGenerator(3,34,35,36,37,1000);
    steppers[4] = new QuadratureGenerator(4,38,39,40,41,1000);
    steppers[5] = new QuadratureGenerator(5,42,43,44,45,1000);
  } else {
    steppers[0] = new IDXStepper(0,X_STEP_PIN,X_DIR_PIN);
    steppers[1] = new IDXStepper(1,Y_STEP_PIN,Y_DIR_PIN);
    steppers[2] = new IDXStepper(2,Z_STEP_PIN,Z_DIR_PIN);
    steppers[3] = new IDXStepper(3,E_STEP_PIN,E_DIR_PIN);
    steppers[4] = new IDXStepper(4,10,11);
    steppers[5] = new IDXStepper(5,12,13);
  }
}
  

int main(void) {
  
  struct command * msg = 0;
  uint32_t now;
  uint8_t active_axes = 0;
  int last_time = 0;

  init_board();

  #if(DEBUG_PRINT_ENABLED)
  Serial.println("Starting");
  #endif
  
  IDXCommandBuffer cbuf(SerialUSB);

  IDXStepGenerator *steppers[N_AXES];

  init_steppers(steppers);

  pinMode(X_ENABLE_PIN, OUTPUT);

  for (;;) {

    // When idle, with no ticks being set ( but all are still cleared ) 
    // takes about 16.5us
    
    
    fastDebugSet(LOOP_COMM_TICK_PIN);

    cbuf.startLoop(); // Start diagnostic times. 

    // Turning on interrups only here ensures that the serial interrupt,
    // which takes about 250us, will only happen here
    //interrupts();
    // Load a byte from the serial port and possibly process
    // add a completed message to the queue. 
    cbuf.run(); 
    //noInterrupts();
    fastDebugClear(LOOP_COMM_TICK_PIN);
    
    /*
     * All of the axes have finished so clear out the message 
     */
    
    if (active_axes == 0 && msg != 0){
      // Response, without setPositions: 42.5 us
      fastDebugSet(RESPONSE_TICK_PIN);

      cbuf.setPositions(steppers[0]->getPosition(), steppers[1]->getPosition(), steppers[2]->getPosition(),
                        steppers[3]->getPosition(), steppers[4]->getPosition(), steppers[5]->getPosition());
      
      cbuf.sendDone(*msg);
      #if(DEBUG_PRINT_ENABLED)
        Serial.print("DONE: seq="); Serial.println(msg->seq); 
      #endif
      cbuf.resetLoopTimes();
      
      if(cbuf.size() == 0){
          //cbuf.sendEmpty(*msg);
      }

      delete msg;

      msg = 0;
      fastDebugClear(RESPONSE_TICK_PIN);
    } 
    
    /*
     * If we have messages in the queue, and there is no message in progress, 
     * get the message and start working on it. 
     */

    
    int size = cbuf.size();
    

    if( size > 0 && msg == 0 ){
      // Processing a message: 48.5 us or 66 us.
      
      fastDebugSet(PARAMS_TICK_PIN);
      msg = cbuf.getMessage();

      if (msg->code == IDX_COMMAND_RESET){
        init_steppers(steppers);
        msg = cbuf.getMessage();
      }
      
      if(msg!=0){
        fastDebugSet(EXTRA_DEBUG_TICK_PIN);
        for (int axis = 0; axis < AXES_USED; axis ++){
          steppers[axis]->setParams(micros(), msg->segment_time, msg->v0[axis], msg->v1[axis], msg->steps[axis]);
        }
        fastDebugClear(EXTRA_DEBUG_TICK_PIN);
      }
      
      fastDebugClear(PARAMS_TICK_PIN);

      last_time = millis();
    }

    if (cbuf.size() == 0 && msg == 0){
      fastDebugSet(STARVED_TICK_PIN);
      if (starvedToggle == false){
        starvedToggle = true;
        #if(DEBUG_PRINT_ENABLED)
        Serial.println("Starved"); 
        fastDebugSet(PARAMS_TICK_PIN);
        #endif
      }
      fastSet(X_ENABLE_PIN);
    } else {

      if (starvedToggle == true){
        starvedToggle = false;
         #if(DEBUG_PRINT_ENABLED)
         Serial.println("UnStarved"); 
         #endif
      }   
      fastClear(X_ENABLE_PIN);   
      fastDebugClear(STARVED_TICK_PIN);
      
    }
  
    /*
     * Iterate over all of the axes and step them when their time comes up. 
     */

    fastDebugSet(LOOP_STEP_TICK_PIN);
    
    active_axes = 0;
    now = micros();
    for (int axis = 0; axis < AXES_USED; axis ++){    
      
      if(steppers[axis]->stepMaybe(now)){
         active_axes ++;
      }
      
   
    }
    fastDebugClear(LOOP_STEP_TICK_PIN);
    
    cbuf.endLoop();

  }

  return 0;
}
