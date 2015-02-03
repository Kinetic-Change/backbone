ArrayList <Layer> layers;
ArrayList <Slider> sliders;
ArrayList <Button> octagonButtons = new ArrayList <Button>();


PFont font0, font1, font2, font3;

int selected = 0;
int sel = 54-1;
int spacing = 9 + 5;

float rotX = PI/2, rotY, rotZ = 0;
float yOff;

float r = 110;

color [] curveColors = new color[8];

boolean animate, showSelected2D = true, showTimeCurves2D = true, showTimeCurves, showOctagons = true, showSelVals = true, showShapes = true, showScalars = true, debug;
boolean showBone = true;

Slider s1;


void setup() {
  size(1920, 1080, P3D);
  //size(1280, 800, OPENGL);

  layers = new ArrayList <Layer>();
  sliders = new ArrayList <Slider>();

  createLayers("bone", 54, spacing, r);
  //setCurvesColors();
  //setNoise();
  //createSliders();

  PVector p1 = new PVector(width/2 - (r*1.15) - 200, 100);
  s1 = new Slider(p1, sliders.size(), "v", height - 2*100);

  font0 = createFont("Arial-Black", 68);
  font1 = createFont("Arial-Black", 32);
  font2 = createFont("Arial-Black", 18);
  font3 = createFont("Arial-Black", 8);

  strokeCap(ROUND);

  createOctagonButtons(150, 866, 27.7, 27.7);
}

void draw() {
  if (animate) {
    if (selected == 54-1) {
      sel=0;
    }
    if (selected == 0) {
      sel=53;
    }
  }

  lights();
  yOff = height/1.12;
  /*if (mouseX > width/2 - r*1.15 - 100 && mouseX < width/2 + r*1.15 + 100) 
   rotX = map(mouseY, 0, height, PI/2, 0);*/
  if (mousePressed) {
    rotX = rotX + (pmouseY - mouseY)*0.002;
  }

  rotZ+=.0035;

  //selected = int((selected + 0.12*(sel-selected)));

  if (selected!=sel && sel > selected) selected++;
  if (selected!=sel && sel < selected) selected--;

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
  scale(1.05);  

  checkLayers3D();

  strokeWeight(1/1.05);
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
    translate(width*.22, height * .54);
    rotate(-PI);
    scale(1.9);
    displaySelected(selected, debug);
    popMatrix();
  }

  if (showTimeCurves2D) {
    pushMatrix();
    translate(width/2 + r*1.15 + 200, height*.295);
    scale(.6);
    displayTimeCurves2D(curveColors, selected);
    popMatrix();
  }

  if (showOctagons) {
    pushMatrix();
    translate(152, height-215);
    //translate(width/2 + r*1.15 +350, 380);
    scale(.1);
    strokeWeight(1/.2);
    displayLayersOctagons(selected, 2.5);
    popMatrix();
  }
  displayText(showSelected2D, showTimeCurves2D);
  debugOctagonButtons(debug);
  picked3D(selected);
}

void keyPressed() {
  if (key == ' ') {
    //setLayersValues(r);
  }
  if (key == 'c')  setCurvesColors();
  if (key == 's')  sel = int(random(0, layers.size()-1));

  if (key == '1') {
    sel = 54-1;
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

  if (key == 'd') {
    debug =! debug;
  }
  if (key == 'p') {
    saveFrame("shots/####.jpeg");
  }
}

void mousePressed() {
  clickOctagonButtons();
  if (mouseX > width/2-r && mouseX< width/2+r) {
    sel = picked3D(selected);
  }
}

void mouseReleased() {
  releaseOctagonButtons();
}

