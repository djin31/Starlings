const Height = 400,
    Width = 600;

var flock;

function setup() {
    var simCanvas = createCanvas(Width, Height, WEBGL);
    simCanvas.parent('simulation');
    
    flock = new Flock();

}

function draw() {
    background(50); // Background of rgb (50, 50, 50)
    flock.run();
}

// The Flock Object
function Flock()
{
    // An array of all boids
    this.boids = [];
}

Flock.prototype.run = function()
{
    // Run
}

Flock.prototype.addBoid = function (b) {
    this.boids.push(b);
}


// The Boid Object
function Boid(x, y, z) {
    this.position = createVector (x, y, z);
    this.direction = createVector (0, 0, 0);
}

Boid.prototype.render = function ()
{
    // Draw a shpere rotated in Boid.direction
    fill(127);
    normalMaterial();
    push();
    translate(this.position.x, this.position.y, this.position.z);
    sphere(20);
    pop();
}