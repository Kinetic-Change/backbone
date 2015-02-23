void keyPressed(KeyEvent e) {
  int keyy = e.getKeyCode(); 

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
    println("rot");
  }

  if (key == 'x') {
    exit();
  }

  if (key == 'd') {
    debug =! debug;
  }
  if (key == 'p') {
    saveFrame("shots/####.jpeg");
  }

  if (key==CODED) {
    if (keyy == KeyEvent.VK_RIGHT) {
      whichSlide++;
      whichSlide=whichSlide%maxSlides;
      println("Slide "+whichSlide);
      setNextValue(whichSlide);
    }

    if (keyy == KeyEvent.VK_LEFT) {
      whichSlide--;
      if (whichSlide<0) {
        whichSlide=maxSlides-1;
      }
      println("Slide " +whichSlide);
      setNextValue(whichSlide);
    }


    if (keyy == KeyEvent.VK_PAGE_DOWN) {  // left-arrow key; move square up
      whichSlide++;
      whichSlide=whichSlide%maxSlides;
      println("next slide via remote");
      println("Slide "+whichSlide);
      setNextValue(whichSlide);
    }

    if (keyy == KeyEvent.VK_PAGE_UP) {  // left-arrow key; move square up
      whichSlide--;
      if (whichSlide<0) {
        whichSlide=maxSlides-1;
      }
      println("Slide " +whichSlide);
      println("prev slide via remote");
      setNextValue(whichSlide);
    }
  }
}

