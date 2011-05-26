#ifndef _SYSTEM_H_
#define _SYSTEM_H_
/* Prototipi funkcij iz main.c */
extern __inline__ unsigned char inportb(unsigned short port);
extern void outportb(unsigned short _port, unsigned char _data);
extern unsigned char *memcpy(void *dst_ptr, const void *src_ptr, unsigned count);
extern unsigned char *memset(unsigned char *dest, unsigned char val, unsigned count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, unsigned count);
extern int strlen(const char *str);
/* Prototipi funkcij iz scrn.c */
extern void cls();
extern void putch(unsigned char c);
extern void puts(char *str);
extern void settextcolor(unsigned char forecolor, unsigned char backcolor);
extern void init_video();
#endif
