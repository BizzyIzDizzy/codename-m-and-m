#include <system.h>

/* Za compiler in njegove podčrtaje:P */
#ifdef __WIN32__
#if __GNUC__<3
#error Do not use MinGW GCC 2.x with NASM
#endif
int __main(void) {return 0;}
void _alloca(void) {}
#endif

/* Osnovne funkcije */
/* Branje iz I/O portov, s pomočjo inline assemblyja */
__inline__ unsigned char inportb(unsigned short port){
	unsigned char ret_val;
	__asm__ __volatile("inb %1,%0"
		: "=a"(ret_val)
		: "d"(port));
	return ret_val;
}
void outportb(unsigned short _port, unsigned char _data){
	__asm__ __volatile__("outb %1, %0" : : "dN" (_port), "a" (_data));
}
/* Standardne C funkcije */
unsigned char *memcpy(void *dst_ptr, const void *src_ptr, unsigned count){
	unsigned char *ret_val = dst_ptr;
	const char *src = (const char *)src_ptr;
	char *dst = (char *)dst_ptr;
	for(; count!=0; count--){
		*dst++=*src++;
	}
	return ret_val;
}
unsigned char *memset(unsigned char *dest, unsigned char val, unsigned count){
	char *temp = (char *) dest;
	for( ; count != 0; count--){
		*temp++=val;
	}
	return dest;
}
unsigned short *memsetw(unsigned short *dest, unsigned short val, unsigned count){
	unsigned short *temp = (unsigned short *) dest;
	for( ; count != 0; count--){
		*temp++ = val;
	}
	return dest;
}
int strlen(const char *str){
	int length;
	for(length = 0; *str!='\0'; str++){
		length++;
	}
	return length;
}
void sleep(double miliseconds){
	double counter;
	for(counter = 0; counter < miliseconds; counter++){	
		float temp = 0;
		while(temp<20000){
			temp+=0.1;
		}	
	}
}
int main(void){	
	char * msg1 = "Codename-M-and-M\n";
	char * msg2 = "Uros Marolt & Anze Mikec\n";
	char * msg3 = "FRI 2011";	
	int sredina1 = 80/2-(strlen(msg1)/2);
	int sredina2 = 80/2-(strlen(msg2)/2);
	int sredina3 = 80/2-(strlen(msg3)/2);
	int i;
	init_video();
	settextcolor(0x3,0x0);
	int counter = 1;
	int test = 1;
	while(test==1){
		cls();		
		for(i=1; i<counter; i++){
			puts("\n");
		}
		if(counter != 26 && counter != 27){
			for(i=0; i<sredina1; i++){
				putch(' ');
			}		
			puts(msg1);
		}else if(counter == 26){
			int x = getCsr_x();
			int y = getCsr_y();
			setCsr(0,0);
			for(i=0; i<sredina1; i++){
				putch(' ');
			}
			puts(msg1);
			setCsr(x,y);
		}
		if(counter != 25 && counter != 26 && counter != 27){
			for(i=0; i<sredina2; i++){
				putch(' ');
			}
			puts(msg2);
		}else if(counter == 25){
			int x = getCsr_x();
			int y = getCsr_y();
			setCsr(0,0);
			for(i=0; i<sredina2; i++){
				putch(' ');
			}
			puts(msg2);
			setCsr(x,y);
		}else if(counter == 26){
			int x = getCsr_x();
			int y = getCsr_y();
			setCsr(0,1);
			for(i=0; i<sredina2; i++){
				putch(' ');
			}
			puts(msg2);
			setCsr(x,y);
		}
		if(counter != 24 && counter != 25 && counter != 26 && counter != 27){
			for(i=0; i<sredina3; i++){
				putch(' ');
			}
			puts(msg3);
		}else if(counter == 24){
			int x = getCsr_x();
			int y = getCsr_y();
			setCsr(0,0);
			for(i=0; i<sredina3; i++){
				putch(' ');
			}
			puts(msg3);
			setCsr(x,y);
		}else if(counter == 25){
			int x = getCsr_x();
			int y = getCsr_y();
			setCsr(0,1);
			for(i=0; i<sredina3; i++){
				putch(' ');
			}
			puts(msg3);
			setCsr(x,y);
		}else if(counter == 26){
			int x = getCsr_x();
			int y = getCsr_y();
			setCsr(0,2);
			for(i=0; i<sredina3; i++){
				putch(' ');
			}
			puts(msg3);
			setCsr(x,y);
		}				
		sleep(500);
		counter++;
		if(counter == 27){
			counter = 2;
		}
	}
	return 0;
}

