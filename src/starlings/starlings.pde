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
    position = new PVector(random(RADIUS_OF_CONFINEMENT/3),random(RADIUS_OF_CONFINEMENT/3),random(RADIUS_OF_CONFINEMENT/3));
    //position.mult(random(RADIUS_OF_CONFINEMENT - 10)); // -10 in order to prevent infinite wall avoidance force at init
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
   // temp.div(min((position.mag() - RADIUS_OF_CONFINEMENT),100)/AVOIDANCE_FACTOR);
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
    translate(position.x,position.y);
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
