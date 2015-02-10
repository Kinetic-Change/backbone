#include <Adafruit_NeoPixel.h>

#define PIN 6
#define HALO_SIZE 5
#define STRIP_LENGTH 72
int brightness[STRIP_LENGTH] ;
//int next_lights[STRIP_LENGTH];
unsigned long timestamps[STRIP_LENGTH];
unsigned long lastTime;
float current, next;
int count = 0;

#define PIN 6
Adafruit_NeoPixel strip = Adafruit_NeoPixel(STRIP_LENGTH, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(11500);
  for (int i=0; i<strip.numPixels(); i++){
    timestamps[i] = millis();
  }
  strip.begin();
  lastTime = millis();
  current = 0;
}

void loop() {    
  //current = current - 0.05*(current-next);
  
  if (current!=next && next > current && timer(40)) current++;
  if (current!=next && next < current && timer(40)) current--;
  
  timestamps[(int) current] = millis();    
  for (int i=0; i<strip.numPixels(); i++) {    
/*
    if(next>current) {
      brightness[i] = trail(i+1)+gauss(i, current);
    }
    else {
      brightness[i] = trail(i+1.)+gauss(i, current);
    }
*/
    
    brightness[i] = trail(i);

    strip.setPixelColor(i, brightness[i], brightness[i], brightness[i]);
//    if ((current - (float) i)<= 0.5 && (current - (float) i)>= -0.5) strip.setPixelColor(i,255,0,0);
  }

  strip.show();  
//  Serial.println(current);
}

int trail(int i){
  //return map(millis()-timestamps[i], 0, 1000, 80, 0);
  float brightness = 255-0.15*(millis() - timestamps[i]);

  if (brightness > 0) {
    return brightness;
  }
  else {
    return 0;
  }
}

int gauss (int i, float offset) {//compute value at LED i, given center of bell curve at offset
  float x = 0.5*(i-offset+3)-1.5;  
  return (int)(255.f*pow(5,-pow(x*1.5,2)));
}

void serialEvent() {
  next =  float(Serial.read());
//  Serial.write(offset);
}

boolean timer (unsigned long time) {
  if ((millis() - lastTime) > time) {
    lastTime = millis();
    return true;
  } else {
    return false; 
  }
}
