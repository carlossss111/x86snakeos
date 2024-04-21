#ifndef _KMAIN_H
#define _KMAIN_H

#include "types.h"

extern void graphics_mode();
extern void print_colour(char* str, uint8_t colour);

#define print(str) print_colour(str, 0xF)

#endif
