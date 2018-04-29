
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
  float value, mapVal;
  color highColor = color (25,25,112), lowColor = color(175,238,238);

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
 
    // map value to 1 to 100..
    mapVal = map(y, initialY, lowerY, 0, 100);
 
    // map value to display
    value = map(mapVal, 0, 100, high, low);

    // println(red(lowColor));
    // Find the corresponding color
    float red = map(mapVal, 0, 100, red(lowColor), red(highColor));
    float green = map(mapVal, 0, 100, green(lowColor), green(highColor));
    float blue = map(mapVal, 0, 100, blue(lowColor), blue(highColor));

    //set color as it changes
    color c = color (red, green, blue);
    fill(c);
 
    // draw base line
    rect(x, initialY, 4, lowerY);
 
    // draw knob
    fill(153,255,255);
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
