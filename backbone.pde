import processing.serial.*;
Serial myPort;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

ArrayList <Layer> layers;
ArrayList <Slider> sliders;
ArrayList <Button> octagonButtons = new ArrayList <Button>();
ArrayList <Button> slideButtons = new ArrayList <Button>();
PImage [] slide;

int whichSlide=10;
int maxSlides=20;

PFont font0, font1, font2, font3;

int selected = 0; //current value
int sel = 54-1; //next value
int spacing = 9 + 5;

int screenw = 1920, screenh = 1080;

float rotX = PI/2, rotY, rotZ = 0;
float yOff = screenh/1.2, new_yOff, tempY;
float zoom = 1.05;

float r = 110;

color [] curveColors = new color[8];

boolean animate, showSelected2D = true, showTimeCurves2D, showTimeCurves, showOctagons = true, showSelVals, showShapes = true, showScalars = true, rotateBone, debug;
boolean showBone = true;

int lastTime;

Slider s1;

void setup() {
  size(screenw, screenh, OPENGL);
  //size(1280, 800, OPENGL);

  myPort = new Serial(this, Serial.list()[0], 11500);

  layers = new ArrayList <Layer>();
  sliders = new ArrayList <Slider>();

  createLayers("bone", 54, spacing, r);
  createSlideButtons(20, slide, 25);

  PVector p1 = new PVector(width/2 - (r*1.15) - 200, 100);

  font0 = createFont("Arial-Black", 68);
  font1 = createFont("Arial-Black", 32);
  font2 = createFont("Arial-Black", 18);
  font3 = createFont("Arial-Black", 8);

  strokeCap(ROUND);

  createOctagonButtons(150, 866, 26.3, 26.3);
  lastTime = millis();
  slide = new PImage[maxSlides];
  for (int i = 0; i < slide.length; i++) {
    slide[i] = loadImage("sl/Slides" + (i+1) + ".png");
  }
  setNextValue(whichSlide);
  smooth(16);
}

void draw() {

  if (selected!=sel && sel > selected) selected++;
  if (selected!=sel && sel < selected) selected--;

  if (whichSlide < 11) {
    pulse(0, 53);
  }

  if (whichSlide == 11) {
    sel = 0;
    fromTo(0, 0);
  }
  if (whichSlide == 12) {
    sel = 1;
    fromTo(0, 1);
  }
  if (whichSlide == 13) {
    sel = 7;
    fromTo(0, 7);
  }
  if (whichSlide == 14) {
    sel = 23;
    fromTo(7, 23);
  }
  if (whichSlide == 15) {
    sel = 31;
    fromTo(23, 31);
  }
  if (whichSlide == 16) {
    sel = 39;
    fromTo(31, 39);
  }
  if (whichSlide == 17) {
    sel = 47;
    fromTo(47, 47);
  }
  if (whichSlide == 18) {
    //selected = 53;
    pulse(0, 53);
  }
  if (whichSlide ==19) {
    pulse(0, 53);
  }

  lights();

  if (mousePressed && mouseButton == LEFT) {
    rotX = rotX + (pmouseY - mouseY)*0.002;
  }

  if (rotateBone) rotZ+=.0035;

  //selected = int((selected + 0.05*(sel-selected)));
  //if (selected!=sel && sel > selected && timer(20)) selected++;
  //if (selected!=sel && sel < selected && timer(20)) selected--;

  translateBone();
  //yOff = height*.89;
  updateLayers(selected);
  if (showOctagons) updateButtons();


  background(0);
  noLights();
  perspective();

  hint(ENABLE_DEPTH_TEST);  
  pushMatrix();
  translate(width/2, yOff);
  rotateX(rotX);
  rotateZ(rotZ);
  scale(zoom);  

  checkLayers3D();

  strokeWeight(1/zoom);
  noStroke();
  if (showShapes) {
    displayLayers(selected);
    pushMatrix();
    translate(0, 0, -5);
    displayLayers(selected);
    popMatrix();
    noStroke();
    displayLayersEdges(selected);
  }

  displayLayersScalars(selected, showScalars);

  if (showSelVals) displaySelectedVals(selected);
  if (debug) displayLayersCurvePoints();

  if (showTimeCurves) displayTimeCurves(curveColors, selected);
  popMatrix();

  ortho();
  hint(DISABLE_DEPTH_TEST);
  if (showSelected2D) {
    pushMatrix();
    translate(width*.2, height * .54);
    //translate(r, 0);
    //translate(-r, 0);
    rotate(rotZ);
    rotate(-PI);
    scale(1.9);
    displaySelected(selected, debug);
    popMatrix();
  }

  if (showTimeCurves2D) {
    pushMatrix();
    translate(width/2 + r*1.32 + 200, height*.295);
    scale(.6);
    displayTimeCurves2D(curveColors, selected);
    popMatrix();
  }

  if (showOctagons) {
    pushMatrix();
    translate(152, height-215);
    //translate(width/2 + r*1.15 +350, 380);
    scale(.13);
    strokeWeight(1/.2);
    displayLayersOctagons(selected, 1.83);
    popMatrix();
  }
  displayText(showSelected2D, showTimeCurves2D);
  debugOctagonButtons(debug);
  picked3D(selected);

  // checkSlideButtons(true);
  // growSlideButtons(true);
  // displaySlideButtons(true);
  /*
  if (!animate) {
   setNextValue(picked3D(selected));
   } else {
   setNextValue(selected);
   }
   */

  image(slide[whichSlide], 0f, 0f);
}

void keyPressed() {
  if (key == ' ') {
    //setLayersValues(r);
  }
  if (key == 'c')  setCurvesColors();
  if (key == 's')  setNextValue(int(random(0, layers.size()-1)));

  if (key == '1') {
    setNextValue(54-1);
    animate =! animate;
  }

  if (key == '2') {
    showSelected2D =! showSelected2D;
  }

  if (key == '3') {
    showOctagons =! showOctagons;
  }

  if (key == '4') {
    showTimeCurves2D =! showTimeCurves2D;
  }

  if (key == '5') {
    showTimeCurves =! showTimeCurves;
  }

  if (key == '6') {
    showSelVals =! showSelVals;
  }

  if (key == '7') {
    showShapes =! showShapes;
  }

  if (key == '8') {
    showScalars =! showScalars;
  }

  if (key == 'r') {
    rotateBone =! rotateBone;
  }

  if (key == 'd') {
    debug =! debug;
  }
  if (key == 'p') {
    saveFrame("shots/####.jpeg");
  }


  if (keyCode == RIGHT) {
    whichSlide++;
    whichSlide=whichSlide%maxSlides;
    println("Slide "+whichSlide);
    setNextValue(whichSlide);
  }

  if (keyCode == LEFT) {
    whichSlide--;
    if (whichSlide<0) {
      whichSlide=maxSlides-1;
    }
    //println("Slide " +whichSlide);
    setNextValue(whichSlide);
  }
}

void setNextValue(int s) {
  sel = s;
  myPort.write(byte(sel));
}

void mousePressed() {
  if (mouseButton == LEFT) {


    clickOctagonButtons();
    if (mouseX > width/2-r && mouseX< width/2 + r) {    
      animate = false;
    }
  }
}

boolean timer(int time) {
  if ((millis()-lastTime) > time) {
    lastTime = millis();
    return true;
  } else {
    return false;
  }
}

void mouseReleased() {
  releaseOctagonButtons();
}

void mouseWheel(MouseEvent event) {
  zoom += -event.getCount() * .2;
  //println(event.getCount());
}

void translateBone() {
  if (mousePressed && mouseButton == RIGHT) {
    new_yOff = pmouseY - mouseY;
    yOff = yOff - new_yOff;
  }
}
