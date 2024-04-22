#include "kmain.h"

void kmain(){
    register_interrupt_handlers();

    snake sn = init_snake();

    for(;;){
        // Movement
        move(&sn, last_pressed);

        // State check
        if(game_over){
            reset_game_tiles();
            draw_game_tiles();
            print("Game over man!");
            break;
        }
    
        // Graphics
        reset_game_tiles();
        fill_snake_tiles(&sn);
        draw_game_tiles();
        waitms(2000);
    }

    for(;;);
}