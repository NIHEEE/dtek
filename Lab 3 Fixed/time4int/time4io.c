
#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

int getsw(void) {
    //return the value of the switches, all other bits are 0
    //the switches are connected to bits 11-8 of port D which has the address 0xbf8860d0

    volatile int * portD = (volatile int *) 0xbf8860d0;
    int switches = *portD & 0x00000f00;

    return switches >> 8;
}

int getbtns(void) {
    //return the value of the buttons, all other bits are 0
    //the buttons are connected to bits 7-5 of port D which has the address 0xbf8860d0

    volatile int * portD = (volatile int *) 0xbf8860d0;
    int buttons = *portD & 0x000000e0;
    return buttons >> 5;
}