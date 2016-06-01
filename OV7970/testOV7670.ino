//#include <Wire.h>

//#define I2C_FASTMODE 1
#define I2C_SLOWMODE 1

#define SDA_PORT PORTD
#define SDA_PIN 2
#define SCL_PORT PORTD
#define SCL_PIN 3

#include <SoftI2CMaster.h>

#include "ov7670.h"

#define PCLOCK 4
#define HREF 5
#define JSYNC 6

#define PIXPORT DDRD
#define PIXDATA PIND

void setup() {
  // put your setup code here, to run once:
  pinMode(13, OUTPUT);
  pinMode(PCLOCK, INPUT);
  pinMode(HREF, INPUT);
  pinMode(JSYNC, INPUT);
  PIXPORT = 0b00000000;  // sets Arduino pins 0 to 7 :  1 as outputs, 0 as input
  //Wire.begin(); // join i2c bus (address optional for master)
  i2c_init();
  /*digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);*/
  Serial.begin(250000);
  
  //i2cWriteReg(OV7670_ADDR,REG_COM11,(0b00 << 5));
  /*i2cWriteReg(OV7670_ADDR,REG_CLKRC, 0b000111);
  i2cWriteReg(OV7670_ADDR,REG_COM14,(0b1 << 4) | (0b100 << 0));*/
  i2cWriteReg(OV7670_ADDR,REG_COM15, 0b100);

  //i2cWriteReg(OV7670_ADDR,REG_COM10, 0b1<<4);

  OV7670_set_clock(4000000,5000);
}

bool OV7670_set_clock(unsigned long inClk,unsigned long targClk)
{
  unsigned long bestDelta=0xFFFFFFFF;
  unsigned int calDiv;
  unsigned long calClock;
  byte icpS=0;
  byte pdvS=0;
  byte pd2S=1;
  for(byte icp=0;icp<=0b111111;++icp)
  {
    for(byte pdv=0;pdv<=0b100;++pdv)
    {
      for(byte pd2=0;pd2<=1;++pd2)
      {
        calDiv = (icp+1);
        calDiv <<= (pdv+pd2);
        calClock = inClk/calDiv;
        if(calClock<targClk)
        {
          calClock=targClk-calClock;
          if(calClock<bestDelta)
          {
            bestDelta = calClock;
            icpS=icp;
            pdvS=pdv;
            pd2S=pd2;
          }
        }
      }
    }
  }

  if(bestDelta!=0xFFFFFFFF)
  {
    if(pdvS>0)i2cWriteReg(OV7670_ADDR,REG_COM14,(0b1 << 4) | (pdvS << 0));
    else i2cWriteReg(OV7670_ADDR,REG_COM14,(0b0 << 4));
    if(pd2S>0)i2cWriteReg(OV7670_ADDR,REG_CLKRC, icpS);
    else i2cWriteReg(OV7670_ADDR,REG_CLKRC, 1<<7 | icpS);
    return true;
  }
  return false;
}

char i2cWriteReg(byte addr,byte reg,byte val)
{
   /*Wire.beginTransmission(addr & 0xFE);
   Wire.write(reg);
   Wire.write(val);
   Wire.endTransmission();*/

   i2c_start(addr & 0xFE);
   i2c_write(reg);
   i2c_write(val);
   i2c_stop();
   delayMicroseconds(10);
   
   return 0xFF;
}

char i2cReadReg(byte addr,byte reg)
{
   byte res;

  i2c_start(addr & 0xFE);
  i2c_write(reg);
  i2c_stop();
  delayMicroseconds(10);

  i2c_start(addr | 0x01);
  res = i2c_read(true);
  i2c_stop();
  delayMicroseconds(10);

   /*
   Wire.beginTransmission(addr & 0xFE);
   Wire.write(reg);
   Wire.endTransmission();
   
   Wire.beginTransmission(addr | 1);
   res = Wire.read();
   Wire.endTransmission();
   */
   return res;
}

void ecrireval(byte v)
{
  Serial.write('0'+v/100);
  Serial.write('0'+(v/10)%10);
  Serial.write('0'+(v/1)%10);
}

//byte lineBuff[640];

void loop() {
  // put your main code here, to run repeatedly:
  //if(i2cReadReg(addrScan,0x01)==0x80)digitalWrite(13, HIGH);

  /*Serial.write('A');Serial.write('=');
  ecrireval((0b11 << 5));
  Serial.write(':');
  ecrireval(i2cReadReg(OV7670_ADDR,REG_COM11));
  Serial.write(' ');
  digitalWrite(13, HIGH);
  Serial.write('\n');Serial.write('\r');*/
  
  /*ecrireval(i2cReadReg(0x42,0x01));
  delay(1000);*/
  //delay(100);

  /*while(digitalRead(JSYNC)==true);
  while(digitalRead(JSYNC)==false);

  while(digitalRead(JSYNC)==false)
  {
    while(digitalRead(PCLOCK)==false);
    
    while(digitalRead(PCLOCK)==true);
  }*/

  while(digitalRead(JSYNC)==true);
  while(digitalRead(JSYNC)==false);
  while(digitalRead(JSYNC)==true);

  while(digitalRead(JSYNC)==false)
  {
    if(digitalRead(PCLOCK)==true)
    {
      Serial.write(PIXDATA);
      while(digitalRead(PCLOCK)==true);
    }
  }

  /*
  while(digitalRead(JSYNC)==false);
  while(digitalRead(JSYNC)==true);
  digitalWrite(13, HIGH);
  //delayMicroseconds(100);
  while(digitalRead(JSYNC)==false);
  while(digitalRead(JSYNC)==true);
  digitalWrite(13, LOW);
  //delayMicroseconds(100);
  */
}
