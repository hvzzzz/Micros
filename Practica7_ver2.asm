;****************************************************************************** 
 
 LIST P=18F4550                 ;directiva para definir el procesador  
 #include <P18F4550.INC>   ;definiciones de variables especificas del procesador 
 
;****************************************************************************** ;Bits de configuración                  
 CONFIG FOSC = INTOSC_XT   ;Oscilador INT usado por el uC , XT usado por el  USB                  
 CONFIG BOR  = OFF    ;BROWNOUT RESET DESHABILITADO                  
 CONFIG PWRT = ON     ;PWR UP Timer habilitado                  
 CONFIG WDT  = OFF    ;Temporizador vigía apagado                  
 CONFIG MCLRE=ON    ;Reset apagado                  
 CONFIG PBADEN=OFF                  
 CONFIG LVP  = OFF 
 ;****************************************************************************** 
 ;Definiciones de variables   
 CBLOCK 0x000   ;ejemplo de definición de variables en RAM de acceso   
 flags    ;banderas   
 iun    ;índice de unidades   
 cuni    ;código de 7 segmentos de unidades   
 idec    ;índice de decenas   
 cdec    ;código de 7 segmentos de decenas    
 iumin   ;indice de las unidades de minuto
 cumin  ;codigo de las unidades minutos
 idmin 
 cdmin
 icen
 ccen
 imil
 cmil
 cont
 aux
 ENDC    ;fin del bloque de constantes 
 ;****************************************************************************** 
 ;Reset vector   
	ORG 0x0000   
	bra inicio   
	org 0x08   ;vector de alta prioridad   
	bra RST0   ;ramifica servicio interrupción T0   
	org 0x18   ;vector de baja prioridad   
	goto RSINT   
	org 0x0020 
inicio  bsf  OSCCON,IRCF2,0   
	bsf OSCCON,IRCF1,0   
	bcf OSCCON,IRCF0,0  ;Oscilador interno a 4 MHz                             
	movlw   0x0F                             
	movwf   ADCON1,0            ;Puertos Digitales                
	clrf PORTD,0 
	clrf TRISD,0 ;Puerto D Configurado como salida   
	;setf TRISB,0
	;movlw 0xE0   
	;movwf TRISC,0   ;RC0 y RC1 como salidas   
	clrf TRISC
	clrf PORTC,0
	clrf TRISA
	bcf TRISB,0
	movlw   0x95                             
	movwf   T0CON,0  ;timer 16 bits prescalerX64   
	movlw 0XE0  
	movwf INTCON,0  ;interrupciones TMR0,prioridad habilitada    
	bsf RCON,IPEN,0  ;habilitamos prioridades de interrupción  
	movlw 0xC2    
	movwf TMR0H,0   
	movlw 0xF7   
	movwf TMR0L,0  ;valor de precarga para 1000ms a 4MHz   
	movlw   0x88                             
	movwf   INTCON3,0   ;habilitamos int1 en baja prioridad   
	clrf TBLPTRL,0   
	movlw 0x03   
	movwf TBLPTRH,0   
	clrf TBLPTRU,0  ;tblptr=0x000300   
	clrf iun,0   
	clrf idec,0   ;iniciamos en 0 
	clrf icen,0
	clrf imil,0
	clrf iumin,0
	clrf idmin,0
	clrf aux,0
	
lee     movff iun,TBLPTRL  ;ajusta apuntador   
	tblrd *   ;lee la tabla sin modificar apuntador   
	movff TABLAT,cuni ;cuni tiene código 7 segmentos  
	movff   idec,TBLPTRL   ;ajusta apuntador   
	tblrd * ;lee la tabla sin modificar apuntador   
	movff TABLAT,cdec  ;cdec tiene código 7 segmentos 
	movff iumin, TBLPTRL
	tblrd *
	movff TABLAT,cumin
	movff idmin, TBLPTRL
	tblrd *
	movff TABLAT,cdmin
	movff icen,TBLPTRL
	tblrd *
	movff TABLAT,ccen
	movff imil,TBLPTRL
	tblrd *
	movff TABLAT,cmil
loop    movlw  0x01   
	movwf  PORTA,0   ;encendemos display unidades   
	movff cuni,PORTD   
	;call INCREMENTO
	call retardo   
	movlw 0x02   
	movwf PORTA,0 ;encendemos display decenas   
	movff cdec,PORTD   
	call retardo   
	movlw  0x04   
	movwf  PORTA,0   ;encendemos display unidades   
	movff cumin,PORTD   
	call retardo
	movlw  0x08  
	movwf  PORTA,0   ;encendemos display unidades   
	movff cdmin,PORTD   
	call retardo
	movlw 0x10
	movwf PORTA,0;encendemos display de las centenas
	movff ccen,PORTD
	call retardo
	movlw 0x20
	movwf PORTA,0;encendemos display de las centenas
	movff cmil,PORTD
	call retardo
	btfss flags,0,0   
	bra loop   
	bcf flags,0,0   
	incf iun,F,0   
	movf iun,W,0   
	xorlw 0x0a   
	btfss STATUS,Z,0;verifica límite de tabla   
	bra     lee  
	clrf iun,0  
	incf idec,F,0   
	movf idec,W,0   
	xorlw 0x06   
	btfss STATUS,Z,0   
	bra     lee
	clrf iun,0
	clrf idec,0
	incf iumin,F,0
	movf iumin,W,0
	xorlw 0x0a
	btfss STATUS,Z,0
	bra lee
	clrf iun,0
	clrf idec,0
	clrf iumin,0
	incf idmin,F,0
	movf idmin,W,0
	xorlw 0x06
	btfss STATUS,Z,0
	bra lee
	clrf iun,0
	clrf idec,0
	clrf iumin,0
	clrf idmin,0
	incf icen,F,0   
	movf icen,W,0 
	movwf aux,0
	xorlw 0x0a   
	btfss STATUS,Z,0   
	bra lee
	clrf iun,0
	clrf idec,0
	clrf icen,0
	incf imil,F,0   
	movf imil,W,0   
	xorlw 0x02
	btfss STATUS,Z,0   
	bra  lee 
	call veint
	;movf aux,w,0
	;xorlw 0x01
	;btfss STATUS,Z,0
	;bra  lee 
	;movwf aux,0
	;bra tu
	clrf icen,0
	clrf imil,0 
	goto lee 
	;****************************************************************************** 
veint 
leei     movff iun,TBLPTRL  ;ajusta apuntador   
	tblrd *   ;lee la tabla sin modificar apuntador   
	movff TABLAT,cuni ;cuni tiene código 7 segmentos  
	movff   idec,TBLPTRL   ;ajusta apuntador   
	tblrd * ;lee la tabla sin modificar apuntador   
	movff TABLAT,cdec  ;cdec tiene código 7 segmentos 
	movff iumin, TBLPTRL
	tblrd *
	movff TABLAT,cumin
	movff idmin, TBLPTRL
	tblrd *
	movff TABLAT,cdmin
	movff icen,TBLPTRL
	tblrd *
	movff TABLAT,ccen
	movff imil,TBLPTRL
	tblrd *
	movff TABLAT,cmil
loopi   movlw  0x01   
	movwf  PORTA,0   ;encendemos display unidades   
	movff cuni,PORTD   
	call retardo   
	movlw 0x02   
	movwf PORTA,0 ;encendemos display decenas   
	movff cdec,PORTD   
	call retardo   
	movlw  0x04   
	movwf  PORTA,0   ;encendemos display unidades   
	movff cumin,PORTD   
	call retardo
	movlw  0x08  
	movwf  PORTA,0   ;encendemos display unidades   
	movff cdmin,PORTD   
	call retardo
	movlw 0x10
	movwf PORTA,0;encendemos display de las centenas
	movff ccen,PORTD
	call retardo
	movlw 0x20
	movwf PORTA,0;encendemos display de las centenas
	movff cmil,PORTD
	call retardo
	btfss flags,0,0   
	bra loopi   
	bcf flags,0,0   
	incf iun,F,0   
	movf iun,W,0   
	xorlw 0x0a   
	btfss STATUS,Z,0;verifica límite de tabla   
	bra  leei  
	clrf iun,0   
	incf idec,F,0   
	movf idec,W,0   
	xorlw 0x06   
	btfss STATUS,Z,0   
	bra     leei
	clrf iun,0
	clrf idec,0   
	incf iumin,F,0
	movf iumin,W,0
	xorlw 0x0a
	btfss STATUS,Z,0
	bra leei
	clrf iun,0
	clrf idec,0
	clrf iumin,0
	incf idmin,F,0
	movf idmin,W,0
	xorlw 0x06
	btfss STATUS,Z,0
	bra leei
	clrf iun,0
	clrf idec,0
	clrf iumin,0
	clrf idmin,0
	incf icen,F,0   
	movf icen,W,0 
	movwf aux,0
	xorlw 0x04   
	btfss STATUS,Z,0   
	bra leei
return

;*******************************************************************************
retardo setf cont,0
nada     nop   
	decfsz cont,F,0   
	bra nada   
	return 
	;****************************************************************************** 
RST0    bcf INTCON,TMR0IF,0  ;apagamos bandera timer0   
	movlw 0xC2   
	;movwf 0xF1
	movwf TMR0H,0  
	;movlw 0x7c  
	movlw 0xF7
	movwf TMR0L,0   ;valor de precarga para 1000ms a 4MHz   
	bsf flags,0,0   
	retfie 
	;********************************************************************
RSINT   bcf INTCON3,INT1IF,0  ;Limpiamos bandera de interrupción   
	incf iumin,F,0
	movf iumin,W,0
	xorlw 0x0a
	btfss STATUS,Z,0
	bra nada1 
	clrf iumin
	incf idmin,F,W
	movf idmin,W,0
	xorlw 0x06
	btfss STATUS,Z,0
	bra nada1
	clrf iumin
	clrf idmin
	incf icen,F,0   
	movf icen,W,0 
	movwf aux,0
	xorlw 0x0a   
	btfss STATUS,Z,0   
	bra nada1
	clrf icen,0
	incf imil,F,0   
	movf imil,W,0   
	xorlw 0x02
	btfss STATUS,Z,0
	bra nada1
	clrf iumin
	clrf idmin
	clrf icen,0
	clrf imil,0
nada1   nop 
	retfie
INCREMENTO 
	btfss PORTB,0
	nop
	incf iumin,F,0
	return 
	;********************************************************************   
	org 0x300    ;DB directiva que Define Byte   
	DB 0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x98               
	END 
