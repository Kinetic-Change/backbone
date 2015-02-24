void displayText(boolean a, boolean b) {
  if (a) {
    noStroke();
    fill(200);
    textAlign(RIGHT);
    textFont(font1);
    //text((selected+1)*2, width/2 - r * 1.15 - 270, 300);


    for (int i = 0; i<layers.size (); i++) {
      Layer l = layers.get(i);
      if (l.over || l.b.over) {
        noStroke();
        fill(200, 100, 0, 150);
        textAlign(RIGHT);
        textFont(font1);
        //text((l.id+1)*2, width/2-r*2, 300);
      }
    }



    fill(90);
    textAlign(LEFT);
    textFont(font2);
    //text("/ 108", width/2 - r * 1.15 - 260, 300);
  }


  fill(200);
  textAlign(LEFT);
  textFont(font0);
  if (whichSlide >= 11) {
    if (selected < 27) {
      text("2013", 140, 300);
    } 
    else {
      text("2014", 140, 300);
    }
  }
  if (b) {
    fill(90);
    textAlign(LEFT);
    textFont(font3);
    text("01.01.2013", width/2 + r*1.3 + 200, 300);
    textAlign(RIGHT);
    textFont(font3);
    text("31.12.2014", width/2 + r*1.3 + 650, 300);
  }
  fill(70);
  textAlign(LEFT);
  textFont(font3);
  //text(frameRate, 140, 150);
}

void displaySelectedVals(int _s) {
  textAlign(RIGHT);
  hint(DISABLE_DEPTH_TEST);
  textFont(font0, 8);
  Layer l = layers.get(_s);

  fill(200, 255);
  for (int i = 0; i < l.val.length; i++) {
    //textFont(font0, map(l.val[i].mag(), 0, 110, 3, 18));
    noStroke();
    pushMatrix();
    translate((l.x + l.val[i].x)*1.7f, (l.y + l.val[i].y)*1.7f, l.z + l.val[i].z + 30);
    rotateZ(-rotZ);
    rotateX(-rotX);
    String a = nf(l.val[i].mag(), 2, 1) + "%";
    text(a, 0, 0, 0);
    popMatrix();
    stroke(200, 150);
    strokeWeight(1f/zoom);
    beginShape(LINES);
    vertex((l.x + l.val[i].x)*1.7f, (l.y + l.val[i].y)*1.7f, l.z + l.val[i].z + 27);
    vertex((l.x + l.val[i].x), (l.y + l.val[i].y), l.z + l.val[i].z);
    endShape();
  }

  fill(200, 100, 0, 220);
  for (int i = 0; i < octagonButtons.size (); i++) {
    Button b = octagonButtons.get(i);
    Layer ol = layers.get(b.id);

    if (b.over || ol.over) {
      for (int j = 0; j < ol.val.length; j++) {
        //textFont(font0, map(ol.val[j].mag(), 0, 110, 3, 18));
        noStroke();
        pushMatrix();
        translate((ol.x + ol.val[j].x)*1.7f, (ol.y + ol.val[j].y)*1.7f, ol.z + ol.val[j].z + 30);
        rotateZ(-rotZ);
        rotateX(-rotX);
        String a = nf(ol.val[j].mag(), 2, 1) + "%";
        text(a, 0, 0, 0);
        popMatrix();
        stroke(200, 100, 0, 190);
        strokeWeight(1f/zoom);
        beginShape(LINES);
        vertex((ol.x + ol.val[j].x)*1.7f, (ol.y + ol.val[j].y)*1.7f, ol.z + ol.val[j].z + 27);
        vertex((ol.x + ol.val[j].x), (ol.y + ol.val[j].y), ol.z + ol.val[j].z);
        endShape();
      }
    }
  }
}

