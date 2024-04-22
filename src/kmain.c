#include "kmain.h"

void kmain(){
    uint8_t col = 0x00;
    for(int x = 0; x < GAME_TILE_WIDTH; x++){
        for(int y = 0; y < GAME_TILE_HEIGHT; y++){
            game_tiles[x][y] = col;
            col++;
        }
    }
    draw_game_tiles();

    print("Hello World");
    print_colour("\r\nHello Universe", L_CYAN);

    for(;;);
}