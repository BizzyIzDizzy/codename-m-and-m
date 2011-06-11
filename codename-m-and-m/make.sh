#!/bin/bash

# Files with sources
NASMF="./asm/"
CPPF="./src/"
CF="./src/"
# Linker script
LDSCRIPT="LinkerScript.ld"
LDSRC=""
# Flags for compiling and linking
NASMFLAGS="-f aout -o "
CPPFLAGS="-Wall -Wextra -Werror -nostdlib -fno-builtin -nostartfiles -nodefaultlibs -fno-exceptions -fno-rtti -fno-stack-protector"
CFLAGS="-Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o "
LDFLAGS=" -T $LDSCRIPT -o "
# Sources for compiling
NASMSRC="boot.asm"
CPPSRC=""
CSRC="main.c scrn.c"
# Output folder for object files
OUTPUT="./object/"
# Output file for kernel
OUTKERNEL="./kernel/"
KERNEL="./kernel/kernel.bin"

function Assemble(){
	while((${#1}!=0)); do
		printf "\n"
		input=$1
		output="${1%.asm}.o"
		echo "Assembling file \"$input\"!"
		nasm $NASMFLAGS $OUTPUT$output $NASMF$input || printf "Assembling failed! Check the file for errors!\n\n"
		if [ -a $OUTPUT$output ]; then
			printf "Assembling was a success! Output file = $output!\n\n"
			LDSRC="$LDSRC $OUTPUT$output"
		fi
		shift
	done
}
function CompileC(){
	while((${#1}!=0)); do
		printf "\n"
		input=$1
		output="${1%.c}.o"
		echo "Compiling file \"$input\"!"
		gcc $CFLAGS $OUTPUT$output $CF$input || printf "Compiling failed! Check the file for errors!\n\n"
		if [ -a $OUTPUT$output ]; then
			printf "Compiling was a success! Output file = $output!\n\n"
			LDSRC="$LDSRC $OUTPUT$output"
		fi
		shift
	done
}
function CompileCpp(){
	printf "\n"
	while((${#1}!=0)); do
		printf "\n"
		input=$1
		output="${1%.cpp}.o"
		echo "Compiling file \"$input\"!"
		FLAG="-o $output -c $CPPF$input $CPPFLAGS"
		c++ $FLAG || printf "Compiling failed! Check the file for errors!\n\n"
		if [ -a $OUTPUT$output ]; then
			printf "Compiling was a success! Output file = $output!\n\n"
			LDSRC="LDSRC $OUTPUT$output"
		fi
		shift
	done
}
function Link(){
	ld $LDFLAGS $KERNEL $LDSRC || printf "Linking failed!\n\n"
	if [ -a $KERNEL ]; then
		printf "Linkig was a success! Kernel file = $KERNEL!\n\n"
	fi
}
function Clean(){
	printf "\nCleaning the object files!\n"
	FLAG="$OUTPUT"*.o
	rm $FLAG || printf "No object files to clean!\n"
	printf "\nCleaning done!\n"
}
function CleanAll(){
	printf "\nCleaning the object files!\n"
	FLAG="$OUTPUT"*.o
	rm $FLAG || printf "No object files to clean!\n"
	FLAG="$OUTKERNEL"*.bin
	printf "\nCleaning the kernel binaries!\n"
	rm $FLAG || printf "No kernel binaries to clean!\n"
	printf "\nCleaning done!\n"
}
function Run(){
	printf "\nTESTING KERNEL IN QEMU!\n"
	FLAG="-kernel $KERNEL "
	qemu $FLAG || printf "Testing failed! Check the kernel binary! \n"
}
function Help(){
	printf "You can use this script to build the entire project alltogether\n
or you can use it to do all the sections of the building seperatly!\n\n
Usage:\n
./make.sh [flags] [file1 ... fileN]\n
Usable flags are:\n
assemble\t- will assemble the files provided with the [file1 ... fileN]\n
\t argument or the files in the NASMSRC variable in this script (can be modified)\n
\t if no files are provided.\n\n
compile\t - will compile .c and .cpp files provided with the [fileq ... fileN]\n
\t argument or the files in the CSRC and CPPSRC variable in this script (can be modified) \n
\t if no files are provided.\n\n
link\t - will link all the object files together into a kernel binary.\n
\t The [file1 ... fileN] argument must be provided so the linker knows\n
\t which files to link together! This can not be done automaticly so u MUST\n
\t provide the filenames!\n\n
clean\t - will remove all the object files and the kernel binaries!\n\n
run\t - will run the kernel binary in the QEMU system simulator!\n\n
all\t - will assemble, compile and link all the files in the src and asm folder\n
\t of this project. All the source files included in the project must be entered in\n
\t the variables in this script!\n
\t \t NASMSRC - all the assembly sources seperated spaces!\n
\t \t CSRC - all the C sources seperated with spaces!\n
\t \t CPPSRC - all the C++ sources seperated with spaces\n
\t If you will use diffferend Linker script file you should enter that aswell:\n
\t \t LDSCRIPT - linker script file - it should be only one!\n
\t Then it should run the kernel binary with QEMU\n
\t This will also clean all the object files in the object folder.\n
\t The kernel binary should be in the kernel folder.\n\n"		
}
case $1 in
	(help|h)
		Help;;
	(assemble)
		shift
		if ((${#1}!=0)); then
			NASMSRC=""	
		fi
		while((${#1}!=0)); do
			NASMSRC="$NASMSRC $1"
			shift
		done
		Assemble $NASMSRC ;;
	(compile)
		shift
		if ((${#1}!=0)); then
			CPPSRC=""
			CSRC=""
		fi
		while((${#1}!=0)); do
			end=${1:((${#1}-3)):3}
			if [ end == "cpp" ]; then
				CPPSRC="$CPPSRC $1"
			else
				CSRC="$CSRC $1"
			fi
			shift
		done
		CompileC $CSRC ;
		CompileCpp $CPPSRC ;;
	(link)
		shift
		while((${#1}!=0)); do
			LDSRC="$LDSRC $OUTPUT$1"
			shift
		done
		Link;;
	(clean)
		CleanAll;;
	(run)
		Run;;
	(all)
		Assemble $NASMSRC;
		CompileC $CSRC;
		CompileCpp $CPPSRC
		Link;
		Clean;
		Run;;
	(*)
		Help;;
esac
exit 0
