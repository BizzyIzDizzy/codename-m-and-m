#!/bin/bash

# Flags for compiling

# Sources to compile

function Compile(){
	echo "Compiling!"
}
function Assemble(){
	echo "Assembling!"
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
	(compile)
		Compile;;
	(assemble)
		Assemble;;
	(link)
		Link;;
	(all)	
		Assemble;
		Compile;
		Link;;
esac