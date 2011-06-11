#!/bin/bash

# Files with sources
NASMF="./asm/"
CPPF="./src/"
CF="./src/"
# Flags for compiling and linking
NASMFLAGS="-f aout -o "
CPPFLAGS=""
CFLAGS=""
LDFLAGS=""
# Sources for compiling
NASMSRC="boot.asm"
CPPSRC=""
CSRC=""
# Linker script
LDSCRIPT="LinkerScript.ld"
LDSRC=""
# Output folder for object files
OUTPUT="./object/"
# Output folder for kernel
OUTKERNEL="./kernel/"

function Assemble(){
	while((${#1}!=0)); do
		printf "\n"
		input=$1
		output="${1%.asm}.o"
		echo "Assembling file \"$input\"!"
		nasm $NASMFLAGS $OUTPUT$output $NASMF$input || printf "Assembling failed! Check the file for errors!\n\n"
		if [ -a $OUTPUT$output ]; then
			printf "Assembling was a success! Output file = $output!\n\n"
			LDSRC="$LDSRC $output"
		fi
		shift
	done
}
function Compile(){
	echo "Compiling!"
}
function Link(){
	echo "Linking!"
}
function Help(){
	echo "Help!"
}
case $1 in
	(help|h)
		Help;;
	(assemble)
		Assemble $NASMSRC;;
	(compile)
		Compile;;
	(link)
		Link;;
	(all)
		Assemble $NASMSRC;
		Compile;
		Link;;
	(*)
		Help;;
esac
exit 0
