
//
// Requires
//  idxlib, https://github.com/Busboombot/idxlib
#include <Arduino.h>
#include <limits.h>
#include "fastset.h"

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
    steppers[0] = new IDXStepper(0,2,3);
    steppers[1] = new IDXStepper(1,4,5);
    steppers[2] = new IDXStepper(2,6,7);
    steppers[3] = new IDXStepper(3,8,9);
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
          cbuf.sendEmpty(*msg);
      }

      delete msg;

      msg = 0;
      fastDebugClear(RESPONSE_TICK_PIN);
    } 
    
    /*
     * If we have messages in the queue, and there is no message in progress, 
     * get the message and start working on it. 
     */

    fastDebugSet(EXTRA_DEBUG_TICK_PIN);
    int size = cbuf.size();
    fastDebugClear(EXTRA_DEBUG_TICK_PIN);

    if( size > 0 && msg == 0 ){
      // Processing a message: 48.5 us or 66 us.
      fastDebugSet(PARAMS_TICK_PIN);
      msg = cbuf.getMessage();

      if (msg->code == IDX_COMMAND_RESET){
        init_steppers(steppers);
        msg = cbuf.getMessage();
      }
      
#if(DEBUG_PRINT_ENABLED)
        Serial.print("Start#"); Serial.print(msg->seq); 
        Serial.print(" T="); Serial.print(millis()); 
        Serial.print(" dT="); Serial.print(millis()-last_time); 
        Serial.print(" ql="); Serial.print(cbuf.size()); 
        Serial.print(" qt="); Serial.print(cbuf.getQueueTime()); 
        Serial.print(" st="); Serial.print(msg->segment_time);
        Serial.print(" v0="); Serial.print(msg->v0[0]);
        Serial.print(" v1="); Serial.print(msg->v1[0]);
        Serial.print(" x="); Serial.print(msg->steps[0]);
        //Serial.print(" crc=");Serial.print(msg->crc); 
        Serial.println(" ");
#endif

      if(msg!=0){
        for (int axis = 0; axis < AXES_USED; axis ++){
          steppers[axis]->setParams(micros(), msg->segment_time, msg->v0[axis], msg->v1[axis], msg->steps[axis]);
        }

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
              #endif
      }
    } else {

      if (starvedToggle == true){
        starvedToggle = false;
         #if(DEBUG_PRINT_ENABLED)
         Serial.println("UnStarved"); 
         #endif
      }      
      fastDebugClear(STARVED_TICK_PIN);
    }
    
     /* Clear all of the pins, so setting a pin actually results in a
     * transition
     */

    fastDebugSet(LOOP_CLEAR_TICK_PIN);

    // Clearing pins: 3us
    for (int axis = 0; axis < AXES_USED; axis ++){
      steppers[axis]->clearStep();
    }
    fastDebugClear(LOOP_CLEAR_TICK_PIN);
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
