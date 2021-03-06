
/* wumpus.h, intended for the RPI wumpus robots */

#include "WProgram.h" // needed for external files
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
//LiquidCrystal lcd(13, 12,8 , 7, 4, 2);

#define PIAZO_PIN 9


void wumpusSetup();
void LCDMessage (char message[16]);
void buzzer (int pitch);
bool lightSensor (int lightSensor);
int waitForIR ();
void runMotor (int motorNumber, int speedAndDirection);
void __TETRIS_();




// initialize the library with the numbers of the interface pins

LiquidCrystal lcd(2, 4,12 , 7, 8, 13);

//#define PIAZO_PIN 9

/******************************* Wumpuse Setup *******************************\
| The wumpus setup function sets up the output and the input this function    |
| needs to be run before any other function in this program to make sure all  |
| the pins are correctly configured                                           |
| Preprocecor Changes                                                         |
|  CHANGEBAUD - changes the baud to the value specified                       |
\*****************************************************************************/
void wumpusSetup() {
  lcd.begin(16,2);
  lcd.clear();
  
  // Configure Buzzer
  pinMode(PIAZO_PIN,OUTPUT);
  
  // Configure Serial
  #ifndef CHANGEBAUD
    Serial.begin(9600);
  #endif
  #ifdef CHANGEBAUD
    Serial.begin(CHANGEBAUD);
  #endif
}
/********************************* LCD Display *********************************\
| Display a message to the LCD screen. You can write numbers or 16 character    |
| strings to the LCD. The function saves the last displayed message and puts it |
| on the top row while the newly inputed line is placed on the bottom row to    |
| emulate a terminal window. To use the function you call LCDMessage()          |
| For examples on how to use it in code read the documentation page             |
\*******************************************************************************/
char storedmessagec[16];
int storedmessagei;
bool intlast;
void LCDMessage (char message[16]) {
  lcd.clear();
  lcd.setCursor(0,0);
  if (intlast)
    lcd.print (storedmessagei);
  else
    lcd.print (storedmessagec);
  for (int i = 0; i < 16; i++) {
    storedmessagec[i] = message[i];
  }
  lcd.setCursor(0,1);
  lcd.print (message);
  intlast = false;
}
void LCDMessage (int message) {
  lcd.clear();
  lcd.setCursor(0,0);
  if (intlast)
    lcd.print (storedmessagei);
  else
    lcd.print (storedmessagec);
  storedmessagei = message;
  lcd.setCursor(0,1);
  lcd.print (message);
  intlast = true;
}
/*********************************** Buzzer ***********************************\
| The Buzzer function resonates the buzzer at a specific freequencee. There is |
| a way to get the buzzer to play tetris soundtrack if you type in the number  |
| 1337 into the pitch.                                                         |
\******************************************************************************/
void buzzer (int pitch){
  if (pitch == 1337) {
    __TETRIS_();
    return;
  }
  if (pitch > 255 || pitch < 0) pitch = 0;
  analogWrite(PIAZO_PIN,pitch/2);
}
/*********************************** Tetris ***********************************\
| This function palys tetris on the piazo speaker. The #defines are used to    |
| represent the freequency of different pitches. The Melody array stores the   |
| different notes while the beats array stores the tempo for each note. These  |
| can be changed to have the speaker play different songs                      |
\******************************************************************************/
// 1000000/value = herz
//      note   value      herz
#define  G     4820    // 207 Hz
#define  a     4600    // 217 Hz
#define  b     4200    // 238 Hz
#define  c     3830    // 261 Hz
#define  d     3400    // 294 Hz 
#define  e     3038    // 329 Hz 
#define  f     2864    // 349 Hz 
#define  g     2550    // 392 Hz 
#define  A     2272    // 440 Hz 
#define  B     2028    // 493 Hz 
#define  C     2000    // 500 Hz 
#define  R     0       // Rest

void __TETRIS_() {
// MELODY and TIMING  =======================================
//  melody[] is an array of notes, accompanied by beats[], 
//  which sets each note's relative length (higher #, longer note                                                                                                                                                                                                                           !
  int melody[] = { e, b, c, d, c, b, a, a ,c, e, d, c, b, c, d, e, c, a, a, d, f, A, g, f, e, c, e, d, c, b, b, c, d, e, c, a, a, e, b, c, d, c, b, a, a, c, e, d, c, b, c, d, e, c, a, a, d, f, A, g, f, e, c, e, d, c, b, b, c, d, e, c, a, a, e, c, d, b, c, a, G, b, e, c, d, b, c, e, A, e, e, b, c, d, c, b, a, a, c, e, d, c, b, c, d, e, c, a, a, d, f, A, g, f, e, c, e, d, c, b, b, c, d, e, c, a, a, e, b, c, d, c, b, a, a, c, e, d, c, b ,c, d, e, c, a, a, d, f, A, g, f, e, c, e, d, c, b, b, c, d, e, R};
  int beats[]  = {20,10,10,20,10,20,16,10,10,20,12,20,24,10,20,32,16,20,48,28,12,20,12,24,28,10,20,12,20,16,10,10,20,32,16,20,48,20,10,10,20,10,20,16,10,10,20,12,20,24,10,20,32,16,20,48,28,12,20,12,24,28,10,20,12,20,16,10,10,20,32,16,20,48,32,44,32,44,32,44,32,44,32,44,32,44,16,16,44,76,20,10,10,20,10,20,16,10,10,20,12,20,24,10,20,32,16,20,48,28,12,20,12,24,28,10,20,12,20,16,10,10,20,32,16,20,48,20,10,10,20,10,20,16,10,10,20,12,20,24,10,20,32,16,20,48,28,12,20,12,24,28,10,20,12,20,16,10,10,20,28, 50};  
  
  int MAX_COUNT = sizeof(melody) / 2; // Melody length, for looping.
  
  // Set overall tempo
  long tempo = 15000;
  // Set length of pause between notes
  int pause = 1000;
  // Loop variable to increase Rest length
  int rest_count = 100; //<-BLETCHEROUS HACK; See NOTES
  
  // Initialize core variables
  int toneval = 0;
  int beat = 0;
  long duration  = 0;
  // Set up a counter to pull from melody[] and beats[]
  for (int i=0; i<MAX_COUNT; i++) {
    toneval = melody[i];
    beat = beats[i];

    duration = beat * tempo; // Set up timing

    long elapsed_time = 0;
    if (toneval > 0) { // if this isn't a Rest beat, while the toneval has 
      //  played less long than 'duration', pulse speaker HIGH and LOW
      while (elapsed_time < duration) {

        digitalWrite(PIAZO_PIN,HIGH);
        delayMicroseconds(toneval / 2);

        // DOWN
        digitalWrite(PIAZO_PIN, LOW);
        delayMicroseconds(toneval / 2);

        // Keep track of how long we pulsed
        elapsed_time += (toneval);
      } 
    }
    else { // Rest beat; loop times delay
      for (int j = 0; j < rest_count; j++) { // See NOTE on rest_count
        delayMicroseconds(duration);  
      }                                
    }   
    // A pause between notes...
    delayMicroseconds(pause);
  }
}

/******************************** Light Sensor ********************************\
| This is the light sensor function, it uses a standard threshold value for    |
| weather a line is white or black                                             |
|  THRESHOLD IS NOT CALIBRATED AT THIS MOMENT                                  |
| #defines used:                                                               |
|   NEWLIGHTTHRESHOLD                                                          |
\******************************************************************************/
// #define NEWLIGHTTHRESHOLD
bool lightSensor (int lightSensor) {
  if (lightSensor == 1 || lightSensor == 2) {
    #ifndef NEWLIGHTTHRESHOLD
    if (analogRead(lightSensor) > 512) {
      return (true);
    }
    #endif
    #ifdef NEWLIGHTTHRESHOLD
    if (analogRead(lightSensor) > NEWLIGHTTHRESHOLD) {
      return (true);
    }
    #endif
    else {
      return (false);
    }
  }
}

/********************************** IR Input **********************************\
| The wait for IR function waits for an IR signal from the remote, this        |
| This function is not implemented do not screem, nobody will hear you anyways |
| #defines used:                                                               |
|   SWARMMODE                                                                  |
\******************************************************************************/
int waitForIR () {
  #ifndef SWARMMODE
  #endif
  #ifdef SWARMMODE
  #endif
  return 0;
}

/*********************************** Motor ***********************************\
| This function makes 
\*****************************************************************************/
void runMotor (int motorNumber, int speedAndDirection) {
    
}
