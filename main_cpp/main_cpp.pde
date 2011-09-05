#include "wumpus.h"
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


/*
  #define ENABLEERROR // enables error messages over serial
  #define CHANGEBAUD ### // changes the set baud rate to number instead of default 9600
*/







// MAIN //
void setup() {
  wumpusSetup();
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("hello, world!");
  
  //pinMode(14,INPUT);
}

void loop() {
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  //lcd.setCursor(0, 1);
  // print the number of seconds since reset:
  
  ///lcd.print(millis()/1000);
  //LCDMessage(millis()/1000);
  //delay(100);
  //LCDMessage("Hello World");
  //LCDMessage(analogRead(0));
  //delay(500);
  Serial.print("\r\n");
  Serial.print(analogRead(0));
}
// END MAIN //
