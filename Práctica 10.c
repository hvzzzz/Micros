//Librerias del programa
#include <Práctica 10.h>
#include<lcd.c>
#include<kbd_4x4.c>

#define key_delay 200 //200 ms de espera para el teclado
int DIR;//variable para contar el numero de caracteres en el display

//Función tecla con timer 
//Se encarga de esperar a que se presione una tecla
char tecla_time(void)
   {
      char c='\0';
      unsigned int16 timeout;
      timeout=0;
      c=kbd_getc();
      while(c=='\0' && (++timeout <(key_delay*100)))
      {
         delay_us(10);
         c=kbd_getc();
      }
      return (c);
   }


   void main()
   { //La función lcd_init() usa PORTD para controlar el LCD alfanumérico
   char k;
   port_b_pullups(0xFF);
   set_tris_b(0);
   set_tris_c(0);
   
   
   lcd_init();
   lcd_putc("Bienvenido!!");
   KBD_INIT();
   
   
   WHILE(True)
   {
      DIR=1;
      LCD_GOTOXY(1,2);  //Ubica el cursor del LCD
      while (DIR<17)
      {
         if(k!='\0'){
         LCD_GOTOXY(DIR,2);
         lcd_putc(k);
         k='\0';
         DIR++;
      }

k=tecla_time();   //Lee el valor del teclado pero solo espera un tiempo determinado
if(DIR>16)
LCD_PUTC("\f");
lcd_gotoxy(1,1);
lcd_putc("Bienvenido!!");
}
}
}
