BITS 16

;--------------------------------------------------------------------------
; Program text
;--------------------------------------------------------------------------
SECTION .text

GLOBAL graphics_mode
GLOBAL print_colour
GLOBAL print

; void graphics_mode
; Enables 320x300 VGA 256 colour mode, let's go RETRO!
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
.print_loop
    lodsb                       ; Load si into al
    cmp al, 0x0
    je .print_finish            ; If null terminator, finish
    int 0x10                    ; Print character
    jmp .print_loop
.print_finish
    ret

;--------------------------------------------------------------------------
; Global Constants
;--------------------------------------------------------------------------
SECTION .rodata

    ; (global consts here)

;--------------------------------------------------------------------------
; Global Variables
;--------------------------------------------------------------------------
SECTION .data

    ; (global vars here)

;--------------------------------------------------------------------------
; Stack
;--------------------------------------------------------------------------
SECTION .bss

    align 4
    kernel_stack_bottom: equ $
        resb 16384		; reserve 16KB for stack
    kernel_stack_top:
