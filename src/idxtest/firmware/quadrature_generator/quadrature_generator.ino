
/*

  Generate quadrature encoder, index and limit signals like the axes of an IXD 6 Axis robot. Runs 
  on the Due, possibly also Mega2560-99-4.

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

#if defined(_SAM3XA_)
#include <DueTimer.h>
#else
#include <TimerOne.h>
#endif


// Speedy output sets and clears on the Due, maybe others. 
#define fastSet(pin) (digitalPinToPort(pin)->PIO_SODR |= digitalPinToBitMask(pin) )
#define fastClear(pin) (digitalPinToPort(pin)->PIO_CODR |= digitalPinToBitMask(pin) )
#define fastWrite(pin, value) ( value ? fastSet(pin) : fastClear(pin)   )


#define ENC_STPS_PER_INDEX 8192 // Steps per encoder revolution
#define ENC_STPS_PER_ROT (ENC_STPS_PER_INDEX*8) // Steps per axis revolution

#define QUAD_PIN_0 22 // A output for Axis 0

#define SEC_IN_US 1000000 // 1M icro seconds in a second

class QuadratureGenerator {

  private:

    uint8_t a_pin;
    uint8_t b_pin;
    uint8_t i_pin;
    uint8_t l_pin;

    int index_pos = 0;
    uint32_t position = 0;
    int8_t direction; 

    int8_t steps[4] = {2, 3, 1, 0};

    int limit_offset = 0;

    bool limit_set = false;
    bool limit_changed = false;

    uint32_t lastTime;
    int32_t stepsLeft;
    
  public:

    typedef enum
    {
        CCW = -1,  ///< Clockwise
        STOP = 0,  ///< Clockwise
        CW  = 1   ///< Counter-Clockwise
    } Direction;

    inline QuadratureGenerator(uint8_t axis_n, uint8_t a_pin, uint8_t b_pin, uint8_t i_pin, uint8_t l_pin,
                               int limit_offset=0)
      : a_pin(a_pin), b_pin(b_pin), i_pin(i_pin), l_pin(l_pin), limit_offset(limit_offset){

      pinMode(a_pin, OUTPUT);
      pinMode(b_pin, OUTPUT);
      pinMode(i_pin, OUTPUT);
      pinMode(l_pin, OUTPUT);
    }

    inline void writeStep() {
            
        int32_t apos = abs(position);
        int8_t bits = steps[apos % 4];

        fastWrite(a_pin, bits >> 1); // Write the A channel
        fastWrite(b_pin, bits & 1);  // Write the B channel

        //Serial.println(position);

        if ( (apos % ENC_STPS_PER_INDEX) == 0) {
            fastSet(i_pin);

        } else {
            fastClear(i_pin);
        }

        if ( (apos-limit_offset)%ENC_STPS_PER_ROT < (ENC_STPS_PER_ROT/2) ){
            fastSet(l_pin);
        } else {
            fastClear(l_pin);
        }
    }

    inline void clearStep(){
        
    }

    inline bool getLimitChanged(){
      return limit_changed;
    }

    inline bool getLimitSet(){
      return limit_set;
    }
    
    inline void setDirection(Direction dir){
        
        direction = dir;
    }

    inline long stepAlways(uint32_t now){

        writeStep();
        
        lastTime = now;
        
        position += direction;

        return stepsLeft;
    }

    inline uint32_t getPosition(){
        return position;
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
  "st",
  "ss"
};

#define MODE_UP 0
#define MODE_DOWN 1
#define MODE_UD 2
#define MODE_STOP 3
#define MODE_SINGLE_SHOT 4

int delays[] = {
  0,
  32768,
  16384,
  8192,
  4096,
  2048,
  1024,
  1000,
  512,
  256,
  100,
  50,
  25,
  10,
  5,
  2,
  1,
};

// Button Numbers
#define NEXT_SPEED_BTN 0
#define PREV_SPEED_BTN 1
#define UD_BTN 2
#define START_STOP_BUTTON 3
#define SINGLE_SHOT_BUTTON 4

#define UD_LED 0
#define RUNNING_LED 2

size_t delay_array_size = sizeof delays / sizeof delays[0];
byte button_toggle = 0; // For debouncing buttons. 
byte delay_index = 0; // Which delay to use. 
uint32_t delay_time = 0;
int steps_per_ud = 0; // 1/2 of steps befre changing direction in u/d mode.
int mode = 0; 
int single_shot_steps = 0; // Steps remaining in singleshot. 
bool is_running = true;

void setup(void) {
  
  Serial.begin(115200);
  Serial.println("Starting");

  // Setup all 6 encoders
  for ( int i = 0 ; i < 6; i++) {
    qg[i] = new QuadratureGenerator( 
        i,
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

#if defined(_SAM3XA_)
    Timer3.attachInterrupt(read_write_keys);
    Timer3.start(200000); // .2 s
#else
    Timer1.attachInterrupt(read_write_keys);
    Timer1.initialize(200000); // .2 s
#endif
     
    module.setDisplayToDecNumber(delay_time, 0, false);
    module.setDisplayToString(mode_names[mode]);
  }

// Timer interrupt routine for reading the keys  and setting the 
// frequency display. 



void read_write_keys(){

  byte keys = module.getButtons();


  if(keys > 0 && button_toggle == 0){
    
      button_toggle = 5;
    
      if B_IS_SET(keys, NEXT_SPEED_BTN){
        delay_index = (delay_index == (delay_array_size-1)) ? 0 : delay_index + 1;
      } else if  B_IS_SET(keys, PREV_SPEED_BTN){
        delay_index = (delay_index == 0) ? (delay_array_size-1) : delay_index - 1;

      } else if  B_IS_SET(keys, UD_BTN){
        mode = (mode+1)%4;

        switch(mode){
          case MODE_UP:
            // Up
            dir = 1;
            break;
          case MODE_DOWN:
            // Down
            dir = -1;
            break;
        } 

        if (mode == MODE_STOP) {
          is_running = false;
        } else {
          is_running = true;
        }
           
      } else if  B_IS_SET(keys, START_STOP_BUTTON){
        if (is_running){
          is_running = false;
          mode = MODE_STOP;
        } else{
           is_running = true;
           if (mode == MODE_STOP){
              mode = MODE_UP ; //Start
           }
        }
        
      } else if  B_IS_SET(keys, SINGLE_SHOT_BUTTON){
        mode = MODE_SINGLE_SHOT;
        is_running = true;
      }
      
      steps_per_ud =  delay_time = delays[delay_index];

      int steps_per_sec = delay_time * dir;

      if (mode == MODE_SINGLE_SHOT){
        single_shot_steps = delays[delay_index];
      }

      module.setDisplayToSignedDecNumber( steps_per_sec, 0, delay_time==0);
      module.setDisplayToString(mode_names[mode]);

      
      
  } else if (keys > 0 && button_toggle > 0){
      // Do nothing until button is released
      button_toggle--;
  } else {
      button_toggle = 0;
  } 

  module.setLED(is_running ? TM1638_COLOR_RED : TM1638_COLOR_NONE, RUNNING_LED);
  module.setLED(dir > 0 ? TM1638_COLOR_RED : TM1638_COLOR_NONE, UD_LED);
}

int idx = 0;

void loop() {

  

  for (int i = 0; i < 6; i++) {
    if (dir > 0) {
      qg[i]->setDirection(QuadratureGenerator::CW);
    } else {
      qg[i]->setDirection(QuadratureGenerator::CCW);
    }

    if (is_running){
      qg[i]->stepAlways(micros());
    }
 
  }

 
  /// Change direction in u/d mode
  if (mode == MODE_UD && (abs(qg[0]->getPosition())  > steps_per_ud*2)){

    if (qg[0]->getPosition() > 0){
      dir = -1;
      
    } else {
      dir = 1;
    }
  } else if ( mode == MODE_SINGLE_SHOT ){

    if (single_shot_steps > 0){
      single_shot_steps--;
    } else {
      is_running = false;
      mode = MODE_STOP;
    }
    
  }

  

  if(old_dir != dir){
    old_dir = dir;
  }

  delayMicroseconds(SEC_IN_US/delay_time);
  idx++;

  

}



