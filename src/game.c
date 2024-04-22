#include "game.h"

char_t prev_dir = 'd';

snake init_snake(){
    snake sn;
    for(int i = 0; i < MAX_SNAKE_LENGTH; i++){
        sn.cells[i].is_active = 0;
        sn.cells[i].x = -1;
        sn.cells[i].y = -1;
    }
    int8_t start_x = GAME_TILE_WIDTH/2;
    int8_t start_y = GAME_TILE_HEIGHT/2;
    sn.cells[0].is_active = 1;
    sn.cells[0].x = start_x;
    sn.cells[0].y = start_y;
    sn.cells[1].is_active = 1;
    sn.cells[1].x = start_x - 1;
    sn.cells[1].y = start_y;
    sn.cells[2].is_active = 1;
    sn.cells[2].x = start_x - 2;
    sn.cells[2].y = start_y;
    return sn;
}

void fill_tiles(snake* sn, apple* ap){
    for(int i = 0; i < MAX_SNAKE_LENGTH; i++){
        if(sn->cells[i].is_active){
            game_tiles[sn->cells[i].x][sn->cells[i].y] = SNAKE_COLOUR;
        }
    }
    game_tiles[ap->x][ap->y] = APPLE_COLOUR;
}

void move(snake* sn, char_t direction){
    // Prevent snake from moving in on itself
    if(direction == 'w' && prev_dir == 's')
        direction = prev_dir;
    if(direction == 'a' && prev_dir == 'd')
        direction = prev_dir;
    if(direction == 's' && prev_dir == 'w')
        direction = prev_dir;
    if(direction == 'd' && prev_dir == 'a')
        direction = prev_dir;
    prev_dir = direction;

    // Move first cell based on key press
    snake_cell* head = &sn->cells[0];
    int8_t prev_x = head->x;
    int8_t prev_y = head->y;
    if(direction == 'w')
        head->y--;
    if(direction == 'a')
        head->x--;
    if(direction == 's')
        head->y++;
    if(direction == 'd')
        head->x++;

    // Bounds Checking
    if( head->x >= GAME_TILE_WIDTH  || 
        head->y >= GAME_TILE_HEIGHT ||
        head->x < 0 ||
        head->y < 0 ){
            game_over = 1;
            return;
    }

    // Collision Checking
    for(int i = 1; i < MAX_SNAKE_LENGTH; i++){
        if( sn->cells[i].is_active    &&
            head->x == sn->cells[i].x &&
            head->y == sn->cells[i].y ){
                game_over = 1;
                return;
            }
    }

    // Move each additional cell based on cell infront
    uint16_t i = 1;
    snake_cell* current = head;
    while(i < MAX_SNAKE_LENGTH && current->is_active){
        current = &sn->cells[i];
        int8_t temp_x = current->x;
        int8_t temp_y = current->y;
        current->x = prev_x;
        current->y = prev_y;
        prev_x = temp_x;
        prev_y = temp_y;
        i++;
    }

}

void move_apple(apple* ap){
    ap->x = rand() % (GAME_TILE_WIDTH-1);
    ap->y = rand() % (GAME_TILE_HEIGHT-1);
    //TODO: prevent apple from spawning on snake
}

apple init_apple(){
    apple ap;
    move_apple(&ap);
    return ap;
}

int8_t has_hit_apple(snake* sn, apple* ap){
    if(sn->cells[0].x == ap->x && sn->cells[0].y == ap->y){
        return 1;
    }
    return 0;
}

void grow_snake(snake* sn){
    for(int i = 0; i < MAX_SNAKE_LENGTH; i++){
        if(!sn->cells[i].is_active){
            sn->cells[i].is_active = 1;
            return;
        }
    }
}
