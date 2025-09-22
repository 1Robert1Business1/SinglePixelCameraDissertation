// Single RGB Color Sensor Plotter

import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
int rBoost, gBoost, bBoost;
Serial myPort;  
String val; 
float gridX, gridY;
int photoSize = 900;
int origin = photoSize / 2;
int gridSize = photoSize / 100;
int xPos = origin, yPos = origin;
int red, green, blue;
int maxSeen = 1;
float multiplier = 1.0;
ArrayList<Integer> reds = new ArrayList<Integer>();
ArrayList<Integer> greens = new ArrayList<Integer>();
ArrayList<Integer> blues = new ArrayList<Integer>();
ArrayList<Integer> xPositions = new ArrayList<Integer>();
ArrayList<Integer> yPositions = new ArrayList<Integer>();

void setup() { 
  size(900, 900);
  background(0);  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  
  cp5 = new ControlP5(this);
  cp5.addSlider("rBoost")
     .setPosition(10, 650)
     .setRange(0, 200)
     .setValue(100);
  cp5.addSlider("gBoost")
     .setPosition(10, 670)
     .setRange(0, 200)
     .setValue(100);
  cp5.addSlider("bBoost")
     .setPosition(10, 690)
     .setRange(0, 200)
     .setValue(100);
}

void draw() {
  val = myPort.readStringUntil('\n');
  if (val != null) {
    String[] list = split(val, ',');
    
    red = Integer.parseInt(list[2]);
    green = Integer.parseInt(list[3]);
    blue = Integer.parseInt(list[4].trim());
    
    maxSeen = max(max(red, green), blue, maxSeen);
    
    reds.add(red);
    greens.add(green);
    blues.add(blue);
    xPositions.add(xPos);
    yPositions.add(yPos);
    
    multiplier = 255.0 / maxSeen;
    
    println("scaling:", multiplier * maxSeen);
    println(red, " ", blue, " ", green);
    
    colorMode(RGB, maxSeen);
    for (int p = 0; p < xPositions.size(); p++) {
      fill(reds.get(p) * rBoost / 100.0, greens.get(p) * gBoost / 100.0, blues.get(p) * bBoost / 100.0);
      stroke(reds.get(p) * rBoost / 100.0, greens.get(p) * gBoost / 100.0, blues.get(p) * bBoost / 100.0);
      rect(xPositions.get(p), yPositions.get(p), gridSize, gridSize);
    }
    
    gridX = Integer.parseInt(list[0]);
    gridY = Integer.parseInt(list[1]);
    xPos = origin + (int)(gridX * gridSize);
    yPos = origin - (int)(gridY * gridSize);
  }
}

// This code is a Processing sketch that visualizes color data from an RGB color sensor. 
// It receives color data from a serial port, typically connected to an Arduino or another microcontroller, and displays the data as colored squares on a grid. 
// The sketch also provides sliders for adjusting the red, green, and blue color components individually.

// Here's a step-by-step explanation of what the code does:

// 1. Import necessary libraries: ControlP5 for creating user interface elements (sliders in this case) and the Serial library for receiving data from a microcontroller.
// 2. Declare global variables for storing color component values, grid positions, maximum seen value, and other related data. ArrayLists are used for storing the history of color and position values.
// 3. In the setup() function, set up the Processing sketch window, create a serial connection to receive data from a microcontroller, and configure ControlP5 sliders for adjusting the red, green, and blue color components.
// 4. In the draw() function, read incoming data from the serial connection. If the data is valid, parse the data to extract the color components and grid position values.
// 5. Update the maximum seen color value and append the received data to the ArrayLists.
// 6. Calculate a scaling factor based on the maximum seen color value, which will be used to normalize the color components' values.
// 7. Set the color mode to use the maximum seen value as the maximum value for each color component.
// 8. Iterate through the stored history of color and position values, and draw colored squares on the grid using the scaled color values.
// 9. Update the current grid position based on the received data.

// The result is a grid of colored squares that represent the color data received from the serial connection, allowing for a visual representation of the RGB color sensor's readings. 
// The sliders enable users to boost or reduce the influence of individual color components in the visualization.