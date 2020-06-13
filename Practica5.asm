LIST P=18F4550  ;directiva para efinir el procesador  
 #include <P18F4550.INC> ;definiciones de variables especificas del procesador 
;****************************************************************************** ;Bits de configuración
 CONFIG FOSC = INTOSC_XT                  ;Oscilador INT usado por el uC , XT usado por el  USB                
 CONFIG BOR  = OFF   ;BROWNOUT RESET DESHABILITADO                
 CONFIG PWRT = ON    ;PWR UP Timer habilitado                
 CONFIG WDT  = OFF   ;Temporizador vigia apagado                
 CONFIG MCLRE= OFF  ;Reset Encendido            
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
 ORG 0x08
 bra RSI
 ;Inicio del programa principal                
 inicio	    bsf OSCCON,IRCF2,0
	    bsf OSCCON,IRCF1,0
	    bcf	OSCCON,IRCF0,0   ;Oscilador interno a 4 MHz  
	    movlw   0x0F                             
	    movwf   ADCON1,0 ;Puertos Digitales   
	    movlw   0xB0
	    movwf   INTCON		;ACTIVOinterrupciones INT0, TMR0
	    movlw   0x95
	    movwf   T0CON		;Timer 16 bits, preescaler 64    
	    movlw   0xF7
	    movwf   TMR0L		;Precarga para 1000 ms
	    movlw   0xC2
	    movwf   TMR0H
	    clrf TRISD,0;Declara Puerto D como salida
	    clrf PORTD
	    bcf  flags,1
	    bsf flags,0
 ;******************************************************
loop 
 cero	movlw 0x3F
	movwf PORTD
	movlw 0x3F
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
bra loop
;**************************************************************
repite	btfss   flags,1	;Ya pasaron 1000 ms?
	bra	    repite
	bcf	    flags,1
	return
;***************************************************************	    
RSI	btfss INTCON,INT0IF
	bra   ST0
	btg  flags,0
	bcf   INTCON,INT0IF
	retfie
ST0	bcf	INTCON,TMR0IF
	movlw	0xC2
	movwf	TMR0H
	movlw	0xF7
	movwf	TMR0L		;Precarga para 1000 ms
	bsf	flags,1	;1000 ms
	retfie
	END