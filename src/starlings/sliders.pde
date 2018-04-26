
// Slider class
class Slider {
  // class vars
  float x;
  float y;
  float w, h;
  float initialY;
  boolean lock = false;
  String label = "";

  // Range parameters
  float low, high, lowerY;

  // Value of the slider
  float value, colorVal;

  // Constructors
  Slider () {

  }

  Slider (float _x, float _y, float _w, float _h, String _label, float _low, float _high, float _initial) {
    x = _x + simulationWidth;
    y = _y;
    initialY = y;
    w = _w;
    h = _h;
    label = _label;

    low = _low;
    high = _high;
    value = _initial;

    lowerY = height - h - initialY;
    y = map(_initial, _low, _high, lowerY, initialY);
  }

  float run() {
 
    // map value to change color..
    colorVal = map(y, initialY, lowerY, 120, 255);
 
    // map value to display
    value = map(colorVal, 120, 255, high, low);
 
    //set color as it changes
    color c = color(colorVal);
    fill(c);
 
    // draw base line
    rect(x, initialY, 4, lowerY);
 
    // draw knob
    fill(200);
    rect(x, y, w, h);
 
    // display text
    fill(0);
    text(value, x+5, y+15);

    text(label, x-5, lowerY + 35);
 
    //get mouseInput and map it
    float my = constrain(mouseY, initialY, height - h - initialY );
    if (lock) y = my;

    // Return the value
    return value;
  }
 
  // is mouse ove knob?
  boolean isOver()
  {
    return (x+w >= mouseX) && (mouseX >= x) && (y+h >= mouseY) && (mouseY >= y);
  }
}
