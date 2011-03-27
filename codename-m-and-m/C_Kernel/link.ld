/* output format bo default - "coff-go32", ki je privzet format za ELF, tako da ga ni treba dodajati */
ENTRY(entry)
LS_Phys = 0x100000; /* 1 megabajt za nalaganje fizičnih naslovov */
LS_Virt = 0x100000; /* 1 megabajt za virtualne naslove */
SECTIONS
{
	.text LS_Virt : AT(LS_Phys)
	{
		LS_Code = .;
		/* Simboli za začetek segmenta s kodo */
		code = .; _code = .;
		/* Kernel koda */
		*(.text)
		/* read only del, ki mora biti prisoten zaradi ELF formata */
		*(.rodata*)
		. = ALIGN(4096);
	}
	.data : AT(LS_Phys + (LS_Data - LS_Code))
	{
		LS_Data = .;
		/* Simboli za začetek segmenta s podatki */
		data = .; _data = .;
		/* Kernel podatki */
		*(.data)
		. = ALIGN(4096);
	}
	.bss : AT(LS_Phys + (LS_Bss - LS_Code))
	{
		LS_Bss = .;
		/* Simboli za začetek BSS segmenta */
		bss = .; _bss = .;
		/* Kernel bss podatki */
		*(.bss)
		*(COMMON) /* COMMON variables */
		. = ALIGN(4096);
	}
	end = .; _end = .;
}
