/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x5957;

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void ){
  //Initialize Port E to be able to use LEDs
  //PORTE has the address 0xbf886110

  volatile int * portE = (volatile int *) 0xbf886110;
  *portE = *portE & 0xffffff00;

  //Initialize Port D to be inputs for bits 11 to 5
  //PORTD has the address 0xbf8860d0

  volatile int * portD = (volatile int *) 0xbf8860d0;
  *portD = *portD & 0x000007f0;
}

/* This function is called repetitively from the main program */
void labwork(void)
{
  int buttons = getbtns();
  int switches = getsw();

  //Check if button 4 is pressed, button 4 is connected to bit 3 of buttons
  //If button 4 is pressed, the value from switches is copied into the first digit of mytime

  switch(buttons){
    //Button 4 is pressed
    case 0x00000004:
      mytime = mytime & 0x0fff;
      mytime = mytime | (switches << 12);
      break;
    //Button 3 is pressed
    case 0x00000002:
      mytime = mytime & 0xf0ff;
      mytime = mytime | (switches << 8);
      break;
    //Button 2 is pressed
    case 0x00000001:
      mytime = mytime & 0xff0f;
      mytime = mytime | (switches << 4);
      break;
    //Button 4 and 3 are pressed
    case 0x00000006:
      mytime = mytime & 0x00ff;
      mytime = mytime | (switches << 8) | (switches << 12);
      break;
    //Button 4 and 2 are pressed
    case 0x00000005:
      mytime = mytime & 0x0f0f;
      mytime = mytime | (switches << 4) | (switches << 12);
      break;
    //Button 3 and 2 are pressed
    case 0x00000003:
      mytime = mytime & 0xf00f;
      mytime = mytime | (switches << 4) | (switches << 8);
      break;
    //Button 4, 3 and 2 are pressed
    case 0x00000007:
      mytime = mytime & 0x000f;
      mytime = mytime | (switches << 4) | (switches << 8) | (switches << 12);
      break;
    
  }
  
  delay( 1000 );
  time2string( textstring, mytime );
  display_string( 3, textstring );
  display_update();
  tick( &mytime );
  display_image(96, icon);

  //Changing function to increase the binary value shown on the LEDs each time tick is called
  //PORTE regiser has the address 0xbf886110
  //The 8 least significant bits of PORTE are connected to the 8 LEDs

  volatile int * porte = (volatile int *) 0xbf886110;
  *porte = *porte + 1;
  return;

}