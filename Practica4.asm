LIST P=18F4550  ;directiva para efinir el procesador  
 #include <P18F4550.INC> ;definiciones de variables especificas del procesador 
;****************************************************************************** ;Bits de configuración
 CONFIG FOSC = INTOSC_XT                  ;Oscilador INT usado por el uC , XT usado por el  USB                
 CONFIG BOR  = OFF   ;BROWNOUT RESET DESHABILITADO                
 CONFIG PWRT = ON    ;PWR UP Timer habilitado                
 CONFIG WDT  = OFF   ;Temporizador vigia apagado                
 CONFIG MCLRE= ON   ;Reset APAGADO               
 CONFIG PBADEN=OFF                
 CONFIG LVP  = OFF 
 ;***************************************************************CBLOCK
 
 ;Definiciones de variables   
 CBLOCK    0x000     ;ejemplo de definición de variables en RAM de acceso  
 cont   
 ciclo   
 flags 
 ENDC      ;fin del bloque de constantes ;******************************************************************************
 ;**********************************************************************************************************************
 ;Reset vector   
 ORG 0x0000 
 bra inicio
 ORG 8
 bra RSI
 ;Inicio del programa principal                
 inicio	    bcf  OSCCON,IRCF2,0   
	    bsf  OSCCON,IRCF0,0   ;Oscilador interno a125 kHz                             
	    movlw   0x0F                             
	    movwf   ADCON1,0 ;Puertos Digitales   
	    movlw 0x90 ;Bits del registro intcon
	    movwf INTCON
	    ;clrf PORTD,0    
	    clrf TRISD,0;Declara Puerto D como salida
	    bsf  flags,0
 ;******************************************************
cero	movlw 0x3F
	movwf PORTD
	call repite
	btfss flags,0
	bra efe
uno	movlw 0x06
	movwf PORTD
	call repite
	btfss flags,0
	bra cero
dos	movlw 0x5B
	movwf PORTD
	call repite
	btfss flags,0
	bra uno
tres	movlw 0x4F
	movwf PORTD
	call repite
	btfss flags,0
	bra dos
cuatro	movlw 0x66
	movwf PORTD
	call repite
	btfss flags,0
	bra tres
cinco	movlw 0x6D
	movwf PORTD
	call repite
	btfss flags,0
	bra cuatro
seis	movlw 0x7D
	movwf PORTD
	call repite
	btfss flags,0
	bra cinco
siete	movlw 0x07
	movwf PORTD
	call repite
	btfss flags,0
	bra seis
ocho	movlw 0x7F
	movwf PORTD
	call repite
	btfss flags,0
	bra siete
nueve	movlw 0x67
	movwf PORTD
	call repite
	btfss flags,0
	bra ocho
aa	movlw 0x77
	movwf PORTD
	call repite
	btfss flags,0
	bra nueve
be	movlw 0x7C
	movwf PORTD
	call repite
	btfss flags,0
	bra aa
ce	movlw 0x39
	movwf PORTD
	call repite
	btfss flags,0
	bra be
dee	movlw 0x5E
	movwf PORTD
	call repite
	btfss flags,0
	bra ce
ee	movlw 0x79
	movwf PORTD
	call repite
	btfss flags,0
	bra dee
efe	movlw 0x71
	movwf PORTD
	call repite
	btfss flags,0
	bra ee
;**************************************************************
 retardo    movlw 0xff               
	    movwf cont,0 
 nada	    nop   
	    decfsz cont,1,0
	    bra nada 
 return    	
 ;*************************************************************
 repite	    movlw d'30'  ;llama 25 veces a la rutina retardo                
	    movwf ciclo 
 llama	    call retardo                             
	    decfsz ciclo,F,0                              
	    bra llama   
	    return                 
;***************************************************************	    
RSI	bcf   INTCON,INT0IF
	btg  flags,0
	retfie
	
	    END