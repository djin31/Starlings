class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;

  Boid() {
    acceleration = new PVector(0, 0, 0);
    velocity = PVector.random3D();
    position = PVector.random3D();
    position.mult(random(RADIUS_OF_CONFINEMENT));
    
  }

  void applyRules(ArrayList<Boid> boids){
    
    acceleration = new PVector(0, 0, 0);
    
    //compute distance array for the boids
    float [] distance = new float[FLOCK_SIZE];
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
       if (distance[i]<(INFLUENCE_CIRCLE*0.75))
       avg_v.add(boids.get(i).velocity);
       avg_r.add(boids.get(i).position);
       count++;
     }
    }
    avg_v.div(count);
    avg_r.div(count);
    avg_v.sub(velocity);
    avg_r.sub(position);
    if (avg_v.mag()>0 && avg_r.mag()>0){
      avg_v.mult(ALIGNMENT_FACTOR/avg_v.mag());
      avg_r.mult(COHESION_FACTOR/avg_r.mag());
      acceleration.add(avg_v);
      acceleration.add(avg_r);
    }  
    //rule of wall avoidance pushed to update module
    
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
    
    if (position.mag()>RADIUS_OF_CONFINEMENT){    //implements wall avoidance
      PVector temp = new PVector(position.x,position.y,position.z);
      temp.normalize();
      temp.mult(AVOIDANCE_FACTOR);
      velocity.sub(temp);
    }
    else
      velocity.add(acceleration);
    if (velocity.mag()>0)
      velocity.normalize();
    PVector temp = velocity;
    temp.mult(FLIGHT_SPEED);
    
    //update position
    position.add(temp);          
    
  }

  void render() {
    
    pushMatrix();
    translate(position.x+width/3,position.y+height/2);
    rotateY(atan2(-velocity.z,velocity.x));
    rotateZ(asin(velocity.y/velocity.mag()));
    noStroke();
    fill(25,25,112);
    
    //draw bird
    float flap = pow(-1,frameCount/100)/2;
    beginShape(TRIANGLES);
    
    vertex(3*SCALE,0,0);
    vertex(-3*SCALE,2.5*SCALE,0);
    vertex(-3*SCALE,-2.5*SCALE,0);

    vertex(3*SCALE,0,0);
    vertex(-3*SCALE,2.5*SCALE,0);
    vertex(-3*SCALE,0,2.5*SCALE);

    vertex(3*SCALE,0,0);
    vertex(-3*SCALE,0,2.5*SCALE);
    vertex(-3*SCALE,-2.5*SCALE,0);

    // wings
    vertex(2*SCALE, 0, 0);
    vertex(-1*SCALE, 0, 0);
    vertex(-1*SCALE, -8*SCALE, flap);

    vertex(2*SCALE, 0, 0);
    vertex(-1*SCALE, 0, 0);
    vertex(-1*SCALE, 8*SCALE, flap);


    vertex(-3*SCALE, 0, 2.5*SCALE);
    vertex(-3*SCALE, 2.5*SCALE, 0);
    vertex(-3*SCALE, -2.5*SCALE, 0);
    endShape();
    //box(10);
    popMatrix();
  }

  
}
