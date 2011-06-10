--/ PROJECT INFORMATIONS /--
C++ and assembly kernel programming.

THIS README.TXT IS WRITTEN FOR UBUNTU LINUX DISTRIBUTION.
ALL THE INSTRUCTIONS ARE TO BE USED IN THE BASH SHELL WHICH
IS THE DEFAULT SHELL IN UBUNTU.

--/ FILE LAYOUT /--
include/ 			-header files
src/ 				-sources
LinkerScript.ld		-Linker script with the sections of the kernel.bin
make.sh				-Automatic compiling and building bash script
Readme.txt			-Informations about the project

--/ TRY THE KERNEL /--
You will need some programs to assemble Assembly, C and C++ files.
You will also need a linker which will link all the object files together.
You can get all programs with the
sudo apt-get install "package"
where the package is/are:
-nasm
-gcc
-c++
-ld

When you have all programs installed you can run make.sh script like this:
./make.sh
Which will compile, assemble and link all files together into kernel.bin file.

To test this kernel binary you can use a program qemu (sudo apt-get install qemu),
which will use the QEMUs bootloader to load out kernel.
Use it like this:
qemu -kernel kernel.bin
It should run the kernel binary file in a new window.

--/ CONTRIBUTE TO THE PROJECT /--
We use Eclipse IDE with some plugins installed:
http://subclipse.tigris.org/ - Subversion client for Eclipse
http://www.eclipse.org/cdt/ - C/C++ development tools for Eclipse

Add our SVN repository to the Eclipse and checkout the latest versions of the files.

If you are registered programmer in this project you should use our secured repository link
(you will need to enter username and password).
SVN repository = https://codename-m-and-m.googlecode.com/svn/


If you are not registered programmer in this project you should use our annonymous repository link
SVN Annonymous repository = http://codename-m-and-m.googlecode.com/svn/

More information contact me: bizzyizdizzy@gmail.com