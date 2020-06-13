/*Este programa es para el desarrollo de una llave electrónica
la cual utiliza un teclado matricial para introducir datos y un display para 
la visualización, además de LEDs para ver el estado de la llave*/


//Encabezado, declaración de bibliotecas
#include <Práctica 11_1.h>
#include<stdio.h>/*Se declara para utilizar la función strcmp, 
para la comparación de cadenas de caracteres*/
#use delay(clock=4Mhz)
#fuses hs,nowdt
#include<lcd.c>
#include <kbd_4x4.c>//libreria modificada para teclado matricial 4x4

//Declaración de variables
int x=1; //Contador de caracteres digitados
int y=0;//contador de intentos
char k;// caracter obtenido del teclado
char c[]={"05821"};//cadena de la contraseña
char d[]={"00000"};//cadena para guardar las teclas presionadas


void main()
{
   set_tris_A(0x00);
   lcd_init();//inicialización del LCD
   kbd_init();//inicialización del teclado matricial
   port_b_pullups(true);//Declaración pullups del puerto B
   
   do//ciclo infinito
   {
      k=kbd_getc();//se obtiene la tecla digitada
      lcd_gotoxy(1,1);
      printf(lcd_putc,"Ingrese la clave");
      output_A(0x02);//Se enciende el led rojo es decir que la llave esta bloqueada
      
      //condicional para escribir los digitos en la pantalla
      if((k!=0) && (k!='E') && (k!='F'))//si k es distinto de las teclas f,e, y vacia
      {
         lcd_gotoxy(x,2);
         printf(lcd_putc,"%c",k);//imprime el caracter 
         d[x]=k;//guarda el valor digitado en la cadena d
         x++; //incrementa el contador de caracteres
         //E es la en el teclado la tecla # y F es la tecla *
      }
      if((k!=0)&& (k=='F'))//si k es distinto del vacio y igual a F es decir 
      { //la tecla de asterisco entonces se comparan las cadenas
         if(strcmp(d,c)==0)//si las cadenas son iguales
         {
            do
            {//se imprime la clave es correcta
               k=kbd_getc();
               lcd_gotoxy(1,2);
               printf(lcd_putc,"Clave correcta");
               output_A(0x01);//enciende el led verde
               y=0;//se reinicia conteo de intentos
            }while(k!='F'); //sucede mientras no se vueva a presionar asterisco
            x=1;//se reinicia el conteo de caracteres
            d="00000";//se reinicia el valor de la cadena d
            printf(lcd_putc,"\f");//se borra el mensaje
            delay_ms(50);
         }
         else //en caso de que la clave sea incorrecta
         {//se imprime que la clave es incorrecta
            lcd_gotoxy(1,2);
            printf(lcd_putc,"CLAVE INCORRECTA");
            delay_ms(600);//se mantiene el mensaje 600ms
            x=1;//reinicia el conteo de caracteres
            y++;//incrementa el conteo de intentos
            d="00000";//reinicia la cadena d
            printf(lcd_putc,"\f");//borra el mensaje
         }
      }
      //en caso de que la tecla # sea presionada
      if ((k!=0)&&(k=='E'))
      {
         X--;//disminuye el contador 
         d[x]='0';//se elimina el valor digitado anteriormente
         lcd_gotoxy(x,2);
         printf(lcd_putc," ");//se borra solo el caracter digitado anteriormente
      }
      if (x==0)//en caso de que se presione muchas veces la tecla de borrar
      {
         x=1;//se asigna 1 para evitar errores en el pic
      }
      //en el caso de que se lleguen a los 3 intentos incorrectos
      if (y==3)
      {//entra a un ciclo infinito del que no se puede salir
         while(true)
         {
            printf(lcd_putc,"\fLlave bloqueada");
            delay_ms(15);//se imprime llave bloqueada
            output_A(0x06);//se enciende el led rojo y el buzzer
         }
         
      }
      
   }while(true);



}



