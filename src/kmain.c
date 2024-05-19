#include "kmain.h"

void kmain(){
    register_interrupt_handlers();

    int16_t game_score = 0;
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
            game_score++;
        }

        // State check
        if(game_over){
            reset_game_tiles();
            draw_game_tiles();
            print(GAME_OVER_MSG);
            draw_num(PIXEL_WIDTH/2-24,PIXEL_HEIGHT/2-4, game_score);
            break;
        }
    
        // Graphics
        reset_game_tiles();
        fill_tiles(&sn, &ap);
        draw_game_tiles();
        draw_num(0,1,game_score);
        waitms(1000);
    }

    for(;;);
}