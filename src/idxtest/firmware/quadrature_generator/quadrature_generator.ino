
/*

  Generate quadrature encoder, index and limit signals like the axes of an IXD 6 Axis robot. Runs 
  on the Due, possibly also Mega2560.

  The generator uses a TM1638 Key/Led display to set the step rate of all of the axes. Connect the
  TM1638:

    Strobe: 7
    Data: 8
    CLock: 9
    
  For each of the 6 axes, the Quadrature out pins  are on adjacent pins, starting at pin 22. FOr instance, 
  for Axis 0:

    Quadrature A: 22
    Quadrature B: 23
    Index: 24
    Limit: 25

  For all axes:
  
    Axis 0: 22, 23, 24, 25
    Axis 1: 26, 27, 28, 29
    Axis 2: 30 ... 
    Axis 3: 34 ... 
    Axis 4: 38 ... 
    Axis 5: 36 ... 
  
  The Index pulses every encoder rotation, 8192 steps. The Limit is on for half of an axis rotation, 4 * 1892 steps, 
  and off for the other half. 

  The Buttons on the TM1638 control the speed and sign. The LED display shows the number of steps per second

    Button 0: Increase step frequency
    Button 1: Decrease Step frequency
    Button 2: Change direction

  See the delays array for the step frequencies

*/
#include <TM1638.h>
#include <bithacks.h>
#include <digitalWriteFast.h>
#include <math.h>
#include <DueTimer.h>
#include "idx_quadgen.h"


#define QUAD_PIN_0 22 // A output for Axis 0

#define SEC_IN_US 1000000 // 1M icro seconds in a second


QuadratureGenerator **qg  = new QuadratureGenerator*[6];

// define a module on data pin 8, clock pin 9 and strobe pin 7
TM1638 module(8, 9, 7);

int dir = 1;
int old_dir = dir;

char* mode_names[] = {
  "up",
  "dn", 
  "ud",
};


int delays[] = {
  0,
  20000,
  8192,
  4096,
  2048,
  1024,
  512,
  256,
  100,
  50,
  25,
  10,
  1,
};

size_t delay_array_size = sizeof delays / sizeof delays[0];
byte button_toggle = 0; // For debouncing buttons. 
byte delay_index = 0; // Which delay to use. 
uint32_t delay_time = 0;
int steps_per_ud = 0; // 1/2 of steps befre changing direction in u/d mode.
int mode = 0; 

void setup(void) {
  
  Serial.begin(115200);
  Serial.println("Starting");

  // Setup all 6 encoders
  for ( int i = 0 ; i < 6; i++) {
    qg[i] = new QuadratureGenerator( 
        (i * 4) + QUAD_PIN_0 + 0, 
        (i * 4) + QUAD_PIN_0 + 1,  
        (i * 4) + QUAD_PIN_0 + 2, 
        (i * 4) + QUAD_PIN_0 + 3 
        );
  }

    // Initial values for modes and delays
    delay_index = 2;
    steps_per_ud = delay_time = delays[delay_index];
    mode = 1;
   
    
    Timer3.attachInterrupt(read_write_keys);
    Timer3.start(100000); // .1 s
    
    module.setDisplayToDecNumber(delay_time, 0, false);
    module.setDisplayToString(mode_names[mode]);
  }

// Timer interrupt routine for reading the keys  and setting the 
// frequency display. 
void read_write_keys(){

  byte keys = module.getButtons();


  if(keys > 0 && button_toggle == 0){
    
      button_toggle = 5;
    
      if B_IS_SET(keys, 0){
        delay_index = (delay_index == (delay_array_size-1)) ? 0 : delay_index + 1;
      } else if  B_IS_SET(keys, 1){
        delay_index = (delay_index == 0) ? (delay_array_size-1) : delay_index - 1;

      } else if  B_IS_SET(keys, 2){
        mode = (mode+1)%3;

        switch(mode){
          case 0:
            // Up
            dir = 1;
            break;
          case 2:
            // Down
            dir = -1;
            break;
        }    
      } 
  
      steps_per_ud =  delay_time = delays[delay_index];

      int steps_per_sec = delay_time * dir;

      module.setDisplayToSignedDecNumber( steps_per_sec, 0, delay_time==0);
      module.setDisplayToString(mode_names[mode]);
      
  } else if (keys > 0 && button_toggle > 0){
      // Do nothing until button is released
      button_toggle--;
  } else {
      button_toggle = 0;
  } 

}

int idx = 0;

void loop() {

  for (int i = 0; i < 6; i++) {
    if (dir > 0) {
      qg[i]->setDirection(IDXStepGenerator::CW);
    } else {
      qg[i]->setDirection(IDXStepGenerator::CCW);
    }
    qg[i]->stepAlways(micros());
 
  }

 
  /// Change direction in u/d mode
  if (mode == 2 && (abs(qg[0]->getPosition())  > steps_per_ud*2)){

    if (qg[0]->getPosition() > 0){
      dir = -1;
      
    } else {
      dir = 1;
    }
  }

  if(old_dir != dir){
    module.setLED(dir > 0 ? TM1638_COLOR_RED : TM1638_COLOR_NONE, 0);
    old_dir = dir;
  }

  delayMicroseconds(SEC_IN_US/delay_time);
  idx++;

  

}



