#include <Adafruit_NeoPixel.h>

#define PIN 6
#define HALO_SIZE 5
#define STRIP_LENGTH 144
float br[STRIP_LENGTH] ; // actual values
float sbr[STRIP_LENGTH] ; // desired values
//int next_lights[STRIP_LENGTH];



#define PIN 6
Adafruit_NeoPixel strip = Adafruit_NeoPixel(STRIP_LENGTH, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(11500);
  strip.begin();
  lastTime = millis();
  current = 0;


  for (int i = 0; i < STRIP_LENGTH; i++) {
    sbr[i] = 50.0;
  }

}

void loop() {

  for (int i = 0; i < STRIP_LENGTH; i++) {
    br[i] += 0.1f * (sbr[i] - br[i]);
  }

  sbr[10] = 255;

  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, br[i], br[i], br[i]);
  }
  strip.show();
}



int gauss (int i, float offset) {//compute value at LED i, given center of bell curve at offset
  float x = 0.5 * (i - offset + 3) - 1.5;
  return (int)(255.f * pow(5, -pow(x * 1.5, 2)));
}

void serialEvent() {
  next =  float(Serial.read());
  //  Serial.write(offset);
}


