// Arduino SPC

#include "Adafruit_TCS34725.h"

// Setting up pins for motor stepper motors
const int yMotorPins[] = {11, 10, 9, 8};
const int xMotorPins[] = {7, 6, 5, 4};
const int photoPin = 3;

// Stepper motor rotation sequence
const int Seq[][4] = {{1, 0, 0, 0},
                      {1, 1, 0, 0}, 
                      {0, 1, 0, 0}, 
                      {0, 1, 1, 0}, 
                      {0, 0, 1, 0}, 
                      {0, 0, 1, 1}, 
                      {0, 0, 0, 1}, 
                      {1, 0, 0, 1}};         
int nSteps[] = {0, 0};

// Setting up viewing angle and grid size
const float viewingAngle = 20.0;
const float photoSize = 40.0;
const float gridSize = tan((viewingAngle/360.0)*2*PI)/photoSize; 
const float radPerStep = (2.0 * PI) / 4076.0;
float currentTheta = 0.0001;
float currentPhi = 0.0001;
float currentX = 0.0;
float currentY = 0.0;
float currentDX = sin(radPerStep) / cos(currentTheta);
float currentDY = sin(radPerStep) / cos(currentPhi);
float startPosition = 0.0;
float nextX;
float nextY;
int gridX = 0;
int gridY = 0;
int seqStepY = 0;
int seqStepX = 0;

// Color sensor Adafruit_TCS34725
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_154MS, TCS34725_GAIN_60X);

void setup() {
  Serial.begin(9600);
  for (int nPin = 0; nPin < 4; nPin++) {
    pinMode(yMotorPins[nPin], OUTPUT);
    pinMode(xMotorPins[nPin], OUTPUT);
  }
}

void loop() {
  // Wait 5 seconds before starting
  delay(5000);
  takePhoto();
  returnHome();
  while (true) {
    delay(1000);
  }
}

int takePhoto() {
  float moveN = 1;
  
  // Spiral from center outwards
  for (int nRowsCols = 0; nRowsCols < photoSize / 2.0; nRowsCols++) {
    for (int x = 0; x < moveN; x++) {
      nextX = currentX + gridSize;
      gridX++;
      moveToNew();
    }
    for (int x = 0; x < moveN; x++) {
      nextY = currentY + gridSize;
      gridY++;
      moveToNew();
    }
    moveN++;
    for (int x = 0; x < moveN; x++) {
      nextX = currentX - gridSize;
      gridX--;
      moveToNew();
    }
    for (int x = 0; x < moveN; x++) {
      nextY = currentY - gridSize;
      gridY--;
      moveToNew();
    }
    moveN++;
  }
}

void moveToNew() {
  while (abs(currentX - nextX) > currentDX || abs(currentY - nextY) > currentDY) {
    currentDX = sin(radPerStep) / cos(currentTheta);
    currentDY = sin(radPerStep) / cos(currentPhi);
    currentX = tan(currentTheta);
    currentY = tan(currentPhi) / cos(currentTheta);

    if (abs(currentX - nextX) > currentDX) {
      if (currentX < nextX) {
        takeStep(1, "left");
        currentTheta += radPerStep;
      }
      if (currentX > nextX) {
        takeStep(1, "right");
        currentTheta -= radPerStep;
      }
    }
    if (abs(currentY - nextY) > currentDY) {
      if (currentY < nextY) {
        takeStep(2, "left");
        currentPhi += radPerStep;
      }
      if (currentY > nextY) {
        takeStep(2, "right");
        currentPhi -= radPerStep;
      }
    }
  }

  // Log the data for the "pixel" to be used in image
  // Format: x,y,r,g,b
  Serial.print(gridX);
  Serial.print(",");
  Serial.print(gridY);
  Serial.print(",");
  uint16_t clr, red, green, blue;
  tcs.getRawData(&red, &green, &blue, &clr);
  Serial.print(red);
  Serial.print(",");
  Serial.print(green);
  Serial.print(",");
  Serial.println(blue);
}

// This function takes in a stepper motor number (1 or 2) and a direction (left or right)
void takeStep(int motor, const char* dir) {
  if (motor == 1) {
    for (int nPin = 0; nPin < 4; nPin++) {
      int xPin = xMotorPins[nPin];
      digitalWrite(xPin, Seq[seqStepX][nPin] ? HIGH : LOW);
    }
  } else if (motor == 2) {
    for (int nPin = 0; nPin < 4; nPin++) {
      int yPin = yMotorPins[nPin];
      digitalWrite(yPin, Seq[seqStepY][nPin] ? HIGH : LOW);
    }
  }
  delay(2);
  
  if (strcmp(dir, "left") == 0) {
    if (motor == 2) {
      nSteps[0]++;
      seqStepY = (seqStepY == 7) ? 0 : seqStepY + 1;
    }
    if (motor == 1) {
      nSteps[1]++;
      seqStepX = (seqStepX == 7) ? 0 : seqStepX + 1;
    }
  }
  if (strcmp(dir, "right") == 0) {
    if (motor == 2) {
      nSteps[0]--;
      seqStepY = (seqStepY == 0) ? 7 : seqStepY - 1;
    }
    if (motor == 1) {
      nSteps[1]--;
      seqStepX = (seqStepX == 0) ? 7 : seqStepX - 1;
    }
  }
}

void returnHome() {
  while (abs(nSteps[0]) > 1 || abs(nSteps[1]) > 1) {
    if (nSteps[0] > 1) { takeStep(2, "right"); }
    if (nSteps[0] < 1) { takeStep(2, "left"); }
    if (nSteps[1] > 1) { takeStep(1, "right"); }
    if (nSteps[1] < 1) { takeStep(1, "left"); }
  }
}

// This Arduino code controls a camera system that captures an image by moving a color sensor in a grid pattern to sample the colors of an object. 
// The program uses Adafruit's TCS34725 color sensor library and controls two stepper motors to move the sensor in the X and Y directions. 
// The code is organized into multiple functions, including setup and loop, which are responsible for initializing the hardware and controlling the main program flow. 
// The takePhoto function handles moving the sensor in a spiral pattern, and moveToNew function calculates the necessary steps to reach the next position on the grid. 
// The takeStep function controls the stepper motors, and the returnHome function moves the sensor back to the starting position. 
// Throughout the process, the color sensor captures RGB values of each position, and the data is logged to the serial monitor to be used for image reconstruction.