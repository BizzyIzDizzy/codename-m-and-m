#!/bin/bash
# Files with sources
NASMF="asm"
CPPF="src"
CF="src"
# Flags for compiling and linking
NASMFLAGS=""
CPPFLAGS=""
CFLAGS=""
LDFLAGS=""
# Sources for compiling
NASMSRC="boot.asm kernel.asm test.asm"
CPPSRC=""
CSRC=""
# Linker script
LDSCRIPT="LinkerScript.ld"

function Assemble(){
	while((${#1}!=0)); do
		
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
		Assemble;
		Compile;
		Link;;
	(*)
		Help;;
esac
exit 0
