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
;Código
CBLOCK  0x000
    result ;variable para realizar operaciones aritméticas
    centenas;valor de las centenas en grados celsius
    decenas ;valor de las decenas en grados celsius
    unidades ;valor de las unidades en grados celsius
    cuni ;codigo unidades de grados celsius
    cdec ;codigo decenas de grados celsius
    cont ;variables para el retardo
ENDC
ORG 0x00    ;Iniciar el programa en el registro 0x00
    goto    INICIO
    INICIO
    bsf OSCCON,IRCF2,0
    bsf OSCCON,IRCF1,0
    bcf	OSCCON,IRCF0,1   ;Oscilador interno a 500 kHz 
    clrf TBLPTRL,0   
    movlw 0x03   
    movwf TBLPTRH,0   
    clrf TBLPTRU,0  ;tblptr=0x000300   	
    movlw  0x00 
    movwf  TRISB ;declaración de salidas
    movwf  TRISD 
    movlw  0x0E
    movwf  ADCON1 ;voltajes de referencia de alimentación y configuración AN0
    movlw  0x00
    movwf  ADCON0 ;configuración del canal AN0
    movlw  0x08
    movwf  ADCON2 ;configuración adc
lee 
    movff unidades,TBLPTRL  ;ajusta apuntador   
    tblrd *   ;lee la tabla sin modificar apuntador   
    movff TABLAT,cuni ;cuni tiene código 7 segmentos  
    movff   decenas,TBLPTRL   ;ajusta apuntador   
    tblrd * ;lee la tabla sin modificar apuntador   
    movff TABLAT,cdec  ;cdec tiene código 7 segmentos
    bsf    ADCON0,ADON ;ENCENDIDO DEL ADC 
BUCLE  
    bsf    ADCON0, GO_DONE ;inicio de la conversión
    btfsc  ADCON0, GO_DONE ;terminó la conversión?
    goto  BUCLE  ;NO, regresa al bucle
    clrf centenas ;si limpia rejistros de datos 
    clrf decenas
    clrf unidades
    movf ADRESH,W ;mueve el registro ADRESH a W
    addwf ADRESH,W ;aproxima el valor de ADRESH al valor en grados duplicando su valor
    movwf result ;guarda el valor duplicado en result
  ;realizar divisiones por el método de las restas sucesivas
centenas1
    movlw d'100' ;mueve a w el número 100
    subwf result,W ;resta de resultado 100
    btfss STATUS,C ;result menor que 100?
    bra decenas1 ;si, vete a decenas
    movwf result ;no, salva result
    incf centenas,1; incremento las decenas
    bra centenas1 ;vuelve a realizar la resta
 decenas1 
    movlw d'10' ;mueve a w el número 10
    subwf result,W ;resta de resultado 10
    btfss STATUS,C; resutlado menor que 10?
    bra unidades1  ;si, vete a unidades
    movwf result ;no, entonces salva resultado
    incf decenas,1 ;incrementa las decenas
    bra decenas1 ;regresa a las decenas
 unidades1 
    movf result,W ;mueve resultado a w 
    movwf unidades ;guarda resultado en unidades
    
    movlw 0x02 ;enciendo 2do display
    movwf PORTB
    movff cuni,PORTD ;muestro unidades en el display
    call retardo 
    movlw 0x01 ;enciendo 1er display 
    movwf PORTB 
    movff cdec,PORTD ;muestro decenas en el display
    call retardo
    movlw 0x04 ;enciendo 3er display
    movwf PORTB 
    movlw 0x9C ;muestro simbolo de grados
    movwf PORTD
    call retardo
    movlw 0x08 ;encendo 4to display
    movwf PORTB
    movlw 0xC6 ;muestro C de grados celsius
    movwf PORTD
    call retardo
    bra lee
    ;******************************************************************************
    ;rutina de retardo
    
retardo setf cont,0 
    nada nop
	 decfsz cont,F,0
         bra nada
         return
    ;**********************************************
    ;tabla de valores del display
    org 0x300    ;DB directiva que Define Byte   
    DB 0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x98
END
    
 