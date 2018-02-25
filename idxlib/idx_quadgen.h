/*
* Quadrature generating version of the stepper interface
*/
#ifndef idx_quadgen_h
#define idx_quadgen_h

#include "idx_stepper.h"

#define ENC_STPS_PER_INDEX 8192 // Steps per encoder revolution
#define ENC_STPS_PER_ROT (ENC_STPS_PER_INDEX*8) // Steps per axis revolution

// Speedy output sets and clears on the Due, maybe others. 
#define fastSet(pin) (digitalPinToPort(pin)->PIO_SODR |= digitalPinToBitMask(pin) )
#define fastClear(pin) (digitalPinToPort(pin)->PIO_CODR |= digitalPinToBitMask(pin) )
#define fastWrite(pin, value) ( value ? fastSet(pin) : fastClear(pin)   )


/* Quarature Encoder Class. Represents one axis. */
class QuadratureGenerator : public IDXStepGenerator {

  private:

    uint8_t a_pin;
    uint8_t b_pin;
    uint8_t i_pin;
    uint8_t l_pin;

    int index_pos = 0;

    int8_t steps[4] = {2, 3, 1, 0};

    int limit_offset = 0;

    bool limit_set = false;
    bool limit_changed = false;

  public:

    inline QuadratureGenerator(uint8_t axis_n, uint8_t a_pin, uint8_t b_pin, uint8_t i_pin, uint8_t l_pin,
                               int limit_offset=0)
      : a_pin(a_pin), b_pin(b_pin), i_pin(i_pin), l_pin(l_pin), limit_offset(limit_offset), IDXStepGenerator(axis_n){

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

    
};


#endif