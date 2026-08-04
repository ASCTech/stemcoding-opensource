var x = 0;
var y = 0;

var vx = 0;
var vy = 0;

var deltaVx = 0;
var deltaVy = 0;

var theta = 0;

var Fthrust = 30.0;
var mass = 3.0;
var dt = 0.1;

function setup(){
  createCanvas(750, 500);
  x = width/2;
  y = height/2;
}

function draw(){
  // Update velocities
  vx += deltaVx;
  vy += deltaVy;

  // Update location
  x += vx*dt;
  y += vy*dt;

  // Set deltaV to zero (thrust off unless user turns it on)
  deltaVx = 0;
  deltaVy = 0;

  // Turn or thrust the ship depending on what key is pressed
  if (keyIsPressed) {
    if (keyCode == LEFT_ARROW) {
      theta += 0.05;
    } else if (keyCode == RIGHT_ARROW) {
      theta -= 0.05;
    } else if ( keyCode == UP_ARROW ) {
      // Rockets on!
      var accelx = Fthrust*cos(theta)/mass;
      var accely = Fthrust*sin(theta)/mass;
      deltaVx = accelx*dt;
      deltaVy = accely*dt;
    } else if ( keyCode == DOWN_ARROW ) {
      var accelx = -Fthrust*cos(theta)/mass;
      var accely = -Fthrust*sin(theta)/mass;
      deltaVx = accelx*dt;
      deltaVy = accely*dt;
    }
  }

  // Draw ship and other stuff
  // This will clear the screen and re-draw it
  display();

  // Add more graphics here before the end of draw()

} // end draw()
