#! /bin/bash

echo "Assembling!"
nasm -f aout -o start.o start.asm
echo "Compiling C sources!"
gcc -g -Wall -W -O2 -nostdinc -fno-builtin -o main.o main.c
echo "Linking it all together!"
ld -g -T link.ld -nostdlib -o kernel.bin start.o main.o
echo "Cleaning up the object files!"
rm *.o
echo "Done! Kernel slika je v datoteki kernel.bin!"

