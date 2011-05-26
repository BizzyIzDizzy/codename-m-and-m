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

int main(void){	
	char * msg1 = "Codename-M-and-M\n";
	char * msg2 = "FRI 2011\n";
	int sredina1 = 80/2-(strlen(msg1)/2);
	int sredina2 = 80/2-(strlen(msg2)/2);
	int i;
	init_video();
	for(i = 0; i<sredina1; i++){
		putch(' ');
	}
	puts("Codename-M-and-M\n");
	for(i = 0; i<sredina2; i++){
		putch(' ');
	}
	puts("FRI 2011\n");
	for(;;)
	return 0;
}

