
/*
   Generate quadrature encoder, index and limit siggnals like one axis of an IXD 6 Axis robot.

   The program reads a potentiometer on analog A0 to set the step generation speed.
   Pin 4: Limit switch. High for half of axis rotation, low for the other half
   Pin 5: Quadrature A
   Pin 6: Quadrature B
   Pin 7: Index
*/

#include <bithacks.h>
#include <digitalWriteFast.h>
#include <math.h>
#include <DueTimer.h>


#define POT_PIN A0

#define ENC_STPS_PER_INDEX 1024
#define ENC_STPS_PER_ROT ENC_STPS_PER_INDEX*4

#define MAX_DEL 250000
#define MIN_DEL 0

#define fastSet(pin) (digitalPinToPort(pin)->PIO_SODR |= digitalPinToBitMask(pin) )
#define fastClear(pin) (digitalPinToPort(pin)->PIO_CODR |= digitalPinToBitMask(pin) )
#define fastWrite(pin, value) ( value ? fastSet(pin) : fastClear(pin)   )

class QuadratureGenerator {

  private:

    uint8_t a_pin;
    uint8_t b_pin;
    uint8_t i_pin;
    uint8_t l_pin;

    int32_t pos = 0;

    int8_t steps[4] = {2, 3, 1, 0};

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
      } else {
        fastClear(l_pin);
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
};


QuadratureGenerator **qg  = new QuadratureGenerator*[6];

void setup(void) {
  Serial.begin(115200);
  Serial.println("Starting");
  for ( int i = 0 ; i < 6; i++) {
    qg[i] = new QuadratureGenerator( (i * 4) + 22, (i * 4) + 23, (i * 4) + 24, (i * 4) + 25);
  }

  Timer3.attachInterrupt(read_analog);
  Timer3.start(500000); // .5 s
  
}

int16_t analogVal;
int32_t next_analog_read = 0;

int8_t dir = 0;
uint32_t delay_time = 0;

#define SEC_IN_US 1000000

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

void read_analog() {

    int sz = sizeof(delays)/sizeof(delays[0]);

    analogVal = analogRead(POT_PIN)-512;
    int delay_index =  map(abs(analogVal), 0, 512, sz-1, 0);
    delay_time = delays[delay_index];
    dir = (analogVal > 0) ? 1 : -1;

    if(false){
    Serial.print(analogVal);
    Serial.print(" ");
    Serial.print(delay_index);
    Serial.print(" ");
    Serial.print(delay_time);
    Serial.print(" ");
    Serial.print(dir);
    Serial.println(" ");
    }
}

void loop() {

  //Serial.print(delay_time);
  //Serial.print(": ");

  for (int i = 0; i < 6; i++) {
    if (dir > 0) {
      qg[i]->stepUp();
    } else {
      qg[i]->stepDown();
    }
    //Serial.print(qg[i]->getPosition());
    //Serial.print("; ");
  }
  //Serial.println(" ");

  delayMicroseconds(delay_time);

  
}



