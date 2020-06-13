  LIST P=18F4550  ;directiva para efinir el procesador  
 #include <P18F4550.INC> ;definiciones de variables especificas del procesador 
;****************************************************************************** ;Bits de configuración
 CONFIG FOSC = INTOSC_XT                  ;Oscilador INT usado por el uC , XT usado por el  USB                
 CONFIG BOR  = OFF   ;BROWNOUT RESET DESHABILITADO                
 CONFIG PWRT = ON    ;PWR UP Timer habilitado                
 CONFIG WDT  = OFF   ;Temporizador vigia apagado                
 CONFIG MCLRE= ON   ;Reset encendido                
 CONFIG PBADEN=OFF                
 CONFIG LVP  = OFF 
 ;****************************************************************************** 
 ;Definiciones de variables   
 cont      equ  0  
 led	   equ  0
 ;****************************************************************************** 
 ;Reset vector   
 ORG 0x0000 
 ;Inicio del programa principal                
 bcf  OSCCON,IRCF2,0   
 bsf  OSCCON,IRCF0,0   ;Oscilador interno a125 kHz                             
 movlw   0x0F                             
 movwf   ADCON1,0 ;Puertos Digitales   
 clrf PORTD,0   
 clrf TRISD,0
 setf TRISB;
 bcf  TRISB,3; SE DECLARA EL PIN 7 DEL PUERTO B COMO SALIDA4
 ;******************************************************
 loop
	CALL sec1
	call retardo  
	call sec1
	call retardo
	call retardo
	movlw 0x00
	movwf PORTD
	call retardo
	call retardo
	call sec2
	call retardo 
	call sec2 
	call retardo 
	call retardo
	movlw 0x00
	movwf PORTD
	call retardo
	call retardo
	call sec3 
	call retardo 
	call sec3 
	call retardo
	call retardo
	movlw 0x00
	movwf PORTD
	call retardo
	call retardo
	call sec4
	call retardo 
	call sec4 
	call retardo
	call retardo
	movlw 0x00
	movwf PORTD
	call retardo
	call retardo
	bra loop 
;****************************************************************************** 
 retardo  movlw 0xff               
	  movwf cont,0 
 nada	  nop   
	  decfsz cont,1,0
	  bra nada 
	  btg PORTB,3
 return              
 
 sec1  
	movlw 0x81
	movwf PORTD
	call retardo
	movlw 0X42
	movwf PORTD
	call retardo
	movlw 0X24
	movwf PORTD
	call retardo
	movlw 0X18
	movwf PORTD
	call retardo
	movlw 0X18
	movwf PORTD
	call retardo
	movlw 0x24
	movwf PORTD
	call retardo
	movlw 0X42
	movwf PORTD
	call retardo
	movlw 0X81
	movwf PORTD
	call retardo
	return
sec2 
	movlw 0x01
	movwf PORTD 
	call retardo
	movlw 0x03
	movwf PORTD 
	call retardo
	movlw 0x07
	movwf PORTD 
	call retardo
	movlw 0x1F
	movwf PORTD 
	call retardo
	movlw 0x3F
	movwf PORTD 
	call retardo
	movlw 0x7F
	movwf PORTD 
	call retardo
	movlw 0xFF
	movwf PORTD
	call retardo
	movlw 0x7F
	movwf PORTD 
	call retardo
	movlw 0x3F
	movwf PORTD 
	call retardo
        movlw 0x7F
	movwf PORTD 
	call retardo
	movlw 0x1F
	movwf PORTD 
	call retardo
	movlw 0x0F
	movwf PORTD 
	call retardo
        movlw 0x07
	movwf PORTD 
	call retardo
	movlw 0x03
	movwf PORTD 
	call retardo
	movlw 0x01
	movwf PORTD 
	call retardo
	movlw 0x00
	movwf PORTD 
	call retardo
	return              
sec3
        movlw 0x81
	movwf PORTD 
	call retardo
	movlw 0xC3
	movwf PORTD 
	call retardo
	movlw 0xE7
	movwf PORTD 
	call retardo
	movlw 0xFF
	movwf PORTD 
	call retardo
	 movlw 0x7E
	movwf PORTD 
	call retardo
	movlw 0x3C
	movwf PORTD 
	call retardo
	movlw 0x18
	movwf PORTD
	call retardo
        movlw 0x00
	movwf PORTD
	call retardo
	return
	
sec4    movlw 0x80
	movwf PORTD 
	call retardo
	movlw 0x01
	movwf PORTD 
	call retardo
	movlw 0x40
	movwf PORTD 
	call retardo
	movlw 0x02
	movwf PORTD 
	call retardo
	movlw 0x20
	movwf PORTD 
	call retardo
	movlw 0x04
	movwf PORTD 
	call retardo
        movlw 0x20
	movwf PORTD 
	call retardo
	movlw 0x08
	movwf PORTD 
	call retardo
	movlw 0x10
	movwf PORTD 
	call retardo
	movlw 0x08
	movwf PORTD 
	call retardo
	movlw 0x20
	movwf PORTD 
	call retardo
	movlw 0x04
	movwf PORTD 
	call retardo
	movlw 0x40
	movwf PORTD 
	call retardo
	movlw 0x02
	movwf PORTD 
	call retardo
        movlw 0x80
	movwf PORTD 
	call retardo
	movlw 0x01
	movwf PORTD 
	call retardo
	movlw 0x00
	movwf PORTD 
	call retardo
	return 
 END
