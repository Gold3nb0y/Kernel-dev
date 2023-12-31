#!/bin/bash

i686-elf-as boot.S -o boot.o
i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T linker.ld -o chef.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
cp chef.bin isodir/boot/chef.bin

grub-mkrescue -o chefos.iso isodir
