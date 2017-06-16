/* Encoder Library - Basic Example
   http://www.pjrc.com/teensy/td_libs_Encoder.html

   This example code is in the public domain.
*/

#include <Encoder.h>
#include <math.h>

#define NUM_ENC 3
#define VEL_READ_DEL 500 // How often to calc velocity, in miliseconds

class VelEncoder : public Encoder {

  private:
    uint32_t last_velocity_time = 0;
    int32_t last_position = 0;

  public:

    VelEncoder(uint8_t pin1, uint8_t pin2) : Encoder(pin1, pin2) {
        last_velocity_time = micros();
    }

    inline float getVelocity(){

      float v = fabs( (encoder.position - last_position)*1000000.0 )
                /
                 float( micros() - last_velocity_time);
      
      last_velocity_time = micros();
      last_position = encoder.position;
      
      return v;
    }
  
};


VelEncoder encoders[] = {
  VelEncoder(22,23),
  VelEncoder(24,25),
  VelEncoder(26,27),
  VelEncoder(28,29),
  VelEncoder(30,31),
  VelEncoder(32,33),
};


void setup() {
  Serial.begin(115200);
  Serial.println("Starting");
  pinMode(13, OUTPUT);

}

uint32_t next_print_time = 0; 

void loop() {

  
  if (millis() > next_print_time + VEL_READ_DEL) {

    Serial.print(":");

    for (int i = 0; i < 6; i++){
      Serial.print(encoders[i].read()); Serial.print(";"); 
      Serial.print(encoders[i].getVelocity()); Serial.print(" "); 
    }
    Serial.println("");
    
    next_print_time = millis();
    
  }
  



}
