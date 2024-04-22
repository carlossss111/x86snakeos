BITS 16

;--------------------------------------------------------------------------
; Program text
;--------------------------------------------------------------------------
SECTION .text

GLOBAL graphics_mode
GLOBAL print_colour
GLOBAL print
GLOBAL draw_pixel

; void graphics_mode
; Enables 320x200 VGA 256 colour mode, let's go RETRO!
graphics_mode:
    mov ah, 0x00
    mov al, 0x13                
    int 0x10
    ret

; void print(char* str, uint8_t colour)
; Prints a null-terminated string, including \r and \n characters.
print_colour:
    mov si, [esp+4]             ; Arg1 - string
    mov bl, [esp+8]             ; Arg2 - colour
    mov ah, 0x0E                ; Teletype text output
.print_loop:
    lodsb                       ; Load si into al
    cmp al, 0x0
    je .print_finish            ; If null terminator, finish
    int 0x10                    ; Print character
    jmp .print_loop
.print_finish:
    ret

; void draw_pixel(uint16_t x, uint16_t y, uint8_t colour)
; Draws a pixel to the 320x200 VGA buffer
draw_pixel:
    mov di, [esp+4]             ; Arg1 = x coordinate
    mov cx, [esp+8]             ; Arg2 = y coordinate
    mov ax, [PIXEL_WIDTH]       ; Width of Screen
    mul word cx                 ; Position = x + (screen_width * y);
    add di, ax
    mov al, [esp+12]            ; Arg3 = Colour
    mov es, [COLOUR_BUFFER];    ; ES: = 0xA000 * 10
    stosb                       ; Store register value AL at addr ES:DI
    ret

;--------------------------------------------------------------------------
; Global Constants
;--------------------------------------------------------------------------
SECTION .rodata
    GLOBAL PIXEL_WIDTH
    GLOBAL PIXEL_HEIGHT

    PIXEL_WIDTH: dw 320             ; Width of screen in pixels
    PIXEL_HEIGHT: dw 200            ; Height of screen in pixels
    COLOUR_BUFFER: dw 0xA000        ; Address of the colour buffer

;--------------------------------------------------------------------------
; Global Variables
;--------------------------------------------------------------------------
SECTION .data

    ; (global vars here)

;--------------------------------------------------------------------------
; Stack
;--------------------------------------------------------------------------
SECTION .bss

    align 16
    kernel_stack_bottom: equ $
        resb 16384		; reserve 16KB for stack
    kernel_stack_top:
