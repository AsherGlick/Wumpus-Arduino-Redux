#include <LiquidCrystal.h>

/*
LCD Pins                 | Arduino Pins
1  GND                   | GND
2  VCC                   | VCC
3  Vo (contrast)         |                  connected to pot
4  RS  (Register Select) | 13
5  R/W (read/write)      | GND
6  E (enable)            | 12
7  DB0 (Databit 0)       | NONE
8  DB1                   | NONE
9  DB2                   | NONE
10 DB3                   | NONE
11 DB4                   | 8
12 DB5                   | 7
13 DB6                   | 4
14 DB7                   | 2
15 BL+ (backlight vcc)   | NOT USED
16 BL- (backlight gnd)   | NOT USED
*/

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(13, 12,8 , 7, 4, 2);

#define PIAZO_PIN 9

void tetris();
void configure() {
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
/*
  #define ENABLEERROR // enables error messages over serial
  #define CHANGEBAUD ### // changes the set baud rate to number instead of default 9600
*/
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
/*buzzer
| needs to be able to do pitch so it can play tetris as bonus feature
*/
void buzzer (int pitch){
  if (pitch == 1337) {
    tetris();
    return;
  }
  if (pitch > 255 || pitch < 0) pitch = 0;
  analogWrite(PIAZO_PIN,pitch/2);
}
/*motor
*/

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("hello, world!");
}

void loop() {
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  //lcd.setCursor(0, 1);
  // print the number of seconds since reset:
  
  ///lcd.print(millis()/1000);
  LCDMessage(millis()/1000);
  delay(300);
  buzzer(0);
  LCDMessage("hello world");
  delay(500);
  LCDMessage("nope5678901234567");
  delay(200);
  buzzer(1337);
}


/********* Tetris *********\
| This function palys tetris on the piazo speaker. The #defines are used to represent the freequency
| of different pitches. The Melody array stores the different notes while the beats array stores the
| tempo for each note. These can be changed to have the speaker play different songs
\*********/
#define  G     4820
#define  a     4600
#define  b     4200
#define  c     3830    // 261 Hz 
#define  d     3400    // 294 Hz 
#define  e     3038    // 329 Hz 
#define  f     2864    // 349 Hz 
#define  g     2550    // 392 Hz 
#define  A     2272    // 440 Hz 
#define  B     2028    // 493 Hz 
#define  C     2000    // 523 Hz 
#define  R     0       // A special note, 'R', to represent a rest
void tetris() {
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
