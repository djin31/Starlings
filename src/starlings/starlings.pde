Flock flock;

float SCALE = 1.2; //scaling factor for boid
float FLIGHT_SPEED = 1.0f;  //for rendering
float MAX_FORCE = 0.2f;
float INFLUENCE = 7;
float INFLUENCE_CIRCLE = 80.0f;
float MIN_SEP = 50.0f;
float RADIUS_OF_CONFINEMENT = 300.0f;
//Hyper parameters
int INIT_FLOCK_SIZE = 300;
int FLOCK_SIZE;
float SEPARATION_FACTOR;
float COHESION_FACTOR;
float ALIGNMENT_FACTOR;
float AVOIDANCE_FACTOR;
float NOISE_FACTOR;

color top, bottom;
color up, down; // color of up down key symbols
// Array to hold all the sliders
Slider[] sliders = new Slider[5];

// Buttons
Button addBoidButton;

// Define the dimensions of different areas
int simulationWidth = 640;
int simulationHeight = 360;
int slidersWidth = 360;

// Measurements
float averageVelocity;
float averageAcceleration;
float avgDispersionFromCOM;
float totalPower;
float avgPower;
float avgAngMomentum;

void setup() {
  size(1000, 600, P3D);
  //  surface.setResizable(true); // Allow user to resize the window

  translate(420, 180);
  top = color(153, 255, 255);
  bottom = color(175, 238, 238);
  flock = new Flock();
  for (int i = 0; i < INIT_FLOCK_SIZE; i++) {
    flock.addBoid(new Boid());
  }

  // Initialise Sliders
  sliders[0] = new Slider(20, 20, 40, 20, "Seperation", 1.0f, 5.0f, 3.0f);
  sliders[1] = new Slider(90, 20, 40, 20, "Cohesion", 0.0f, 2.0f, 0.2f);
  sliders[2] = new Slider(160, 20, 40, 20, "Alignment", 0.0f, 0.5f, 0.02f);
  sliders[3] = new Slider(230, 20, 40, 20, "Avoidance", 0.0f, 1.0f, 0.05f);
  sliders[4] = new Slider(300, 20, 40, 20, "Noise", 0.0f, 0.5f, 0.05f);

  // Add button for adding bird
  addBoidButton = new Button (simulationWidth + 40, height / 2 + 200, 200, 35, "Add Boid");
}

void draw() {
  background(bottom);
  flock.runModel();

  // Run the sliders and update parameters
  SEPARATION_FACTOR = sliders[0].run() + random(0.5) ;
  COHESION_FACTOR = sliders[1].run() + random(0.1);
  ALIGNMENT_FACTOR = sliders[2].run() + random(0.005);
  AVOIDANCE_FACTOR = sliders[3].run();
  NOISE_FACTOR = sliders[4].run();

  // Draw the buttons
  addBoidButton.draw();

  // Draw the up-down button
  drawUpDownKeys();

  // Print the Measurements each 20th frame for less computation
  if (frameCount % 20 == 0) {
    updateMesurements();
  }

  // Display the current measurements
  displayMesurements();

  // Update the color every 5th frame
  if (frameCount % 5 == 0) {
    up = down = color(#006400);
  }
}

// Add a new boid into the System
void mousePressed() {
  if (addBoidButton.isOver()) {
    // The button is clicked
    flock.addBoid(new Boid());
  }


  // lock slider if clicked
  for (Slider s : sliders)
  {
    if (s.isOver())
      s.lock = true;
  }
}

void mouseReleased() {
  // unlock the slider
  for (Slider s : sliders)
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

// Key Handler
void keyPressed () {
  if (key == CODED) {
    if (keyCode == UP) {
      up = color (#32CD32);
      FLIGHT_SPEED += 0.1;
    } else if (keyCode == DOWN) {
      if (FLIGHT_SPEED > 0.3) { // A minimum speed
        FLIGHT_SPEED -= 0.1;
        down = color (#32CD32);
      }
    }
  }
}

void drawUpDownKeys () {
  fill(up);
  rect(simulationWidth + 120, height / 2 + 250, 50, 20);
  fill(down);
  rect(simulationWidth + 120, height / 2 + 275, 50, 20);

  fill(250, 250, 250);
  text("Up", simulationWidth + 137, height / 2 + 265);
  text("Down", simulationWidth + 130, height / 2 + 290);
}

void updateMesurements () {

  averageVelocity = flock.getAverageVelocity();    
  averageAcceleration = flock.getAverageAcceleration();
  avgDispersionFromCOM = flock.avgDispersionFromCOM();
  totalPower = flock.totalPower();
  avgPower = flock.avgPower();
  avgAngMomentum = flock.avgAngMomentum();
}

void displayMesurements () {
  // Displays various results of calculations at appropriate places

  color name = color (#26466D);//#26466D	
  color value = color (#1874CD);

  textSize(17);

  // print the labels
  fill(name);
  text("Number of Birds:", simulationWidth, height / 2 + 40);
  text("Flight Speed:", simulationWidth, height / 2 + 60);
  text("Average Acceleration:", simulationWidth, height / 2 + 80);
  text("Average Power:", simulationWidth, height / 2 + 100);
  //text("Total Power:", simulationWidth, height / 2 + 120);
  text("Average Angular Momentum:", simulationWidth, height / 2 + 120);
  text("Average Dispersion:", simulationWidth, height / 2 + 140);

  // print the values
  fill(value);
  text(FLOCK_SIZE, simulationWidth + 240, height / 2 + 40);
  text(averageVelocity, simulationWidth + 240, height / 2 + 60);
  text(averageAcceleration, simulationWidth + 240, height / 2 + 80);
  text(avgPower, simulationWidth + 240, height / 2 + 100);
  //text(totalPower, simulationWidth + 240, height / 2 + 120);
  text(avgAngMomentum, simulationWidth + 240, height / 2 + 120);
  text(avgDispersionFromCOM, simulationWidth + 240, height / 2 + 140);

  // reset the text size
  textSize(12);
}
