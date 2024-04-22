#ifndef _GAME_H
#define _GAME_H

#include "types.h"
#include "graphics.h"

#define MAX_SNAKE_LENGTH (GAME_TILE_HEIGHT * GAME_TILE_WIDTH)
#define SNAKE_COLOUR L_GREEN
#define APPLE_COLOUR L_RED
#define GAME_OVER_MSG "\r\n\r\n               Game Over!"

int8_t game_over;

typedef struct {
    int8_t is_active;
    int16_t x;
    int16_t y;
}snake_cell;

typedef struct {
    snake_cell cells[MAX_SNAKE_LENGTH];
}snake;

typedef struct {
    int16_t x;
    int16_t y;
}apple; // do snakes even eat apples?

extern uint16_t rand();
snake init_snake();
apple init_apple();
void fill_tiles(snake* sn, apple* ap);
void move(snake* sn, char_t direction);
void move_apple(apple* ap);
int8_t has_hit_apple(snake* sn, apple* ap);
void grow_snake(snake* sn);

#endif
