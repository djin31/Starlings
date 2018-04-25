Flock flock;

// Array to hold all the sliders
Slider[] sliders = new Slider[3];

// Define the dimensions of different areas
int simulationWidth = 640;
int simulationHeight = 360;
int slidersWidth = 200;

void setup() {
 size(840, 360,P3D);
 translate(width/2,height/2);
 rotateZ(2.0);
 flock = new Flock();
 // Add an initial set of boids into the system
 for (int i = 0; i < 200; i++) {
   flock.addBoid(new Boid(random(width),random(height),random(100)));
 }

 // Initialise Sliders
 sliders[0] = new Slider(20, 20, 40, 20, "a");
 sliders[1] = new Slider(80, 20, 40, 20, "b");
 sliders[2] = new Slider(140, 20, 40, 20, "c");

}

void draw() {
 background(200);
 flock.run();
  
  // Call Sliders
  for (Slider s:sliders)
    s.run();
}

// Add a new boid into the System
void mousePressed() {
 flock.addBoid(new Boid(mouseX,mouseY,0));

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

 void run() {
   for (Boid b : boids) {
     b.run(boids);  // Passing the entire list of boids to each boid individually
   }
 }

 void addBoid(Boid b) {
   boids.add(b);
 }

}




// The Boid class

class Boid {

 PVector position;
 PVector velocity;
 PVector acceleration;
 float r;
 float maxforce;    // Maximum steering force
 float maxspeed;    // Maximum speed

   Boid(float x, float y, float z) {
   acceleration = new PVector(0, 0, 0);

   // This is a new PVector method not yet implemented in JS
   // velocity = PVector.random2D();

   // Leaving the code temporarily this way so that this example runs in JS
   float angle = random(TWO_PI);
   velocity = new PVector(cos(angle), sin(angle),0);

   position = new PVector(x, y,z);
   r = 2.0;
   maxspeed = 2;
   maxforce = 0.03;
 }

 void run(ArrayList<Boid> boids) {
   flock(boids);
   update();
   borders();
   render();
 }

 void applyForce(PVector force) {
   // We could add mass here if we want A = F / M
   acceleration.add(force);
 }

 // We accumulate a new acceleration each time based on three rules
 void flock(ArrayList<Boid> boids) {
   PVector sep = separate(boids);   // Separation
   PVector ali = align(boids);      // Alignment
   PVector coh = cohesion(boids);   // Cohesion
   // Arbitrarily weight these forces
   sep.mult(1.5);
   ali.mult(1.0);
   coh.mult(1.0);
   // Add the force vectors to acceleration
   applyForce(sep);
   applyForce(ali);
   applyForce(coh);
 }

 // Method to update position
 void update() {
   // Update velocity
   velocity.add(acceleration);
   // Limit speed
   velocity.limit(maxspeed);
   position.add(velocity);
   // Reset accelertion to 0 each cycle
   acceleration.mult(0);
 }

 // A method that calculates and applies a steering force towards a target
 // STEER = DESIRED MINUS VELOCITY
 PVector seek(PVector target) {
   PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
   // Scale to maximum speed
   desired.normalize();
   desired.mult(maxspeed);

   // Above two lines of code below could be condensed with new PVector setMag() method
   // Not using this method until Processing.js catches up
   // desired.setMag(maxspeed);

   // Steering = Desired minus Velocity
   PVector steer = PVector.sub(desired, velocity);
   steer.limit(maxforce);  // Limit to maximum steering force
   return steer;
 }

 void render() {
   // Draw a triangle rotated in the direction of velocity
   float theta = velocity.heading2D() + radians(90);
   // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
   fill(200, 100);
   stroke(255);
   pushMatrix();
   translate(position.x, position.y);
   rotate(theta);
   beginShape(TRIANGLES);
   vertex(0, -r*2);
   vertex(-r, r*2);
   vertex(r, r*2);
   endShape();
   popMatrix();
 }

 // Wraparound
 void borders() {
   if (position.x < -r) position.x = simulationWidth+r;
   if (position.y < -r) position.y = height+r;
   if (position.x > simulationWidth +r) position.x = -r;
   if (position.y > height+r) position.y = -r;
 }

 // Separation
 // Method checks for nearby boids and steers away
 PVector separate (ArrayList<Boid> boids) {
   float desiredseparation = 25.0f;
   PVector steer = new PVector(0, 0, 0);
   int count = 0;
   // For every boid in the system, check if it's too close
   for (Boid other : boids) {
     float d = PVector.dist(position, other.position);
     // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
     if ((d > 0) && (d < desiredseparation)) {
       // Calculate vector pointing away from neighbor
       PVector diff = PVector.sub(position, other.position);
       diff.normalize();
       diff.div(d);        // Weight by distance
       steer.add(diff);
       count++;            // Keep track of how many
     }
   }
   // Average -- divide by how many
   if (count > 0) {
     steer.div((float)count);
   }

   // As long as the vector is greater than 0
   if (steer.mag() > 0) {
     // First two lines of code below could be condensed with new PVector setMag() method
     // Not using this method until Processing.js catches up
     // steer.setMag(maxspeed);

     // Implement Reynolds: Steering = Desired - Velocity
     steer.normalize();
     steer.mult(maxspeed);
     steer.sub(velocity);
     steer.limit(maxforce);
   }
   return steer;
 }

 // Alignment
 // For every nearby boid in the system, calculate the average velocity
 PVector align (ArrayList<Boid> boids) {
   float neighbordist = 50;
   PVector sum = new PVector(0, 0);
   int count = 0;
   for (Boid other : boids) {
     float d = PVector.dist(position, other.position);
     if ((d > 0) && (d < neighbordist)) {
       sum.add(other.velocity);
       count++;
     }
   }
   if (count > 0) {
     sum.div((float)count);
     // First two lines of code below could be condensed with new PVector setMag() method
     // Not using this method until Processing.js catches up
     // sum.setMag(maxspeed);

     // Implement Reynolds: Steering = Desired - Velocity
     sum.normalize();
     sum.mult(maxspeed);
     PVector steer = PVector.sub(sum, velocity);
     steer.limit(maxforce);
     return steer;
   } 
   else {
     return new PVector(0, 0);
   }
 }

 // Cohesion
 // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
 PVector cohesion (ArrayList<Boid> boids) {
   float neighbordist = 50;
   PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
   int count = 0;
   for (Boid other : boids) {
     float d = PVector.dist(position, other.position);
     if ((d > 0) && (d < neighbordist)) {
       sum.add(other.position); // Add position
       count++;
     }
   }
   if (count > 0) {
     sum.div(count);
     return seek(sum);  // Steer towards the position
   } 
   else {
     return new PVector(0, 0);
   }
 }
}
