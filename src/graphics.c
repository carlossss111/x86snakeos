#include "graphics.h"

void draw_rect(uint16_t start_x, uint16_t start_y, uint16_t end_x, uint16_t end_y, uint8_t colour){
    for(int x = start_x; x < end_x; x++){
        for(int y = start_y; y < end_y; y++){
            draw_pixel(x,y,colour);
        }
    }
}

void reset_game_tiles(){
    for(int i = 0; i < GAME_TILE_WIDTH; i++){
        for(int j = 0; j < GAME_TILE_HEIGHT; j++){
            game_tiles[i][j] = BLACK;
        }
    }
}

void draw_game_tiles(){ //TODO: Fix overwriting text
    uint16_t px_in_tile = PIXEL_WIDTH / GAME_TILE_WIDTH;

    for(int i = 0; i < GAME_TILE_WIDTH; i++){
        for(int j = 0; j < GAME_TILE_HEIGHT; j++){
            draw_rect(
                i*px_in_tile, 
                j*px_in_tile,
                (i+1)*px_in_tile,
                (j+1)*px_in_tile,
                game_tiles[i][j]
            );
        }
    }
}
