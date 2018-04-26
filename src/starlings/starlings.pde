Flock flock;

float sc = 2; //scaling factor for boid
float h = 1.0; //hue
float FLIGHT_SPEED = 1f;
float MAX_FORCE = 1.0f;
float INFLUENCE = 7;
float INFLUENCE_CIRCLE = 200.0f;
float MIN_SEP = 200.0f;
float RADIUS_OF_CONFINEMENT = 200.0f;

//Hyper parameters
int INIT_FLOCK_SIZE =200;
int FLOCK_SIZE;
float SEPARATION_FACTOR = 2.0f;
float COHESION_FACTOR = 1f;
float ALIGNMENT_FACTOR = 0f;
float AVOIDANCE_FACTOR =0f;
float NOISE_FACTOR = 0.05f;

// Array to hold all the sliders
Slider[] sliders = new Slider[3];

// Define the dimensions of different areas
int simulationWidth = 640;
int simulationHeight = 360;
int slidersWidth = 200;

PGraphics simViewport, sliderViewport;

void setup() {
 size(840, 360,P3D);
 translate(420,180);
 background(200);
 flock = new Flock();
  FLOCK_SIZE = INIT_FLOCK_SIZE;
  for (int i = 0; i < FLOCK_SIZE; i++) {
    flock.addBoid(new Boid());
  }

 // Initialise Sliders
 sliders[0] = new Slider(20, 20, 40, 20, "a");
 sliders[1] = new Slider(80, 20, 40, 20, "b");
 sliders[2] = new Slider(140, 20, 40, 20, "c");

 // Make two view ports
 //simViewport = createGraphics(simulationWidth, simulationHeight, P3D);
 //sliderViewport = createGraphics(slidersWidth, simulationHeight, P2D);

}

void draw() {
 background(200);
 flock.runModel();

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
  for (Slider s:sliders)
    s.run();
  // hint(ENABLE_DEPTH_TEST);

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


// The Flock (a list of Boid objects)

class Flock {
 ArrayList<Boid> boids; // An ArrayList for all the boids

 Flock() {
   boids = new ArrayList<Boid>(); // Initialize the ArrayList
 }

 void runModel() {
    for (Boid b: boids)
      b.applyRules(boids);
      
    for (Boid b: boids)
      b.update();
    
    for (Boid b: boids){
      b.borders();
      b.render();
    }
 }

 void addBoid(Boid b) {
   boids.add(b);
 }

}




class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;

  Boid() {
    acceleration = new PVector(0, 0, 0);
    velocity = PVector.random3D();
    position = PVector.random3D();
    position.mult(random(RADIUS_OF_CONFINEMENT - 10)); // -10 in order to prevent infinite wall avoidance force at init
  }

  void applyRules(ArrayList<Boid> boids){
    float [] distance = new float[FLOCK_SIZE];
    acceleration = new PVector(0, 0, 0);
    
    for (int i =0; i<FLOCK_SIZE ; i++){
      distance[i] = PVector.dist(position, boids.get(i).position);
    }
    PVector temp = new PVector(0,0,0);
    //rule of separation
    for (int i =0; i<FLOCK_SIZE ; i++){
      if (distance[i]>0 && distance[i]<MIN_SEP){
        temp.sub(boids.get(i).position);
        temp.add(position);
        temp.mult(SEPARATION_FACTOR/(distance[i]*distance[i]));
        acceleration.add(temp); 
      }
    }
    
    //rule of alignment and cohesion
    PVector avg_v = new PVector(0,0,0);
    PVector avg_r = new PVector(0,0,0);
    int count =0;
    for (int i= 0; i<FLOCK_SIZE; i++){
     if (distance[i]>0 && distance[i]<INFLUENCE_CIRCLE){
       avg_v.add(boids.get(i).velocity);
       avg_r.add(boids.get(i).position);
       count++;
     }
    }
    avg_v.div(count);
    avg_r.div(count);
    avg_v.sub(velocity);
    avg_r.sub(position);
    avg_v.mult(ALIGNMENT_FACTOR/avg_v.mag());
    avg_r.mult(COHESION_FACTOR/avg_r.mag());
    acceleration.add(avg_v);
    acceleration.add(avg_r);
    
    //rule of wall avoidance
    temp = position;
    //temp.div((position.mag() - RADIUS_OF_CONFINEMENT)/AVOIDANCE_FACTOR);
    //acceleration.add(temp);
    
    //rule of noise
    temp = PVector.random3D();
    temp.mult(NOISE_FACTOR);
    acceleration.add(temp);
    
    
   //normalising acceleration
   if (acceleration.mag()>MAX_FORCE)
     acceleration.mult(MAX_FORCE/acceleration.mag());
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    PVector temp = velocity;
    temp.mult(FLIGHT_SPEED);
    position.add(temp);
  }

  void render() {
    pushMatrix();
    translate(position.x+420,position.y+180);
    rotateY(atan2(-velocity.z,velocity.x));
    rotateZ(asin(velocity.y/velocity.mag()));
    stroke(h);
    noFill();
    noStroke();
    fill(h);
    //draw bird
    beginShape(TRIANGLES);
    vertex(3*sc,0,0);
    vertex(-3*sc,2*sc,0);
    vertex(-3*sc,-2*sc,0);
    
    vertex(3*sc,0,0);
    vertex(-3*sc,2*sc,0);
    vertex(-3*sc,0,2*sc);
    
    vertex(3*sc,0,0);
    vertex(-3*sc,0,2*sc);
    vertex(-3*sc,-2*sc,0);
    
    /* wings
    vertex(2*sc,0,0);
    vertex(-1*sc,0,0);
    vertex(-1*sc,-8*sc,flap);
    
    vertex(2*sc,0,0);
    vertex(-1*sc,0,0);
    vertex(-1*sc,8*sc,flap);
    */
    
    vertex(-3*sc,0,2*sc);
    vertex(-3*sc,2*sc,0);
    vertex(-3*sc,-2*sc,0);
    endShape();
    //box(10);
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -2) position.x = width+2;
    if (position.y < -2) position.y = height+2;
    if (position.x > width+2) position.x = -2;
    if (position.y > height+2) position.y = -2;
  }
}
