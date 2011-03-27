#include <system.h>

#define VGA_MISC_READ 	0x3CC // VGA output register
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
	static const char msg1[] = "Codename M & M";
	static const char msg2[] = "FRI 2011";
	unsigned vga_fb_adr;
	
	/* preverjanje za enobarvno ali barvno VGA emulacijo */
	if((inportb(VGA_MISC_READ) & 0x01) != 0)
		vga_fb_adr = 0xb8000;
	else
		vga_fb_adr = 0xB0000;
	/* Prikaz sporočila na vrhu */
	memcpy((char *)(vga_fb_adr + 0), msg1, sizeof(msg1) -1);
	/* Prikaz sporočila v drugi vrstici */
	memcpy((char *)(vga_fb_adr + 160), msg2, sizeof(msg2) -1);
	/* vrnitev v start.asm, kjer se bo sistem ustavil */
	return 0;
}

