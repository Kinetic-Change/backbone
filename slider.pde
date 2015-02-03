

class Slider extends PVector {
  int id, l;
  String dir = "h", func = "---";
  boolean over, locked, dragged;
  float xp, yp;
  float s;

  Slider(PVector _p, int _id, String _dir, int _l) {
    super(_p.x, _p.y);
    this.id = id;
    this.l = _l;
    this.dir = _dir;
    if (_dir != "h") this.dir = "v";
  }

  void update() {
    if (over) {
      // if (over) {
      locked = true;
    } else {
      locked = false;
    }
  }

  void display() {
    if (dir == "h") {
      beginShape(LINES);
      vertex(x, y);
      vertex(x+l, y);
      endShape();
    } else {
      beginShape(LINES);
      vertex(x, y);
      vertex(x, y+l);
      endShape();
    }
  }

  void release() {
    locked=false;
  }
}

