
//
// Requires
//  idxlib, https://github.com/Busboombot/idxlib

#include <Arduino.h>
#include <limits.h>
#include "fastset.h"

#define DEBUG_PRINT_ENABLED true
#define DEBUG_TICK_ENABLED true

#include "debug.h"

#include "idx_command.h"
#include "idx_stepper.h"
#include "idx_quadgen.h"
#include "bithacks.h"


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


int main(void) {
  
  struct command * msg = 0;
  uint32_t now;
  uint8_t active_axes = 0;
  int last_time = 0;
  bool starvedToggle = false;

  init_board();
 
  #if(DEBUG_PRINT_ENABLED)
  Serial.println("Starting");
  #endif
  
  IDXCommandBuffer cbuf(SerialUSB);

  for (;;) {

    // When idle, with no ticks being set ( but all are still cleared ) 
    // takes about 16.5us
    
    
    fastDebugSet(LOOP_COMM_TICK_PIN);

    cbuf.startLoop(); // Start diagnostic times. 

    cbuf.run(); 

    fastDebugClear(LOOP_COMM_TICK_PIN);
    
    if ( msg != 0){
      // Response, without setPositions: 42.5 us
      fastDebugSet(RESPONSE_TICK_PIN);

     
      cbuf.sendDone(*msg);
      #if(DEBUG_PRINT_ENABLED)
        Serial.print("DONE: seq="); Serial.println(msg->seq); 
      #endif
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
      Serial.print("MESG: seq="); Serial.println(msg->seq); 

      if (msg->code == IDX_COMMAND_RESET){
        msg = cbuf.getMessage();
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
        fastDebugSet(STARVED_TICK_PIN);
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

    #if(DEBUG_PRINT_ENABLED)
    if (msg != 0){
      Serial.print("Start#"); Serial.print(msg->seq); 
      Serial.print(" T="); Serial.print(millis()); 
      Serial.print(" dT="); Serial.print(millis()-last_time); 
      Serial.print(" ql="); Serial.print(cbuf.size()); 
      Serial.print(" st="); Serial.print(msg->segment_time);
      Serial.print(" v0="); Serial.print(msg->v0[0]);
      Serial.print(" v1="); Serial.print(msg->v1[0]);
      Serial.print(" x="); Serial.print(msg->steps[0]);
      Serial.println('');
    }
    #endif

    
    cbuf.endLoop();

  }

  return 0;
}
