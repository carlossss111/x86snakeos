BITS 16

SECTION .boot

GLOBAL boot
EXTERN kmain

;--------------------------------------------------------------------------
; Bootloader Entrypoint
; The bootloader is 512 bytes loaded into memory at 0x7C00 and terminated
; with 0xAA55. It reads and boots the sector after this on the same disk.
;--------------------------------------------------------------------------
boot:
    ; Read the kernel if you can call it that
    mov [disk], dl              ; BIOS should put this disk in dl
    mov ah, 0x2                 ; Option: READ
    mov al, 10                  ; Sectors to read
    mov ch, 0                   ; Cylinder index
    mov dh, 0                   ; Head index
    mov cl, 2                   ; Sector index
    mov dl, [disk]              ; Disk index
    mov bx, kernel_start        ; Pointer to target address 
    int 0x13

    ; Run the kernel
    call graphics_mode          ; Initialise display
    mov sp, kernel_stack_top    ; Initialise stack
    call kmain                  ; Hand over control to the C code
    cli
	hlt

    ; Memory for disk
    disk: db 0x0
    
    ; Padding
    times 510 - ($-$$) db 0
    dw 0xAA55

    ; Kernel
    kernel_start:
    %include "src/kernel.asm"