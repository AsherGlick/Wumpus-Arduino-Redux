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
    analogWrite(PIAZO_PIN, 120);
    delay(50);
    analogWrite(PIAZO_PIN, 100);
    delay(50);
    analogWrite(PIAZO_PIN, 80);
    delay(50);
    analogWrite(PIAZO_PIN,60);
    delay(50);
    analogWrite(PIAZO_PIN,40);
    delay(50);
    analogWrite(PIAZO_PIN,20);
    delay(50);
    analogWrite(PIAZO_PIN, 0);
    delay(50);
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
  LCDMessage("nope");
  delay(200);
  buzzer(1337);
}
