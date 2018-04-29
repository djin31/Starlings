// The Flock (a list of Boid objects)

class Flock {
 ArrayList<Boid> boids; // An ArrayList for all the boids
 PVector CoM;
 PVector oldCoM;

 Flock() {
   boids = new ArrayList<Boid>(); // Initialize the ArrayList
   CoM = new PVector(0,0,0);
   FLOCK_SIZE=0;
 }

 void runModel() {
    for (Boid b: boids)
      b.applyRules(boids);

    for (Boid b: boids){
      b.update();
      CoM.add(b.position);
    }

    CoM.div(FLOCK_SIZE);
    
    for (Boid b: boids){
      b.render();
    }
 }

 void addBoid(Boid b) {
   boids.add(b);
   FLOCK_SIZE++;
 }

 int size () {
   // return number of boids
   return boids.size();
 }

 // Results / Calculations
 float getAverageVelocity () {
   // return average of magnitudes of velocities of boids
   float avgVelocity = 0;
   for (Boid b:boids) {
    //  if (Float.isNaN(b.velocity.mag())) continue;
     avgVelocity += (b.velocity).mag();
   }

   return avgVelocity / FLOCK_SIZE;
 }

 float getAverageAcceleration () {
   // return avg of mag of acc
   float avgAcceleration = 0;
   for (Boid b:boids) {
     avgAcceleration += b.acceleration.mag();
   }

   return avgAcceleration / FLOCK_SIZE;
 }

 float avgDispersionFromCOM () {
   // returns avg of displacement mag from COM
   float avgDispersion = 0;
   for (Boid b:boids) {
     PVector tmp = new PVector (b.position.x, b.position.y, b.position.z);
     avgDispersion += (tmp.sub(CoM)).mag();
   }

   return avgDispersion;
 }

  float totalPower () {
    // return total power being consumed by the flock
    // P = F.v
    float totPower = 0;
    for (Boid b:boids) {
      totPower += b.acceleration.dot(b.velocity);
    }

    return totPower;
  }

  float avgPower () {
    // return average power per unit mass of all boids
    // P = F.v

    return this.totalPower() / FLOCK_SIZE;
  }

  float avgAngMomentum () {
    // return average ang momentum per unit mass
    // L = m . r * v
    float avgAngMomentum = 0;
    for (Boid b:boids) {
      avgAngMomentum += (b.position.cross(b.velocity)).mag();
    }

    return avgAngMomentum / FLOCK_SIZE;
  }
}
