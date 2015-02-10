
class Button extends PVector {

  float sb, b, h;
  int id, size;
  String func;
  boolean over = false;
  boolean clicked = false;
  boolean view=false;

  Button(int _id, float _x, float _y, float _b) {
    super(_x, _y);
    this.id = _id;
    this.b = _b;
    this.h = this.b;
  }

  Button() {
  }

  PImage slide;
  Button(int _id, float _x, float _y, PImage [] _slide, float _b) {
    super(_x, _y);
    this.id = _id;
    this.b = _b;
    this.h=_b;
    
  }

  void grow() {
    if (over) {
      b = b + 0.33 * (12 - b);
    } else {
      b = b + 0.33 * (5 - b);
    }
  }

  void displayPoint() {

    stroke(100);
    beginShape(POINTS);
    vertex(x, y);
    endShape();
  }

  void display() {
    noFill();
    strokeWeight(.5);
    if (over) {
      stroke(10, 200, 100);
    } else {
      stroke(170, 225, 0);
    }
    if (clicked) {
      stroke(0, 100, 200);
    }

    beginShape();
    vertex(x - b / 2, y - h / 2);
    vertex(x - b / 2, y + h / 2);
    vertex(x + b / 2, y + h / 2);
    vertex(x + b / 2, y - h / 2);
    endShape(CLOSE);
  }

  void rollOver() {
    if (mouseX > x - b / 2 && mouseX < x + b / 2 && mouseY > y - h / 2 && mouseY < y + h / 2) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void rollOverSlide() {
    if (mouseX > x - b*2 && mouseX < x + b*2 && mouseY > y - h * 2 && mouseY < y + h * 2) {
      over = true;
    } else {
      over = false;
    }
  }

  void click() {
    if (over) {
      clicked = true;
    }
  }

  void unclick() {
    clicked = false;
  }

  void name() {
  }
}

void createOctagonButtons(float _xOff, float _yOff, float _spac, float _b) {

  float valx = 0, valy = 0;

  for (int i = 0; i < layers.size (); i++) {

    if (i%(54/3)==0) {
      valx = 0;
      valy += _spac;
    } else {
      valx += _spac;
    }

    Button b = new Button(i, _xOff + valx, _yOff + valy, _b);
    octagonButtons.add(b);
  }
}

void updateButtons() {
  for (int i = 0; i < octagonButtons.size (); i++) {
    Button b = octagonButtons.get(i);
    b.rollOver();
  }
}

void clickOctagonButtons() {
  for (int i = 0; i < octagonButtons.size (); i++) {
    Button b = octagonButtons.get(i);
    b.click();
    if (b.clicked) {
      sel = i;
      animate = false;
    }
  }
}

void releaseOctagonButtons() {
  for (int i = 0; i < octagonButtons.size (); i++) {
    Button b = octagonButtons.get(i);
    b.unclick();
  }
}

void debugOctagonButtons(boolean _d) {
  if (_d) {
    strokeWeight(1);
    for (int i = 0; i < octagonButtons.size (); i++) {
      Button b = octagonButtons.get(i);
      b.display();
    }
  }
}

void createSlideButtons(int _a, PImage [] _slide, float _spac) {
  float xOff = 152;
  for (int i = 0; i < _a; i++) {
    Button b = new Button(i, xOff + (_spac * i), 330, _slide, _spac);
    slideButtons.add(b);
  }
}

void displaySlideButtons(boolean _d) {
  if (_d) {
    for (int i = 0; i < slideButtons.size (); i++) {
      Button b = slideButtons.get(i);
      strokeWeight(b.b);
      b.displayPoint();
    }
    strokeWeight(1f);
  }
}

void checkSlideButtons(boolean _d) {
  if (_d) {
    for (int i = 0; i < slideButtons.size (); i++) {
      Button b = slideButtons.get(i);
      b.rollOver();
      //println(i + " - " + b.over + " - " + _d);
    }
  }
}

void growSlideButtons(boolean _d) {
  if (_d) {
    for (int i = 0; i < slideButtons.size (); i++) {
      Button b = slideButtons.get(i);
      b.grow();
    }
  }
}

