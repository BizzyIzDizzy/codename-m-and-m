/*
 * scrn.c
 *
 *  Created on: May 26, 2011
 *      Author: uros
 */

#include <system.h>

/* Definicija pointerja na text, barva, barva ozadja ter koordinate kurzorja */
unsigned short *textmemptr;
int attrib = 0x0F;
int csr_x = 0;
int csr_y = 0;

int getCsr_x(void){
        return csr_x;
}
int getCsr_y(void){
        return csr_y;
}
void setCsr(int x, int y){
        csr_x = x;
        csr_y = y;
}
/* Poscrolla po zaslonu */
void scroll(void){
        unsigned blank, temp;

        /* blank je prostor v pomnilniku, določimo mu barvo ozadja */
        blank = 0x20 | (attrib << 8);

        /* Vrstica 25 je konec, to pomeni da moramo poscrollati gor */
        if(csr_y >= 25){
                /* Premakni trenutni kos texta, ki napolnjuje zaslon */
                /* v buffer, vrstico po vrstico. */
                temp = csr_y - 25 + 1;
                memcpy(textmemptr, textmemptr + temp * 80, (25-temp) * 80 *2);

                /* Na koncu še nastavimo kos pomnilnika, ki zavema zadnjo vrstico
                 * texta na blank character */
                memsetw(textmemptr +(25-temp)*80, blank,80);
                csr_y = 25-1;
        }
}

/* Posodobi hardwerski kurzor */
void move_csr(void){
        unsigned temp;

        temp = csr_y * 80 +csr_x;

        /* To pošlje ukaz na porta 14 in 15 v CRT kontrolnem registru
         * VGA kontrolerja. */
        outportb(0x3D4, 14);
        outportb(0x3D5, temp >> 8);
        outportb(0x3D4, 15);
        outportb(0x3D5, temp);
}

/* Počisti zaslon */
void cls(){
        unsigned blank;
        int i;

        blank = 0x20 | (attrib << 8);

        /* Nastavi celoten zaslon na presledke v trenutni barvi */
        for(i=0; i<25; i++){
                memsetw(textmemptr +i * 80, blank, 80);
        }
        /* Posodobi virtualni kurzor in premakne hardwerski kurzor */
        csr_x = 0;
        csr_y = 0;
        move_csr();
}

/* Pošlje en char na zaslon */
void putch(unsigned char c){

        unsigned short *where;
        unsigned att = attrib << 8;

        /* Če je char backspace premaknemo kurzor nazaj */
        if(c == 0x08){
                if(csr_x !=0){
                        csr_x--;
                }
        }
        /* Če je char tabulator premaknemo kurzor naprej */
        else if(c == 0x09){
                csr_x = (csr_x+8)& ~(8-1);
        }
        /* Če je char Carriage return ... */
        else if(c == '\r'){
                csr_x = 0;
        }
        /* New line */
        else if(c == '\n'){
                csr_x = 0;
                csr_y++;
        }
        /* Katerikoli drug char večji ali enak od presledka je
         * lahko poslan na zaslon */
        else if(c >= ' '){
                where = textmemptr + (csr_y * 80 + csr_x);
                *where = c | att;
                csr_x++;
        }
        /* Če je kurzor prišel do konca vrstice naredimo novo vrstico */
        if(csr_x >= 80){
                csr_x = 0;
                csr_y++;
        }
        /* Poscrolla zaslon če je potrebno in premnaknemo hardwerski kurzor */
        scroll();
        move_csr();
}

/* Uporabi zgornjo funkcijo za izpis stringa */
void puts(char *text){
        int i;
        for(i=0; i<strlen(text); i++){
                putch(text[i]);
        }
}

/* Nastavi barvo teksta in ozadja */
void settextcolor(unsigned char forecolor, unsigned char backcolor){
        /* Zgornji 4 byti so barva ozadja spodnji pa barva texta */
        attrib = (backcolor << 4) | (forecolor & 0x0F);
}

/* Nastavi text-mode VGA pointer, ki počisti zaslon */
void init_video(void){
        textmemptr = (unsigned short *) 0xB8000;
        cls();
}
