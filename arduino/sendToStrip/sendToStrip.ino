#include <Adafruit_NeoPixel.h>

#define PIN 6
#define HALO_SIZE 5
#define STRIP_LENGTH 144
long br[STRIP_LENGTH] ; // actual values
long sbr[STRIP_LENGTH] ; // desired values
//int next_lights[STRIP_LENGTH];

int slide;
float dimm = 1.0;


#define PIN 6
Adafruit_NeoPixel strip = Adafruit_NeoPixel(STRIP_LENGTH, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(11500);
  strip.begin();

  for (int i = 0; i < STRIP_LENGTH; i++) {
    sbr[i] = 20.0;
  }

}

void loop() {

  if (slide <= 11) {
    pulse();
  }

  if (slide == 11) {
    upTo(0 * 2);
  }

  if (slide == 12) {
    upTo(2 * 2);
  }

  if (slide == 13) {
    upTo(7 * 2);
  }

  if (slide == 14) {
    fromTo(7 * 2, 23 * 2);
  }

  if (slide == 15) {
    fromTo(23 * 2, 31 * 2);
  }

  if (slide == 16) {
    fromTo(31 * 2, 39 * 2);
  }

  if (slide == 17) {
    fromTo(47 * 2, 47 * 2);
  }

  if (slide == 18) {
    pulse();
  }

  if (slide == 19) {
    pulse();
  }


  ///
  /*
    if (slide == 13) {
      fromTo(18 * 2, 22 * 2);
    }

    if (slide == 14) {
      fromTo(22 * 2, 40 * 2);
    }
    */

  for (int i = 0; i < STRIP_LENGTH; i++) {
    br[i] += 0.15f * (sbr[i] - br[i]);
  }

  for (int i = 0; i < strip.numPixels(); i++) {

    int r = int(map(br[i], 0.0, 255.0, 15.0, 255.0) * dimm);
    int g = int(map(br[i], 0.0, 255.0, 4.0, 255.0) * dimm);
    int b = int(map(br[i], 0.0, 255.0, 0.0, 235.0) * dimm);

    // strip.setPixelColor(i, int(br[i]), int( br[i]), int(br[i]));
    strip.setPixelColor(i, r, g, b);
  }
  strip.show();
}


int gauss (int i, float offset) {//compute value at LED i, given center of bell curve at offset
  float x = 0.5 * (i - offset + 3) - 1.5;
  return (int)(255.f * pow(5, -pow(x * 1.5, 2)));
}

void serialEvent() {
  slide =  int(Serial.read());

  for (int i = 0; i < STRIP_LENGTH; i++) {
    if (i % 2 == 0) {
      sbr[i] = 10.0;
    } else {
      sbr[i] = 10.0;
    }
  }
}

void pulse() {
  for (int i = 0; i < STRIP_LENGTH; i++) {
    /*
    if (i % 2 == 0) {
      sbr[i] = (sin(-millis() / 1000.0 + i / 10.0) + 1.0) / 2.0 * 200.0 + 50.0;
    } else {
      sbr[i] = (sin(-millis() / 1000.0 + i / 10.0) + 1.0) / 2.0 * 200.0 + 50.0;
    }*/
    sbr[i] = (sin(-millis() / 800.0 + i / 15.0) + 1.0) / 2.0 * 200.0 + 50.0;
  }
}

void upTo(int whichWeek) {
  float phaseShift = map(whichWeek , 0.0, 54.0, 3.0, 15.0);
  float velo = map(whichWeek, 0.0, 54.0, 150.0, 800.0);
  for (int i = 0; i < whichWeek - 1 ; i++) {
    sbr[i] = (sin(-millis() / velo + i / phaseShift) + 1.0) / 2.0 * 40.0 + 70.0;
  }

  sbr[whichWeek] = 255;

  for (int i = whichWeek + 1; i < STRIP_LENGTH; i++) {
    sbr[i] = (sin(-millis() / 800.0 + i / 15.0) + 1.0) / 2.0 * 5.0 + 20.0;
    //sbr[i] = 0;
  }
}


void fromTo(int startWeek, int whichWeek) {
  for (int i = 0; i < STRIP_LENGTH ; i++) { //alle werte
    sbr[i] = (sin(-millis() / 800.0 + i / 15.0) + 1.0) / 2.0 * 5.0 + 20.0;
  }

  float phaseShift = map(whichWeek - startWeek, 0.0, 54.0, 3.0, 15.0); // fuellbereich
  float velo = map(whichWeek - startWeek, 0.0, 54.0, 150.0, 800.0);
  for (int i = startWeek; i < whichWeek - 1 ; i++) {
    sbr[i] = (sin(-millis() / velo + i / phaseShift) + 1.0) / 2.0 * 40.0 + 70.0;
  }

  sbr[whichWeek] = 255.0; //begrenzer 
  sbr[startWeek] = 255.0;  //begrenzer 
}





