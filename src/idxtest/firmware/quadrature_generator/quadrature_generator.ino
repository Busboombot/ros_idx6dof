
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


#define ENC_STPS_PER_INDEX 8192 // Steps per encoder revolution
#define ENC_STPS_PER_ROT ENC_STPS_PER_INDEX*8 // Steps per axis revolution

#define QUAD_PIN_0 22 // A output for Axis 0

#define SEC_IN_US 1000000 // 1M icro seconds in a second

// Speedy output sets and clears on the Due, maybe others. 
#define fastSet(pin) (digitalPinToPort(pin)->PIO_SODR |= digitalPinToBitMask(pin) )
#define fastClear(pin) (digitalPinToPort(pin)->PIO_CODR |= digitalPinToBitMask(pin) )
#define fastWrite(pin, value) ( value ? fastSet(pin) : fastClear(pin)   )

/* Quarature Encoder Class. Represents one axis. */
class QuadratureGenerator {

  private:

    uint8_t a_pin;
    uint8_t b_pin;
    uint8_t i_pin;
    uint8_t l_pin;

    int32_t pos = 0;

    int8_t steps[4] = {2, 3, 1, 0};

    bool limit_set = false;
    bool limit_changed = false;

  public:

    inline QuadratureGenerator(uint8_t a_pin, uint8_t b_pin, uint8_t i_pin, uint8_t l_pin)
      : a_pin(a_pin), b_pin(b_pin), i_pin(i_pin), l_pin(l_pin) {

      pinMode(a_pin, OUTPUT);
      pinMode(b_pin, OUTPUT);
      pinMode(i_pin, OUTPUT);
      pinMode(l_pin, OUTPUT);

    }

    inline void step(int8_t dir) {

      pos += dir;
      int32_t apos = abs(pos);

      int8_t bits = steps[apos % 4];

      fastWrite(a_pin, bits >> 1); // Write the A channel
      fastWrite(b_pin, bits & 1);  // Write the B channel

      if ( (apos % ENC_STPS_PER_INDEX) == 0) {
        fastSet(i_pin);
      } else {
        fastClear(i_pin);
      }

      if ( (apos % ENC_STPS_PER_ROT - ENC_STPS_PER_ROT / 2)   > 0 ) {
        fastSet(l_pin);
        if (limit_set != true) {
          limit_changed = true;
        }
        limit_set = true;
      } else {
        fastClear(l_pin);
        if (limit_set != false) {
          limit_changed = true;
        }
        limit_set = false;
      }

    }

    inline void stepUp(void) {
      step(1);
    }

    inline void stepDown(void) {
      step(-1);
    }

    inline int32_t getPosition(void) {
      return pos;
    }

    inline bool getLimitChanged(){
      return limit_changed;
    }

    inline bool getLimitSet(){
      return limit_set;
    }
};


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
    SEC_IN_US / 20000,
    SEC_IN_US / 10000,
    SEC_IN_US / 5000,
    SEC_IN_US / 2500,
    SEC_IN_US / 1000,
    SEC_IN_US / 500,
    SEC_IN_US / 250,
    SEC_IN_US / 100,
    SEC_IN_US / 50,
    SEC_IN_US / 25,
    SEC_IN_US / 10,
    SEC_IN_US / 1,
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
  delay_time = delays[delay_index];
  mode = 2;
  steps_per_ud = ((int)(SEC_IN_US/delay_time));; // 2 s per cycle
  
  Timer3.attachInterrupt(read_write_keys);
  Timer3.start(100000); // .1 s
  
  module.setDisplayToDecNumber(SEC_IN_US/delays[delay_index], 0, false);
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
          case 1:
            // Up
            dir = 1;
            break;
          case 2:
            // Down
            dir = -1;
            break;
        }    
      } 
  
      delay_time = delays[delay_index];

      int steps_per_sec = ((int)(SEC_IN_US/delay_time)) * dir;

      steps_per_ud = ((int)(SEC_IN_US/delay_time));

      module.setDisplayToSignedDecNumber( steps_per_sec, 0, delay_time==0);
      module.setDisplayToString(mode_names[mode]);
      
  } else if (keys > 0 && button_toggle > 0){
      // Do nothing until button is released
      button_toggle--;
  } else {
      button_toggle = 0;
  } 

}

void loop() {

  for (int i = 0; i < 6; i++) {
    if (dir > 0) {
      qg[i]->stepUp();
    } else {
      qg[i]->stepDown();
    }
  }

  /// Change direction in u/d mode
  if (mode == 2 && (abs(qg[0]->getPosition())  > steps_per_ud)){

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

  delayMicroseconds(delay_time);

  

}



