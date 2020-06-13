;******************************************************************************
LIST P=18F4550 ;directiva para definir el procesador
#include <P18F4550.INC> ;definiciones de variables especificas del procesador
;******************************************************************************
;Bits de configuración
CONFIG FOSC = INTOSC_XT ;Oscilador INT usado por el uC , XT usado por el USB
CONFIG BOR = OFF ;BROWNOUT RESET DESHABILITADO
CONFIG PWRT = ON ;PWR UP Timer habilitado
CONFIG WDT = OFF ;Temporizador vigia apagado
CONFIG MCLRE= ON ;Reset apagado
CONFIG PBADEN=OFF
CONFIG LVP = OFF
;******************************************************************************
;Definiciones de variables
    CBLOCK 0x000 ;ejemplo de definición de variables en RAM de acceso
	contador
	cont
ENDC ;fin del bloque de constantes
;******************************************************************************
    ORG 0x0000 ;vector de reset
    bra inicio
    
inicio	
	bcf OSCCON,IRCF2,0
	bsf OSCCON,IRCF0,0 ;Oscilador interno a 125 kHz
	movlw 0x0F
	movwf ADCON1,0 ;Puertos Digitales
	clrf PORTA,0
	clrf TRISA,0
	clrf PORTD,0
	clrf TRISD,0 ;Puerto D Configurado como salida
	;configurar PWM 
	movlw 0x1C
	movwf CCP1CON
	movlw 0x07
	movwf T2CON,0 ;PRESCALER TIMER 2 X16
	movlw d'194'
	movwf PR2,0 ;CONFIGURACIÓN DE PERIODO pwm 100ms 
	bcf TRISC,2,0; Pin ccp1 como salida
	movlw 0x01 ;declarar puerto B PIN 0 COMO ENTRADA
	movwf TRISB
	clrf PORTB
	movlw 0x00
	movwf contador
	movf contador,0
	call decodificador
	movwf PORTD 
	movlw 0x13
	movwf CCPR1L,0
loop	
	btfss PORTB,0
	bra sig
	incf contador,1
	movf contador,W,0
	xorlw 0x0A
	btfss STATUS,Z,0
	bra nada1 
	movlw 0x01
	movwf contador
nada1	nop
antirrebote
	call ciclo 
	movwf CCPR1L,0 ;CONFIGURAR EL CLICLO DE TRABAJO
	call decodificador; MOSTRAR EL CICLO DE TRABAJO EN EL DISPLAY
	movwf PORTD
	movlw 0x02
	movwf PORTA
	call retardo
	movlw 0xC0
	movwf PORTD
	movlw 0x01
	movwf PORTA
	call retardo
	movlw 0xC6
	movwf PORTD
	movlw 0x04
	movwf PORTA,0
	call retardo
	movlw 0x08
	movwf PORTA,0
	movlw 0xA1
	movwf PORTD
	call retardo
	btfsc PORTB,0 ;RUTINA PARA SELECCIONAR CORRECTAMENTE EL CICLO
	goto antirrebote
sig	movf contador,0
	call decodificador
	goto loop
;********************************************************************
retardo movlw 0x25 ;RETARDO PARA MOSTRAR DATOS EN EL DISPLAY
	movwf cont
nada     nop   
	decfsz cont,F,0   
	bra nada   
	return 
decodificador ;TABLA QUE GUARDA LOS VALORES DEL DISPLAY
    rlcf contador,W,0 ;multiplica índice por 2
    addwf PCL,1 ;ajusta el PCL de acuerdo al valor del índice	
    retlw 0xC0 ;código del cero
    retlw 0xf9 ;código del uno
    retlw 0xA4 ;código del dos
    retlw 0xb0 ;código del tres
    retlw 0x99 ;código del cuatro
    retlw 0x92 ;código del cinco
    retlw 0x82 ;código del seis
    retlw 0xF8 ;código del siete
    retlw 0x80 ;código del ocho
    retlw 0x98 ;código del nueve
    return 
ciclo ;TABLA QUE GUARDA LOS VALORES PARA EL CICLO DE TRABAJO 
    rlcf contador,W,0 ;multiplica índice por 2
    addwf PCL,1 ;ajusta el PCL de acuerdo al valor del índice	
    retlw 0xC0 ;código del caso no existente
    retlw 0x13 ;código del 10% del pulso
    retlw 0x27 ;código del 20% del pulso
    retlw 0x3A ;código del 30% del pulso
    retlw 0x4E ;código del 40% del pulso
    retlw 0x61 ;código del 50% del pulso
    retlw 0x75 ;código del 60% del pulso
    retlw 0x89 ;código del 70% del pulso
    retlw 0x9C ;código del 80% del pulso
    retlw 0xB0 ;código del 90% del pulso
    return   
end

