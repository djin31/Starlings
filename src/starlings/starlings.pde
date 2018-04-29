Flock flock;

float SCALE = 1.5; //scaling factor for boid
float FLIGHT_SPEED = 1.2f;
float MAX_FORCE = 0.2f;
float INFLUENCE = 7;
float INFLUENCE_CIRCLE = 100.0f;
float MIN_SEP = 50.0f;
float RADIUS_OF_CONFINEMENT = 350.0f;

//Hyper parameters
int INIT_FLOCK_SIZE =300;
int FLOCK_SIZE;
float SEPARATION_FACTOR;
float COHESION_FACTOR;
float ALIGNMENT_FACTOR;
float AVOIDANCE_FACTOR;
float NOISE_FACTOR;

color top,bottom;
// Array to hold all the sliders
Slider[] sliders = new Slider[5];

// Buttons
Button addBoidButton;

// Define the dimensions of different areas
int simulationWidth = 640;
int simulationHeight = 360;
int slidersWidth = 360;

PGraphics simViewport, sliderViewport;

void setup() {
 size(1400, 860,P3D);
 translate(420,180);
 top = color(153,255,255);
 bottom = color(175,238,238);
 flock = new Flock();
 for (int i = 0; i < INIT_FLOCK_SIZE; i++) {
    flock.addBoid(new Boid());
  }

 // Initialise Sliders
 sliders[0] = new Slider(20, 20, 40, 20, "Seperation", 1.0f, 5.0f, 3.0f);
 sliders[1] = new Slider(90, 20, 40, 20, "Cohesion", 0.0f, 2.0f, 0.293f);
 sliders[2] = new Slider(160, 20, 40, 20, "Alignment", 0.0f, 0.5f, 0.02f);
 sliders[3] = new Slider(230, 20, 40, 20, "Avoidance", 0.0f, 1.0f, 0.05f);
 sliders[4] = new Slider(300, 20, 40, 20, "Noise",0.0f, 0.5f, 0.05f);

  // Add button for adding bird
  addBoidButton = new Button (150, 100, 50, 20);
}

void draw() {
 background(bottom);
 flock.runModel();

  // Run the sliders and update parameters
  SEPARATION_FACTOR = sliders[0].run();
  COHESION_FACTOR = sliders[1].run();
  ALIGNMENT_FACTOR = sliders[2].run();
  AVOIDANCE_FACTOR = sliders[3].run();
  NOISE_FACTOR = sliders[4].run();

  // Draw the buttons
  addBoidButton.draw();

  // Print the Measurements each 100th frame for less computation
  if (frameCount % 100 == 0) {
    println(flock.size(),
        flock.getAverageVelocity(),
        flock.getAverageAcceleration(),
        flock.avgDispersionFromCOM(),
        flock.totalPower(),
        flock.avgPower(),
        flock.avgAngMomentum()
        );
  }
}

// Add a new boid into the System
void mousePressed() {
 if (addBoidButton.isOver()) {
   // The button is clicked
   flock.addBoid(new Boid());
 }
 

 // lock slider if clicked
 for (Slider s:sliders)
 {
   if (s.isOver())
    s.lock = true;
 }
}

void mouseReleased() {
  // unlock the slider
  for (Slider s:sliders)
  {
    s.lock = false;
  }
}

void setGradient(color c1, color c2 ) {

  noFill();

  for (int i = 0; i <= height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(0, i, width, i);
  }
}
