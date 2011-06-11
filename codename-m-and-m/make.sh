#!/bin/bash

# Flags for compiling sources
NASMFLAGS=""
CPPFLAGS=""
CFLAGS=""
# Sources for compiling
NASMSRC=""
CPPSRC=""
CSRC=""
function compile(){
	echo "Compiling!"
}
function assemble(){
	echo "Assembling!"
}
	function link(){
	echo "Linking!"
}
function help(){
	echo "Help!"
	exit 0;
}

case $1 in
	(help|h)
		help;;
	(compile)
		compile;;
	(assemble)
		assemble;;
	(link)
		link;;
	(all)
		assemble;
		compile;
		link;;
	(*)
		help;;