#include <Adafruit_NeoPixel.h>

#define PIN 6
#define HALO_SIZE 11
#define STRIP_LENGTH 72
int current_lights[STRIP_LENGTH] ;
int next_lights[STRIP_LENGTH];
float current, next;
int count = 0;


Adafruit_NeoPixel strip = Adafruit_NeoPixel(STRIP_LENGTH, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(11500);
  strip.begin();
}

void loop() {  

  current = current + 0.2*(next-current);
  for (int i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i,0.5*gauss(i,current),0.3*gauss(i,current),0.15*gauss(i,current));
  }

  strip.show();  
}

int gauss (int i, float offset) { //compute value at LED i, given center of bell curve at offset
  float x = 0.5*(i+offset)-1.5;  
  return (int)(255.f*pow(5,-pow(x,4)));
}

void serialEvent() {
  next = - float(Serial.read());
}
