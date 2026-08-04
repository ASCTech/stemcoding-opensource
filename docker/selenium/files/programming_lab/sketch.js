x = 375;
y = 250;

vx = 0;
vy = 0;

deltaVx = 0;
deltaVy = 0;

theta = 0;

Fthrust = 30.0;
mass = 3.0;
dt = 0.1;

function draw(){
    // Update velocities
    vx += deltaVx;

    // Update location
    x += vx*dt;

    // velocity is unchanged if there are no forces
    deltaVx = 0;

    // Turn or thrust the ship depending on what key is pressed
    if (keyIsDown(LEFT_ARROW)) {
        theta += 0.0;
    }
    if (keyIsDown(RIGHT_ARROW)) {
        theta += 0.0;
    }
    if (keyIsDown(UP_ARROW)) {
        // Rockets on!
        accelx = Fthrust*cos(theta)/mass;
        deltaVx = accelx*dt;
    }
    if (keyIsDown(DOWN_ARROW)) {
            // do nothing
    }
    if (keyIsPressed && key == ' '){ //spacebar
        // Do nothing!
    }
    // Draw ship and other stuff
    // This will clear the screen and re-draw it
    display();
    // Add more graphics here before the end of draw()
  
} // end draw()
