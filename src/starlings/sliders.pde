
// Slider class
class Slider {
  // class vars
  float x;
  float y;
  float w, h;
  float initialY;
  boolean lock = false;
  String label = "";

  // Constructors
  Slider () {

  }

  Slider (float _x, float _y, float _w, float _h, String _label) {
    x = _x + simulationWidth;
    y = _y;
    initialY = y;
    w = _w;
    h = _h;
    label = _label;
  }

  void run() {
 
    // bad practice have all stuff done in one method...
    float lowerY = height - h - initialY;
 
    // map value to change color..
    float value = map(y, initialY, lowerY, 120, 255);
 
    // map value to display
    float value2 = map(value, 120, 255, 100, 0);
 
    //set color as it changes
    color c = color(value);
    fill(c);
 
    // draw base line
    rect(x, initialY, 4, lowerY);
 
    // draw knob
    fill(200);
    rect(x, y, w, h);
 
    // display text
    fill(0);
    text(int(value2) +"%", x+5, y+15);

    text(label, x+5, lowerY + 15);
 
    //get mouseInput and map it
    float my = constrain(mouseY, initialY, height - h - initialY );
    if (lock) y = my;
  }
 
  // is mouse ove knob?
  boolean isOver()
  {
    return (x+w >= mouseX) && (mouseX >= x) && (y+h >= mouseY) && (mouseY >= y);
  }
}
