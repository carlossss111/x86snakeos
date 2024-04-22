# D.R. 2024

PREFIX = 
ASM    = nasm
CC     = gcc
BITS   = -m16
OPTS   = -nostdlib -ffreestanding -std=c17 -mno-red-zone -fno-exceptions -fno-pie -Wall -Wextra
LINKER = -T linker.ld
VM     = x86snakeos

compile:
	$(PREFIX)$(ASM) -f elf src/boot.asm -o build/boot.o
	$(CC) $(BITS) src/*.c build/boot.o -o build/boot.bin $(OPTS) $(LINKER)
	head -c 1474560 /dev/zero > build/bootloader.vfd
	dd status=noxfer conv=notrunc if=build/boot.bin of=build/bootloader.vfd

compile_hex: compile
	hexdump build/bootloader.vfd

run: compile
	virtualboxvm --startvm $(VM)

clean:
	rm build/*
