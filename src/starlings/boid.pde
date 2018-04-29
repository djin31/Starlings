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
     if (distance[i]>0 && distance[i]<INFLUENCE_CIRCLE && count<INFLUENCE){
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
    //temp.mult(exp(position.mag()-RAD)*AVOIDANCE_FACTOR);
    //acceleration.sub(temp);
    
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
    if (position.mag()>RADIUS_OF_CONFINEMENT)
      PVector.mult(position,-1,velocity);
    else
      velocity.add(acceleration);
    velocity.normalize();
    PVector temp = velocity;
    temp.mult(FLIGHT_SPEED);
    position.add(temp);
    
  }

  void render() {
    pushMatrix();
    translate(position.x+400,position.y+100);
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
