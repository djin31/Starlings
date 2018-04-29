// The Flock (a list of Boid objects)

class Flock {
 ArrayList<Boid> boids; // An ArrayList for all the boids
 PVector CoM;
 PVector oldCoM;

 Flock() {
   boids = new ArrayList<Boid>(); // Initialize the ArrayList
   CoM = new PVector(0,0,0);
 }

 void runModel() {
    for (Boid b: boids)
      b.applyRules(boids);

    for (Boid b: boids){
      b.update();
      CoM.add(b.position);
    }
    
    
    
    for (Boid b: boids){
      //b.borders();
      b.render();
    }
 }

 void addBoid(Boid b) {
   boids.add(b);
 }

 int size () {
   // return number of boids
   return boids.size();
 }

}
