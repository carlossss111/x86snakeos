#ifndef _GAME_H
#define _GAME_H

#include "types.h"
#include "graphics.h"

#define MAX_SNAKE_LENGTH (GAME_TILE_HEIGHT * GAME_TILE_WIDTH)
#define SNAKE_COLOUR L_RED

int8_t game_over;

typedef struct {
    int8_t is_active;
    int8_t x;
    int8_t y;
}snake_cell;

typedef struct {
    snake_cell cells[MAX_SNAKE_LENGTH];
}snake;

snake init_snake();
void fill_snake_tiles(snake* sn);
void move(snake* sn, char_t direction);

#endif
