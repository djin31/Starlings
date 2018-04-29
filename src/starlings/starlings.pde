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
float SEPARATION_FACTOR = 2.0f;
float COHESION_FACTOR = 1f;
float ALIGNMENT_FACTOR = 0.1f;
float AVOIDANCE_FACTOR =0f;
float NOISE_FACTOR = 0.05f;

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
 size(1000, 560,P3D);
 translate(420,180);
 background(200);
 flock = new Flock();
  FLOCK_SIZE = INIT_FLOCK_SIZE;
  for (int i = 0; i < FLOCK_SIZE; i++) {
    flock.addBoid(new Boid());
  }

 // Initialise Sliders
 sliders[0] = new Slider(20, 20, 40, 20, "Seperation", 1.0f, 5.0f, 3.0f);
 sliders[1] = new Slider(90, 20, 40, 20, "Cohesion", 0.0f, 2.0f, 0.293f);
 sliders[2] = new Slider(160, 20, 40, 20, "Alignment", 0.0f, 0.5f, 0.05f);
 sliders[3] = new Slider(230, 20, 40, 20, "Avoidance", 0.0f, 1.0f, 0.05f);
 sliders[4] = new Slider(300, 20, 40, 20, "Noise",0.0f, 0.5f, 0.05f);

  // Add button for adding bird
  addBoidButton = new Button (150, 100, 50, 20);
}

void draw() {
 background(175,238,238);
 flock.runModel();

  // Run the sliders and update parameters
  SEPARATION_FACTOR = sliders[0].run();
  COHESION_FACTOR = sliders[1].run();
  ALIGNMENT_FACTOR = sliders[2].run();
  AVOIDANCE_FACTOR = sliders[3].run();
  NOISE_FACTOR = sliders[4].run();

  // Draw the buttons
  addBoidButton.draw();
}

// Add a new boid into the System
void mousePressed() {
 if (addBoidButton.isOver()) {
   // The button is clicked
   flock.addBoid(new Boid());

   println(flock.size());
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
