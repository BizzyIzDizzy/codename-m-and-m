; makro za urejanje podčrtajev
%macro IMP 1
%ifdef UNDERBARS
	EXTERN _%1
	%define %1 _%1
%else
	EXTERN %1
%endif
%endmacro

DS_MAGIC	equ	3544DA2Ah 	;za grub

SECTION .text
BITS 32

; vstopna točka

GLOBAL entry
entry:
;preverjanje če so podatkovni segmenti pravilno povezani, naslovljeni in
;naloženi
	mov	eax, [ds_magic]
	cmp 	eax, DS_MAGIC
	je	ds_ok

; prikaz utripajočega D z belo barvo na modri podlagi
	mov	word [0B8000h], 9F44h
	jmp	short $

ds_ok:

;nehaj uporabljati bootloaderjev GDT in naloži našega
	lgdt	[gdt_ptr]
	
	mov	ax, LINEAR_DATA_SEL
	mov	ds,ax
	mov	es,ax
	mov	ss,ax
	mov	fs,ax
	mov	gs,ax
	jmp LINEAR_CODE_SEL:sbat

sbat:
; Cjev BSS, bss in end sta definirana v linker skripti
EXTERN bss, end
	mov	edi,bss
	mov	ecx,end
	sub	ecx,edi
	xor	eax,eax
	rep	stosb

	mov	esp,stack
IMP main
	call 	main	;klic C kode
	jmp 	$	;neskončna zanka

; Multiboot header za GRUB, to mora biti v prvih 8k od kernel podatkov.
MULTIBOOT_PAGE_ALIGN	equ	1<<0
MULTIBOOT_MEMORY_INFO	equ 	1<<1
MULTIBOOT_AOUT_KLUDGE	equ	1<<16
MULTIBOOT_HEADER_MAGIC	equ 	0x1BADB002
MULTIBOOT_HEADER_FLAGS	equ	MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_AOUT_KLUDGE
MULTIBOOT_CHECKSUM	equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

; teji segmenti so definirani v linker skripti
EXTERN code, bss, end

ALIGN 4
mboot:
	dd 	MULTIBOOT_HEADER_MAGIC
	dd 	MULTIBOOT_HEADER_FLAGS
	dd 	MULTIBOOT_CHECKSUM
;aout kludge - morajo biti fizični naslovi
	dd 	mboot
	dd	code
	dd	bss
	dd	end
	dd	entry

SECTION .data
ds_magic:
	dd	DS_MAGIC

gdt:
; NULL descriptor
	dw	0	;limit 15:0
	dw	0	;base 15:0
	db	0	;base 23:16
	db	0	;type
	db	0	;limit 19:16, flags
	db	0	;base 31:24
;unused descriptor
	dw 0
	dw 0
	db 0
	db 0
	db 0
	db 0
LINEAR_DATA_SEL	equ	$-gdt
	dw	0FFFFh
	dw	0
	db	0
	db	92h	;present, ring 0, data, expand-up, writable
	db	0CFh	;page-granular (4 gig limit) , 32 bit
	db	0

LINEAR_CODE_SEL	equ 	$-gdt
	dw	0FFFFh
	dw	0
	db	0
	db	9Ah	;present, ring0, code, non-conforming, readable
	db	0CFh	;page-granular (4 gig limit), 32 bit
	db	0
gdt_end:

gdt_ptr:
	dw 	gdt_end - gdt -1
	dd	gdt

SECTION .bss
	resd	1024
stack:
