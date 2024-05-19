#ifndef _GRAPHICS_H
#define _GRAPHICS_H

#include "types.h"

// BIOS Colours
#define BLACK   0x00
#define BLUE    0x01
#define GREEN   0x02
#define CYAN    0x03
#define RED     0x04
#define MAGENTA 0x05
#define BROWN   0x06
#define L_GRAY  0x07
#define D_GRAY  0x08
#define L_BLUE  0x09
#define L_GREEN 0x0A
#define L_CYAN  0x0B
#define L_RED   0x0C
#define L_MGNTA 0x0D
#define YELLOW  0x0E
#define WHITE   0x0F
// There are 255 total defined colours

#define GAME_TILE_WIDTH 32
#define GAME_TILE_HEIGHT 20

extern const uint16_t PIXEL_WIDTH;
extern const uint16_t PIXEL_HEIGHT;

extern void draw_pixel(uint16_t x, uint16_t y, uint8_t colour);
extern void draw_digit(uint16_t x, uint16_t y, int16_t digit);

uint8_t game_tiles[GAME_TILE_WIDTH][GAME_TILE_HEIGHT];

void reset_game_tiles();
void draw_game_tiles();
void draw_num(uint16_t x, uint16_t y, int16_t number);

#endif
