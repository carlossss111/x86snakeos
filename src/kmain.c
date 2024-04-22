#include "kmain.h"

void kmain(){
    register_interrupt_handlers();

    snake sn = init_snake();
    apple ap = init_apple();

    // Game Loop
    for(;;){
        // Movement
        move(&sn, last_pressed);

        // Apple action
        if(has_hit_apple(&sn, &ap)){
            move_apple(&ap);
            grow_snake(&sn);
        }

        // State check
        if(game_over){
            reset_game_tiles();
            draw_game_tiles();
            print(GAME_OVER_MSG);
            break;
        }
    
        // Graphics
        reset_game_tiles();
        fill_tiles(&sn, &ap);
        draw_game_tiles();
        waitms(1000);
    }

    for(;;);
}