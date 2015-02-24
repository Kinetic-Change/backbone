Table table;

void createLayers(String table_name, int _a, int _spac, float _r) {
  table = loadTable(table_name + ".csv", "header");

  for (TableRow row : table.rows ()) {
    int id = row.getInt("index");
    //print(id + " -" );
    PVector h = new PVector(0, 0, id*_spac);
    Layer l = new Layer(h, id, _r); 

    l.val = new PVector[8];
    for (int i = 0; i<l.val.length; i++) {
      float _x =  row.getFloat("val" + (i+1));
      l.val[i] = new PVector(_x, 0);
      l.val[i].mult(_r); 
      l.val[i].rotate(i * (PI/4));
      //print("  " + l.val[i]);
    }
    //println();
    l.createPs();
    layers.add(l);
  }
}

class Layer extends PVector {
  int id;
  PVector [] val;
  ArrayList <PVector> cps;
  float valFloat;
  boolean over;

  Button b = new Button();

  boolean selected = false;
  float alpha=-20;
  float overAlpha = 0;

  Layer(PVector h, int _id, float _r) {
    super(h.x, h.y, h.z);
    this.id = _id;
    this.val = new PVector[8];
    //this.setVals(_r);
  }


  void setVals(float _r) {
    val = new PVector[8];
    for (int i = 0; i<val.length; i++) {
      val[i] = new PVector(random(0.2, 1), 0);
      val[i].mult(_r); 
      val[i].rotate(i * (PI/4));
    }
    createPs();
  }

  boolean over(ArrayList <Button> octaButtons) {
    boolean o = false;
    b = octaButtons.get(id);
    if (b.over) {
      o = true;
    } else {
      o = false;
    }
    return o;
  }

  void update(int _s) {
    if (id == _s) {
      selected=true;
    } else {
      selected=false;
    }
  }

  void glow() {
    if (selected) {
      //alpha = 200;
      alpha = 255;
    } else {
      alpha = alpha + 0.0512*(30-alpha);
    }

    if (b.over) {
      overAlpha = overAlpha + 0.123 * (70 - overAlpha);
    } else {
      overAlpha = overAlpha + 0.123 * (0 - overAlpha);
    }
  }

  void createPs() {
    cps = new ArrayList <PVector>(); 
    int steps = 10;
    for (int a = 0; a < 8; a++) {
      for (int i = 0; i <= steps; i++) {
        float t = i / float(steps);
        float _x=0, _y=0;
        int b = 0;
        if (a < 5) {
          _x = curvePoint(val[a].x, val[a+1].x, val[a+2].x, val[a+3].x, t);
          _y = curvePoint(val[a].y, val[a+1].y, val[a+2].y, val[a+3].y, t);
        }
        if (a == 5) {
          _x = curvePoint(val[a].x, val[a+1].x, val[a+2].x, val[0].x, t);
          _y = curvePoint(val[a].y, val[a+1].y, val[a+2].y, val[0].y, t);
        }

        if (a == 6) {
          _x = curvePoint(val[a].x, val[a+1].x, val[0].x, val[1].x, t);
          _y = curvePoint(val[a].y, val[a+1].y, val[0].y, val[1].y, t);
        }

        if (a == 7) {
          _x = curvePoint(val[a].x, val[0].x, val[1].x, val[2].x, t);
          _y = curvePoint(val[a].y, val[0].y, val[1].y, val[2].y, t);
        }

        PVector cp = new PVector(_x, _y, this.z);
        //println(cp);
        cps.add(cp);
      }
    }
  }

  void displayCurvePoints() {
    beginShape(POINTS);
    for (int i = 0; i < cps.size (); i++) {
      PVector cp = cps.get(i);
      vertex(cp.x, cp.y, cp.z);
    }
    endShape();
  }

  void displayEdge(int _s) {

    if (id == _s) {
      fill(255, alpha);
    } else {
      fill(255, alpha);
    }



    float h = 5;

    for (int i = 1; i < cps.size (); i++) {
      PVector cp = cps.get(i);
      PVector lcp = cps.get(i-1);
      beginShape(QUADS);
      vertex(cp.x, cp.y, cp.z);
      vertex(lcp.x, lcp.y, lcp.z);
      vertex(lcp.x, lcp.y, lcp.z - h);
      vertex(cp.x, cp.y, cp.z - h);
      endShape(CLOSE);
    }
  }

  void displayOctagon(int _s, float xOff, float yOff) {
    noStroke();
    fill(255, alpha);
    b = octagonButtons.get(id);
    if (b.over || over) { 
      fill(200, 100, 0, 150); 
      noStroke();
    }

    beginShape();
    for (int i = 0; i<cps.size (); i++) {
      PVector cp = cps.get(i);
      vertex(cp.x + xOff, cp.y + yOff);
    }
    endShape(CLOSE);
  }


  void display(int _s) {
    stroke(100, 75);
    fill(100, 18);

    if (id == _s) {
      stroke(255, alpha); 
      fill(100, 30);
    } 

    b = octagonButtons.get(id);
    if (b.over || over) {
      fill(200, 100, 0, 60);
      stroke(200, 100, 0, 100);
    } 

    beginShape();
    for (int i = 0; i<cps.size (); i++) {
      PVector cp = cps.get(i);
      vertex(cp.x, cp.y, cp.z);
    }
    endShape(CLOSE);
  }

  void display2D() {
    beginShape();
    for (int i = 0; i < cps.size (); i++) {
      PVector cp = cps.get(i);
      vertex(cp.x, cp.y);
    }
    endShape();
  }


  void displayScalar(int _s, boolean _3d) {

    stroke(255, alpha);
    if (_3d) {
      strokeWeight(1f/zoom);
    } else {
      strokeWeight(.75f/1.9);
    }

    b = octagonButtons.get(id);
    if (b.over || over) {
      stroke(200, 100, 0);
    } 

    for (int i = 0; i<val.length; i++ ) {
      beginShape(LINES);
      vertex(0, 0, z);
      vertex(val[i].x, val[i].y, z);
      endShape();
    }

    float spac1 = 2;
    float spac2 = spac1 * 10;
    float length1 = 3;
    float length2 = 6.5;
    for (int i = 0; i<val.length; i++ ) {
      for (float j = 10; j < val[i].mag (); j+=spac1) {  
        beginShape(LINES);
        vertex(j, -length1/2, z);
        vertex(j, length1/2, z);
        endShape();
      }
      for (int k = 10; k < val[i].mag (); k+=spac2) {
        if (k!=10) {
          beginShape(LINES);
          vertex(k, -length2/2, z);
          vertex(k, length2/2, z);
          endShape();
        }
      }
      rotateZ(PI/4);
    }
  }
}

void updateLayers(int _s) {
  for (int i = 0; i<layers.size (); i++) {
    Layer l = layers.get(i);
    //l.update(_s);
    //l.glow();
  }
}

void setLayersValues(float _r) {
  for (int i = 0; i<layers.size (); i++) {
    Layer l = layers.get(i);
    l.setVals(_r);
  }
}

void displayLayers(int _s) {
  for (int i = 0; i<layers.size (); i++) {
    Layer l = layers.get(i);
    l.display(_s);
  }
}

void displayLayersScalars(int _s, boolean _d) {
  if (_d) {
    for (int i = 0; i<layers.size (); i++) {
      Layer l = layers.get(i);
      l.displayScalar(_s, true);
    }
  }
}

void displayLayersEdges(int _s) {
  for (int i = 0; i<layers.size (); i++) {
    Layer l = layers.get(i);
    l.displayEdge(_s);
  }
}

void displayLayersOctagons(int _s, float _f) {
  float xOff = 0;
  float yOff = 0;
  for (int i = 0; i<layers.size (); i++) {
    if (i%(54/3)==0) {
      xOff = 0;
      yOff += r*_f;
    } else {
      xOff+=r*_f;
    }
    Layer l = layers.get(i);
    l.displayOctagon(_s, xOff, yOff);
  }
}

/////////////////////////////////////////////////////////////////////////DEBUG

void displayLayersCurvePoints() {
  strokeWeight(1.5);
  stroke(170, 225, 0);

  hint(DISABLE_DEPTH_TEST);
  for (int i = 0; i<layers.size (); i++) {
    Layer l = layers.get(i);
    l.displayCurvePoints();
  }
}

void displayTimeCurves2D(color [] c, int _s) {

  int dayVal=1, monthVal = 1;
  float yOff = 0;
  Layer sl = layers.get(_s);

  hint(DISABLE_DEPTH_TEST);
  noFill();
  stroke(200);

  for (int j = 0; j<8; j++) {
    //stroke(c[j], 150);
    //stroke(60);
    strokeWeight(.75/.8f);
    yOff+=r*1.1;
    beginShape();
    for (int i = 0; i<layers.size (); i++) {
      Layer l = layers.get(i);
      stroke(l.alpha);
      vertex(i*spacing, l.val[j].mag() + yOff);
    }
    endShape();

    hint(DISABLE_DEPTH_TEST);
    noFill();
    stroke(200, 100, 0, 200);


    for (int i = 0; i < octagonButtons.size (); i++) {
      Button b = octagonButtons.get(i);
      Layer ol = layers.get(b.id);
      if (b.over || ol.over) {
        strokeWeight(1);
        beginShape(LINES);
        vertex(ol.z, 0);
        vertex(ol.z, 1110);
        endShape();
        strokeWeight(8);
        beginShape(POINTS);
        vertex(ol.z, ol.val[j].mag()+yOff);
        endShape();
      }
    }
  }
}

void setCurvesColors() {
  for (int i=0; i < 8; i++) {
    curveColors[i] = color(200, random(255), random(255));
  }
}

void displayTimeCurves(color [] c, int _s) {
  strokeCap(ROUND);
  noFill();
  for (int j = 0; j<8; j++) {
    //stroke(c[j], 150);
    stroke(90, 100);
    strokeWeight(5*1.15);
    hint(ENABLE_DEPTH_TEST);
    beginShape();
    for (int i = 0; i<layers.size (); i++) {
      Layer l = layers.get(i);
      vertex(l.x + l.val[j].x, l.y + l.val[j].y, l.z + l.val[j].z);
    }
    endShape();
    //stroke(c[j]);
    stroke(200, 150);
    strokeWeight(7);
    hint(DISABLE_DEPTH_TEST);
    Layer l = layers.get(_s);
    beginShape(POINTS);
    vertex(l.x + l.val[j].x, l.y + l.val[j].y, l.z + l.val[j].z);
    endShape();
  }
}

void setNoise() {

  for (int j = 0; j<8; j++) {
    for (int i = 1; i<layers.size (); i++) {
      Layer l = layers.get(i);
      l.createPs();
      Layer ll = layers.get(i-1);
    }
  }
}


void displaySelected(int _s, boolean d) {
  fill(50);
  strokeWeight(.7);
  rectMode(CENTER);

  Layer l = layers.get(_s);
  translate(0, 0, -l.z); //=>ortho
  for (int i = 0; i <l.val.length+1; i++) {
    stroke(80);
    line(0, 0, r*1.05, 0);
    fill(80);
    rect(r*1.05, 0, 20/2.5, 5/2.5);
    rotate(PI/4 * i);
  }

  strokeWeight(.5f);
  for (int i = 0; i < octagonButtons.size (); i++) {
    Button b = octagonButtons.get(i);
    Layer ol = layers.get(i);
    if (b.over || ol.over) {

      stroke(200, 100, 0, 200);
      fill(200, 100, 0, 90);
      ol.display2D();
      ol.displayScalar(selected, false);
    }
  }

  stroke(255, l.alpha); 
  fill(255, 26);
  l.display2D();
  strokeWeight(.4f);
  l.displayScalar(selected, false);
 
  hint(ENABLE_DEPTH_TEST);
  fill(0);
  strokeWeight(.75f/2.3);
  if(whichSlide >=7)
  ellipse(0, 0, 20, 20);
  
  strokeWeight(1.2f);

  if (d) {
    fill(170, 225, 0, 30);
    noStroke();
    ellipse(0, 0, r * 2, r * 2);
  }
}

int picked3D(int _s) {
  int picked = _s;
  int c=0;
  for (int i=0; i< layers.size (); i++) {
    Layer l = layers.get(i);
    if (l.over) {
      picked =i;
    }
  }
  return picked;
}

void checkLayers3D() {
  for (int i =0; i <layers.size (); i++) {
    Layer l = layers.get(i);
    float xV = screenX(l.x, l.y, l.z);
    float yV = screenY(l.x, l.y, l.z);
    float d = dist(mouseX, mouseY, xV, yV);
    //println(xV + " - " +yV + " - " + i + " - " + d);

    if (mouseX > xV - r && mouseX < xV + r && mouseY > yV - 7 && mouseY < yV + 7) {
      l.over = true;
      for (int j =0; j <layers.size (); j++) {
        Layer ol = layers.get(j);
        if (i!=j) { 
          ol.over = false;
        }
      }
    } else {
      l.over = false;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////// MOTION

void pulse(int _fromLayer, int _toWhichLayer) {
  for (int i = _fromLayer; i<_toWhichLayer+1; i++) {
    Layer l = layers.get(i);
    l.alpha = (sin(-millis() / 850.0 + i / 90.0) + 1.0) / 2.0 * 180.0 + 20.0;
  }
}

void fromTo(int _fromLayer, int _toWhichLayer) {

  for (int i = 0; i < layers.size (); i++) {
    Layer l = layers.get(i);
    l.alpha = (sin(-millis() / 800.0 + i / 15.0) + 1.0) / 2.0 * 3.0 + 8.0;
  }

  float phaseShift = map(_toWhichLayer - _fromLayer, 0.0, 54.0, 3.0, 15.0);
  float velo = map(_toWhichLayer - _fromLayer, 0.0, 54.0, 150.0, 800.0);

  for (int i = _fromLayer; i < _toWhichLayer+1; i++) {
    Layer l = layers.get(i);
    l.alpha = (sin(-millis() / velo + i / phaseShift) + 1.0) / 2.0 * 27.0 + 30.0;
  }
  Layer sl = layers.get(_toWhichLayer);
  //sl.alpha = 120;
  selected = _toWhichLayer;
  //sbr[whichWeek] = 255.0;
  //sbr[startWeek] = 255.0;
}

