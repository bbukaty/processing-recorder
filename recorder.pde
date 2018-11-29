/* Put your code in system.pde (along with any additional helper files)
 * and this sketch will record the output as a series of frames
 * or a single output frame depending on your specifications in the
 * constants below.
 */

import processing.svg.*;

boolean SAVE_OUTPUT = false; // save at the end of the process
boolean SAVE_VIDEO = true; // save after every frame of the process
int NUM_STEPS = 200;
int FILENAME_DIGITS = ceil(log(NUM_STEPS + 1) / log(10));

String OUTPUT_TYPE = "tif"; // supported: svg, tif, png
int RASTER_SCALE = 1; // scale factor for the resolution of saved tif and png files.

System system;
String outputPath;

String timestamp() {
  return str(month()) + "-"  +
  str(day()) + "_" +
  str(hour()) + "-" +
  str(minute()) + "-" +
  str(second()) + "-" + 
  str(millis());
}

// if you're on frame 14 out of 1000, this gives you '0014'.
// used for file naming so that processing's movie maker tool works with our outputs.
String padIndex(int index) {
  int numDigits = ceil(log(index + 1) / log(10));
  String result = "";
  for (int i = 0; i < FILENAME_DIGITS - numDigits; i++) result += "0";
  result += str(index);
  return result;
}

void setup() {
  size(1920, 1080);
  frameRate(30);
  if (SAVE_OUTPUT || SAVE_VIDEO) {
    // create output folder
    outputPath = "outputs/" + timestamp() + "/";
    new File(outputPath).mkdirs();
    // just run draw() once
    noLoop();
  }
  
  system = new System();
}

void draw() {
  if (SAVE_OUTPUT || SAVE_VIDEO) {
    if (OUTPUT_TYPE == "svg") {
      // No saving intermediate frames for svg, sorry!
      // You could probably make something work if that's really what you need.
      beginRecord(SVG, outputPath + "output.svg");
      for (int i = 0; i < NUM_STEPS; i++) {
        system.step();
        frameCount++;
      }
      endRecord();
    } else if (OUTPUT_TYPE == "tif" || OUTPUT_TYPE == "png") {
      PGraphics hires = createGraphics(width * RASTER_SCALE, height * RASTER_SCALE);
      beginRecord(hires);
      hires.scale(RASTER_SCALE);
      for (int i = 1; i <= NUM_STEPS; i++) {
        system.step();
        frameCount++;
        if (SAVE_VIDEO) {
          hires.save(outputPath + padIndex(i) + "." + OUTPUT_TYPE);
        }
      }
      endRecord();
      hires.save(outputPath + NUM_STEPS + "." + OUTPUT_TYPE);
    }
    exit();
  } else {
    system.step();
  } 
}
