Flock flock;

float sc = 2; //scaling factor for boid
float h = 1.0; //hue
float FLIGHT_SPEED = 1f;
float MAX_FORCE = 1.0f;
float INFLUENCE = 7;
float INFLUENCE_CIRCLE = 300.0f;
float MIN_SEP = 30.0f;
float RADIUS_OF_CONFINEMENT = 400.0f;

//Hyper parameters
int INIT_FLOCK_SIZE =200;
int FLOCK_SIZE;
float SEPARATION_FACTOR = 2.0f;
float COHESION_FACTOR = 1f;
float ALIGNMENT_FACTOR = 0.1f;
float AVOIDANCE_FACTOR =0f;
float NOISE_FACTOR = 0.05f;

// Array to hold all the sliders
Slider[] sliders = new Slider[5];

// Define the dimensions of different areas
int simulationWidth = 640;
int simulationHeight = 360;
int slidersWidth = 360;

PGraphics simViewport, sliderViewport;

void setup() {
 size(1000, 360,P3D);
 translate(420,180);
 background(200);
 flock = new Flock();
  FLOCK_SIZE = INIT_FLOCK_SIZE;
  for (int i = 0; i < FLOCK_SIZE; i++) {
    flock.addBoid(new Boid());
  }

 // Initialise Sliders
 sliders[0] = new Slider(20, 20, 40, 20, "Seperation", 0.0f, 4.0f, 3.0f);
 sliders[1] = new Slider(90, 20, 40, 20, "Cohesion", 0.0f, 2.0f, 0.1f);
 sliders[2] = new Slider(160, 20, 40, 20, "Alignment", 0.0f, 1.0f, 0.0f);
 sliders[3] = new Slider(230, 20, 40, 20, "Avoidance", 0.0f, 1.0f, 0.05f);
 sliders[4] = new Slider(300, 20, 40, 20, "Noise",0.0f, 0.5f, 0.05f);

 // Make two view ports
 //simViewport = createGraphics(simulationWidth, simulationHeight, P3D);
 //sliderViewport = createGraphics(slidersWidth, simulationHeight, P2D);

}

void draw() {
 background(200);
 flock.runModel();
 //translate(flock.CoM.x-flock.oldCoM.x,flock.CoM.y-flock.oldCoM.y);

 /*simViewport.rotateZ(frameCount * 0.01);
 simViewport.rotateX(frameCount * 0.01);
 simViewport.rotateY(frameCount * 0.01);*/
 //rotateX(frameCount * 0.01);
  
  // simViewport.rectMode(CENTER);
  // simViewport.fill(51);
  // simViewport.stroke(255);
  // simViewport.rect(0,0,100,100);
  // Call Sliders
  // hint(DISABLE_DEPTH_TEST); // disable 3D
  // for (Slider s:sliders)
    // s.run();
  // hint(ENABLE_DEPTH_TEST);

  // Run the sliders and update parameters
  SEPARATION_FACTOR = sliders[0].run();
  COHESION_FACTOR = sliders[1].run();
  ALIGNMENT_FACTOR = sliders[2].run();
  AVOIDANCE_FACTOR = sliders[3].run();
  NOISE_FACTOR = sliders[4].run();

  //image(simViewport, 0, 0);
  //image(sliderViewport, simulationWidth, 0);
}

// Add a new boid into the System
void mousePressed() {
 flock.addBoid(new Boid());

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
