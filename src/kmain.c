#include "kmain.h"

void kmain(){
    register_interrupt_handlers();

    int16_t x = 0;
    int16_t y = 0;
    for(;;){
        reset_game_tiles();

        if(pressW){
            y--;
        }
        if(pressA){
            x--;
        }
        if(pressS){
            y++;
        }
        if(pressD){
            x++;
        }
        
        if(x > GAME_TILE_WIDTH){
            x = GAME_TILE_WIDTH-1;
        }
        if(y > GAME_TILE_HEIGHT){
            y = GAME_TILE_HEIGHT-1;
        }
        if(x < 0){
            x = 0;
        }
        if(y < 0){
            y = 0;
        }
        game_tiles[x][y] = L_CYAN;

        draw_game_tiles();
    }

    for(;;);
}