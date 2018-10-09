/* Encoder Library - Basic Example
   http://www.pjrc.com/teensy/td_libs_Encoder.html

   This example code is in the public domain.
*/

#define ENCODER_OPTIMIZE_INTERRUPTS

#include <idx_encoder.h>
#include <math.h>
#include <PacketSerial.h>

#define NUM_ENC 3
#define VEL_READ_DEL 300 // How often to calc velocity, in miliseconds
#define ENC_STPS_PER_INDEX ((int)8192) // Steps per encoder revolution
#define ENC_STPS_PER_ROT (ENC_STPS_PER_INDEX*8) // Steps per axis revolution


PacketSerial serial;

typedef void (*DispatchFp)(void);

void blink(void);
void dispatch_index_interrupt_0(void);
void dispatch_limit_interrupt_0(void);

DispatchFp index_dispatchers[6];
DispatchFp limit_dispatchers[6];

int state = HIGH;

class VelEncoder;
VelEncoder *encoders[6]; 

struct encoder_report {
    int32_t position[6]; // 24
    int16_t hl_limits[6]; // 12
    int16_t lh_limits[6]; // 12

}; // 48

class VelEncoder : public Encoder {

  private:
    uint32_t last_velocity_time = 0;
    int32_t last_position = 0;

    uint8_t axis; 

    uint8_t limit_pin; 
    uint8_t index_pin;

    bool limit_set = false;
    int32_t last_limit_position_hl = 0; // Limit for high to low transition, going forward
    int32_t last_limit_position_lh = 0; // Limit for low to high transition, going forward
    int32_t limit_offset = 0; // Correction in position based on locations of limit

    int32_t last_index_position = 0;
    int32_t index_offset = 0; // Correction in position based on locations of indexes
  
    
  public:

    VelEncoder(uint8_t axis, uint8_t a_pin, uint8_t b_pin, uint8_t index_pin, uint8_t limit_pin) : 
        Encoder(a_pin, b_pin), axis(axis), index_pin(index_pin), limit_pin(limit_pin) {

        last_velocity_time = micros();

        #ifdef INPUT_PULLUP
        pinMode(index_pin, INPUT_PULLUP);
        pinMode(limit_pin, INPUT_PULLUP);
        #else
        pinMode(index_pin, INPUT);
        digitalWrite(index_pin, HIGH);
        pinMode(limit_pin, INPUT);
        digitalWrite(limit_pin, HIGH);
        #endif

        attachInterrupt(digitalPinToInterrupt(index_pin), index_dispatchers[axis], RISING);
        attachInterrupt(digitalPinToInterrupt(limit_pin), limit_dispatchers[axis], CHANGE);

        encoder.axis = axis;

    }

    inline float getPosition(){
      return encoder.position;
    }

    inline float getIndexOffset(){
      return index_offset;
    }

    inline float getVelocity(){
      /* This calculation will be wrong if the encoder changes direction. */
      
      float v = fabs( (encoder.position - last_position)*1000000.0 )
                /
                float( micros() - last_velocity_time);
      
      last_velocity_time = micros();
      last_position = encoder.position;
      
      return v;
    }

    inline bool getLimitSet(){
      return limit_set;
    }

    inline int getLastIndexPosition(){
      return last_index_position;
    }
    
    // Return the H->L transition limit
    inline int getHlLimitPosition(){
      return last_limit_position_hl;
    }

    // Return the L->H transition Limit
    inline int getLhLimitPosition(){
      return last_limit_position_lh;
    }

    // Returns the internal state variable, which is used as a 4 bit shift register, 
    // holding the last two encoder A and B pin readings. 
    inline int getState(){
      return encoder.state;
    }

    int getDirection(){
      return encoder.dir; 
      
    }

    void indexInterrupt();
    void limitInterrupt();

};


void VelEncoder::indexInterrupt(){

    index_offset = encoder.position % ENC_STPS_PER_INDEX ;
    
    if ( abs(index_offset) > (ENC_STPS_PER_INDEX/2)){
      index_offset = index_offset-ENC_STPS_PER_INDEX;
    }

    Serial.print(encoder.position); Serial.print(" "); Serial.println(index_offset);
    encoder.position -= index_offset;

    last_index_position = encoder.position; 
    
}

void VelEncoder::limitInterrupt(){

      limit_set = digitalRead(limit_pin);
      
      if(getDirection() > 0){
        // Going forward
        if(limit_set){
          // L -> H
          last_limit_position_lh = getPosition();
        } else {
          // H -> L
          last_limit_position_hl = getPosition();
        }
        
      } else {
        // Going Backwards
        if(limit_set){
          // L -> H
          last_limit_position_hl = getPosition();
        } else {
          // H -> L
          last_limit_position_lh = getPosition();
        }
      }
}

/* This nonsense is necessary because there is no way to attach arguments to an
 *  interrup handler, so we need to have one for every possible arguments. 
 */
void dispatch_index_interrupt_0(void){ encoders[0]->indexInterrupt(); } 
void dispatch_limit_interrupt_0(void){ encoders[0]->limitInterrupt(); } 

void dispatch_index_interrupt_1(void){ encoders[1]->indexInterrupt(); } 
void dispatch_limit_interrupt_1(void){ encoders[1]->limitInterrupt(); } 

void dispatch_index_interrupt_2(void){ encoders[2]->indexInterrupt(); } 
void dispatch_limit_interrupt_2(void){ encoders[2]->limitInterrupt(); } 

void dispatch_index_interrupt_3(void){ encoders[3]->indexInterrupt(); } 
void dispatch_limit_interrupt_3(void){ encoders[3]->limitInterrupt(); } 

void dispatch_index_interrupt_4(void){ encoders[4]->indexInterrupt(); } 
void dispatch_limit_interrupt_4(void){ encoders[4]->limitInterrupt(); } 

void dispatch_index_interrupt_5(void){ encoders[5]->indexInterrupt(); } 
void dispatch_limit_interrupt_5(void){ encoders[5]->limitInterrupt(); } 

void onPacket(const uint8_t* buffer, size_t size)
{

}

void setup() {

  //serial.setPacketHandler(&onPacket);
  serial.begin(115200);
  
  pinMode(13, OUTPUT);
  
  index_dispatchers[0] = dispatch_index_interrupt_0;
  index_dispatchers[1] = dispatch_index_interrupt_1;
  index_dispatchers[2] = dispatch_index_interrupt_2;
  index_dispatchers[3] = dispatch_index_interrupt_3;
  index_dispatchers[4] = dispatch_index_interrupt_4;
  index_dispatchers[5] = dispatch_index_interrupt_5;
  
  limit_dispatchers[0] = dispatch_limit_interrupt_0;
  limit_dispatchers[1] = dispatch_limit_interrupt_1;
  limit_dispatchers[2] = dispatch_limit_interrupt_2;
  limit_dispatchers[3] = dispatch_limit_interrupt_3;
  limit_dispatchers[4] = dispatch_limit_interrupt_4;
  limit_dispatchers[5] = dispatch_limit_interrupt_5;
  
  // Creating the VelEncoders must happen after the index_dispatchers and limit_dispatchers
  // array are set up because the VelEncoder constructor indexes the arrays. 
  encoders[0] = new VelEncoder(0,22,23,24,25);
  encoders[1] = new VelEncoder(1,26,27,28,29);
  encoders[2] = new VelEncoder(2,30,31,32,33);
  encoders[3] = new VelEncoder(3,34,35,36,37);
  encoders[4] = new VelEncoder(4,38,39,40,41);
  encoders[5] = new VelEncoder(5,42,43,44,45);
  
}

uint32_t last_print_time = 0; 

struct encoder_report msg;


void loop() {
  

  
  if (millis() > last_print_time + VEL_READ_DEL) {

    for(int i = 0; i < 6; i++){
      msg.position[i] = encoders[i]->getPosition();
      msg.hl_limits[i] = encoders[i]->getHlLimitPosition();
      msg.lh_limits[i] = encoders[i]->getLhLimitPosition();

      serial.send((const uint8_t*)&msg, sizeof(msg));
  
    }
   
    last_print_time = millis();
  }

  serial.update();
  
}
