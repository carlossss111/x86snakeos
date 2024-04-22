#ifndef _KMAIN_H
#define _KMAIN_H

#include "types.h"
#include "graphics.h"
#include "interrupts.h"

extern void graphics_mode();
extern void print_colour(char* str, uint8_t colour);
extern void waitms(uint16_t millis);

#define print(str) print_colour(str, 0xF)

#endif
