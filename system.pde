/* How to set up your System class which the recorder calls.
 * It's dead simple - it just needs a 'step' method.
 * I'm sure you can think of something more creative than this ;)
 */

class System {
  float rectX;

  System() {
    background(255);
    rectX = 0;
    // other initialization stuff here, for example
    // randomSeed(seed), spawn some objects, etc.
  }

  // the only function required of the System class, called by recorder.pde
  void step() {
    // draw
    background(255);
    fill(120);
    noStroke();
    rect(rectX, height/3, width/3, height/3);
    
    // update
    rectX = (rectX + 4) % width;
  }

}