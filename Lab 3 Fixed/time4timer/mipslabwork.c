/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x5957;
int timeoutcount = 0;

char textstring[] = "text, more text, and even more text!";

volatile unsigned int* tris_e = (volatile unsigned int*) 0xbf886100;
volatile unsigned int* port_e = (volatile unsigned int*) 0xbf886110;


/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void ){
  *tris_e = *tris_e & 0xffffff00;      //Set the 8 least significant bits of TRISE to 0
  
  TRISDSET = 0x000007F0;               //port D: bits 11-5 are inputs (buttons & switches)

  TMR2 = 0;                            //Initialize timer to 0
  PR2 = 31250;                         //Peruid = 1/10 s, 80 000 000/256/5 = 31250
  T2CONCLR = 0b1010;                   //Sets bit 1 to 0 (TCS) to use in-built timer and bit 3 to 0 for 16-bit timer. 
  T2CONSET = 0x8070;                   //0b1000000001110000; /*sets bit 15 (ON) to 1 to turn on timer, bit 6 (TCKPS) to 1 for 1:256 prescaling and bit 4 (TGATE) to 1 for gated time accumulation
  IFSCLR(0) = 0x100;                   //Clear the timer interrupt status flag   

  return;
}


/* This function is called repetitively from the main program */
void labwork( void ){

  int buttons = getbtns();
  int switches = getsw();
  
  if((IFS(0) & 0x100) == 0x100){     //If the time-out-flag is set to 1, bit 8 (T2IF) is set to 1
    timeoutcount++;
    IFSCLR(0) = 0x100;                 //Reset the time-out-flag
  }

  if (timeoutcount == 10){
    time2string( textstring, mytime ); 
    display_string( 3, textstring );
    display_update();
    tick( &mytime );

    *port_e += 1;
 
    TMR2 = 0; 
    IFSCLR(0) = 0x100;

    timeoutcount = 0;
  }

  if(buttons & 0b100){
    mytime = (mytime & 0x0fff) | (switches << 12);
  }
  if(buttons & 0b010){
    mytime = (mytime & 0xf0ff) | (switches << 8);
  }
  if(buttons & 0b001){
    mytime = (mytime & 0xff0f) | (switches << 4);
  }

  display_image(96, icon);
}






