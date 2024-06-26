BITS 16

;--------------------------------------------------------------------------
; Program text
;--------------------------------------------------------------------------
SECTION .text

GLOBAL graphics_mode
GLOBAL print_colour
GLOBAL print
GLOBAL draw_pixel
GLOBAL register_interrupt_handlers
GLOBAL waitms
GLOBAL rand
GLOBAL draw_digit

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

; void register_interrupt_handlers()
; Registers interrupts
register_interrupt_handlers:
	mov [0x0024], dword keyboard_callback
	ret

; INT keyboard_callback()
; Saves wasd state
keyboard_callback:
	pusha	                    ; Save state
    xor bx,bx                   ; bx = 0: signify key down event
    inc bx
    in al, 0x60                 ; Get input from keyboard PS/2 port
    btr ax, 7                   ; Carry flag is set if key up event
    jnc .keyDown
        dec bx                  ; bx = 1: key up event
    .keyDown:
    cmp al,0x11                 ; w
    jne .check_a
        mov word [cs:last_pressed], 'w'
    .check_a:
    cmp al,0x1e                 ; a
    jne .check_s         
        mov word [cs:last_pressed], 'a'
    .check_s:
    cmp al,0x1f                 ; s
    jne .check_d
        mov word [cs:last_pressed], 's'
    .check_d:
    cmp al,0x20                 ; d
    jne .check_end
        mov word [cs:last_pressed], 'd'
    .check_end:
    mov al, 0x20 
    out 0x20, al                ; Acknowledge the intrpt
	popa                        ; Restore state
	iret                        ; Return from an interrupt routine

; void waitms(uint16_t millis)
; Sleep for some milliseconds (it's kind of inaccurate but it works)
waitms:
    mov dx, [esp+4]
    mov cx, [esp+4]
    shr cx, 6                   ; Bitshifting to convert from mc to ms
    shl dx, 10
    mov ah, 0x86
    int 0x15                    ; cx:dx sleep time in mc
	ret

; uint16_t rand()
; Read a random number
rand:
    rdrand ax
    ret

; void draw_digit(uint16_t x, uint16_t y, uint16_y digit_to_print)
; Prints a digit to the screen. Can be used in graphics-only mode!
draw_digit:
    mov eax, [esp+12]           ; arg3 - digit
    imul eax, 2                 ; for some reason I can't lea *16
    lea edx, [NUM_ZERO+(eax*8)] ; load address of nth digit bitmap

    mov ax, [edx]               ; address
    mov bx, 0                   ; bit counter (columns)
    mov cx, 0                   ; addr counter (rows)
    
    .draw_num_loop:
    rol ax, 1                   ; rotate bits left
    test ax, 1                  ; test if last bit is 1
    jz .dont_draw               ; only draw if bit is '1'

        add bx, [esp+4]         ; arg1 - x position
        add cx, [esp+8]         ; arg2 - y position

        ; DRAW
        push edx
        pusha
        push .ret_addr
        mov [esp+4], bx
        mov [esp+8], cx
        mov [esp+12], byte 0x0F
        jmp draw_pixel
        .ret_addr:
        popa
        pop edx
        ; END DRAW

        sub bx, [esp+4]         ; reverse to previous values
        sub cx, [esp+8]

    .dont_draw:

    inc bx                      ; increment bit counter
    cmp bx, 16   
    jl .draw_num_loop           ; loop while bit counter less than 16

    mov bx, 0                   ; reset bit counter
    inc ecx                     ; increment addr counter
    lea di, [edx+ecx*2]         ; move to next row
    mov ax, [di]                ; load address in next row
    cmp cx, 8                   ; check if all rows done
    jl .draw_num_loop           ; continue if not
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

    %include "src/numbers.asm"  

;--------------------------------------------------------------------------
; Global Variables
;--------------------------------------------------------------------------
SECTION .data
    GLOBAL last_pressed

    last_pressed: dw 'd'

;--------------------------------------------------------------------------
; Stack
;--------------------------------------------------------------------------
SECTION .bss

    align 16
    kernel_stack_bottom: equ $
        resb 16384		; reserve 16KB for stack
    kernel_stack_top:
