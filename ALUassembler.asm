  LIST P=18f4550
    #include<P18F4550.INC>
    
    #DEFINE LED0 PORTD,RD0
    #DEFINE LED1 PORTD,RD1
    #DEFINE LED2 PORTD,RD2
    #DEFINE LED3 PORTD,RD3
    
    #DEFINE OP 0x07
  
    ORG 0
CONFIGURAR
;----------------CONFIG PORTA ---------------------------------------------

    MOVLW B'00111111' ;W=00111111
    CLRF PORTA,0
    MOVWF TRISA,0 ;TRISA=00111111
    MOVLW H'07' ;W=00000111
    MOVWF CMCON,0 ;COMCON = 7 Y EL COMPARADOR DE VOLTAJES
    MOVLW H'0F' ;Se asigna valor de 15
    MOVWF ADCON1,0 ;ADCON1 = 15 = todo digital
    
;----------------CONFIG PORTC ---------------------------------------------
    CLRF    PORTD
    MOVLW   B'01111000'
    SETF   TRISD,0
;----------------CONFIG PORTB ---------------------------------------------
    CLRF PORTB,0
    CLRF TRISB,0 ;Si TRISB = 0000000, todo PORTB son salidas
  
    
MAIN 
    MOVFF PORTA,WREG ;Lo del PORTA lo pasa a WREG
    ANDLW B'00000111' ;Aplica mask1 y guarda en WREG
    MOVFF WREG,OP ;Guarda el primer operando en OP1
    MOVFF PORTA,WREG ;Lo del PORTA lo pasa a WREG
    ANDLW B'00111000' ;Aplica mask2 y guarda en WREG
    RRNCF WREG,0,0
    RRNCF WREG,0,0 ;Rota 3 veces a la derecha los bits de WREG
    RRNCF WREG,0,0
  ;6542 RC Son los que realizan la multiplexion  
  ;0000 Suma <-
  ;0001 Resta <-
  ;0010 Comparación <-
  ;0011 NOT A<-
  ;0100 AND <-
  ;0101 OR
  ;0110 XOR <-
  ;0111 Rotacion Izquierda A <- 
  ;1000 Rotacion Derecha A <-
    BTFSC   LED3	    ;RC6 = 1?
    GOTO    ROTACION_DER    ;SI
    GOTO    LED2OP
    
    
LED2OP
    BTFSS   LED2	    ;RC5 = 1? ;0???
    GOTO    LED1OP	    ;00??   
    BTFSS   LED1	    ;RC4 = 1? ;01??
    GOTO    LEDB0P		    ;010?	
    BTFSS   LED0	    ;RC2 =1?  ;011?
    GOTO    XOR		    ;0110
    GOTO    ROTACION_IZQ    ;0111
    
LED1OP 
     BTFSS  LED1	    ;RC4 = 1? ;00??
     GOTO   LEDAOP	    ;000?
     BTFSS  LED0	    ;RC2= 001?
     GOTO   COMPARACION	    ;0010
     GOTO   NOT		    ;0011
LEDAOP    
     BTFSS  LED0	    ;RC2= 000?
     GOTO   SUMA	    ;0000
     GOTO   RESTA	    ;0001
LEDB0P
     BTFSS  LED0	    ;RC2= 1? ;010?
     GOTO   AND		    ;0100
     GOTO   OR		    ;0101

     
     ;--------------------OPERACIONES------------------------------
SUMA		;FUNCIONA, PROBADA.
    ADDWF	OP,0,0 ;Suma W + OP y lo guarda en W
    MOVFF	WREG,PORTB ;Mueve lo de W a PORTB
    GOTO	MAIN
    
RESTA		;FUNCIONA, PROBADA.
    SUBWF OP,0,0 ;Resta W - OP y lo guarda en W
    MOVFF WREG,PORTB ;Mueve lo de W a PORTB
    GOTO MAIN
    
    
COMPARACION	;FUNCIONA, PROBADA.
    
MAYOR
	CPFSLT  OP,0
	GOTO	MENOR
	MOVLW   .01
	MOVWF	PORTB
	GOTO	MAIN
	
MENOR		
	CPFSGT	OP,0
	GOTO	IGUAL
	MOVLW  .02
	MOVWF	PORTB
	GOTO	MAIN
	
IGUAL		
	MOVLW   .04
	MOVWF	PORTB
	GOTO	MAIN

NOT		;FUNCIONA, PROBADA.
	COMF	OP, WREG,0
	ANDLW	B'00000111'
	MOVWF	PORTB
	GOTO	MAIN
AND		;FUNCIONA, PROBADA.
	ANDWF	OP,0,0  
	MOVWF   PORTB
	GOTO    MAIN
	
OR
	IORWF	OP,WREG,0
	MOVWF   PORTB
	GOTO    MAIN
	
XOR		;FUNCIONA, PROBADA.
	XORWF	OP,WREG,0  
	MOVWF   PORTB
	GOTO    MAIN
	
ROTACION_IZQ	;FUNCIONA, PROBADA.
    MOVFF	OP,W
    ANDLW	B'00000111' ;Aplica mask1 y guarda en WREG
    RLNCF	WREG,0,0
    RLNCF	WREG,0,0 ;Rota 3 veces a la derecha los bits de WREG
    RLNCF	WREG,0,0
    MOVWF	PORTB
    GOTO	MAIN
    
ROTACION_DER    ;FUNCIONA, PROBADA.
    MOVFF	OP,W
    ANDLW	B'00000111' ;Aplica mask1 y guarda en WREG
    RRNCF	WREG,0,0
    RRNCF	WREG,0,0 ;Rota 3 veces a la derecha los bits de WREG
    RRNCF	WREG,0,0
    MOVWF	PORTB
    GOTO	MAIN
  
  END