LIST P=18f4550
    #include<P18F4550.INC>
    
    #DEFINE LED0 PORTC,RC4
    #DEFINE LED1 PORTC,RC5
    #DEFINE LED2 PORTC,RC6
    #DEFINE LED3 PORTC,RC7
    
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
    CLRF    PORTC
    MOVLW   B'11110000'
    SETF   TRISC,0
;----------------CONFIG PORTB ---------------------------------------------
    CLRF PORTB,0
    CLRF TRISB,0 ;Si TRISB = 0000000, todo PORTB son salidas
    ;----------------CONFIG PORTD ---------------------------------------------
    CLRF PORTD,0
    CLRF TRISD,0 ;Si TRISB = 0000000, todo PORTB son salidas
    
MAIN 
    MOVFF PORTA,WREG ;Lo del PORTA lo pasa a WREG
    ANDLW B'00000111' ;Aplica mask1 y guarda en WREG
    MOVFF WREG,OP ;Guarda el primer operando en OP1
    MOVFF PORTA,WREG ;Lo del PORTA lo pasa a WREG
    ANDLW B'00111000' ;Aplica mask2 y guarda en WREG
    RRNCF WREG,0,0
    RRNCF WREG,0,0 ;Rota 3 veces a la derecha los bits de WREG
    RRNCF WREG,0,0
 
 
  
    BTFSS   LED0	    ;RC4 = 1?
    GOTO    LEDoV0	    ;NO
    GOTO    ROTACION_DER    ;SI
  
;--------RC4=0,	RC5=?
LEDoV0 
    BTFSS   LED1	    ;RC5=1? 
    GOTO    LEDoV1	    ;NO: RC5=0 
    BTFSS   LED2	    ;SI  RC4=0, RC5=1, RC6=1?
    GOTO    LEDoV3	    ;NO  RC4=0, RC5=1, RC6=0, 
    BTFSS   LED3	    ;SI  RC4=0, RC5=1, RC6=1, RC7=1?
    GOTO    XOR		    ;NO  RC4=0, RC5=1, RC6=1, RC7=0
    GOTO    ROTACION_IZQ    ;SI  RC4=0, RC5=1, RC6=1, RC7=1
    
;--------RC4=0,	RC5=0, RC6=?
LEDoV1 
    BTFSS   LED2	;RC6=1? 
    GOTO    LEDoV2	;NO RC4=0, RC5=0, RC6=0
    BTFSS   LED3	;SI RC4=0, RC5=0, RC6=1, RC7=1?
    GOTO    COMPARA	;NO RC4=0, RC5=0, RC6=1, RC7=0
    GOTO    NOT		;SI RC4=0, RC5=0, RC6=1, RC7=1
    
;--------RC4=0,	RC5=0, RC6=0, RC7?    
LEDoV2
    BTFSS   LED3    ;RC7=1? 
    GOTO    SUMA    ;NO	RC4=0, RC5=0, RC6=0, RC7=0
    GOTO    RESTA   ;SI	RC4=0, RC5=0, RC6=0, RC7=1
    
;--------RC4=0,	RC5=1, RC6=0, RC7=?  
LEDoV3 
    BTFSS   LED3    ;RC7=1? 
    GOTO    AND	    ;NO	RC4=0, RC5=1, RC6=0, RC7=0
    GOTO    OR	    ;SI	RC4=0, RC5=1, RC6=0, RC7=1

SUMA 
    ADDWF OP,0,0 ;Suma W + OP y lo guarda en W
    MOVFF WREG,PORTB ;Mueve lo de W a PORTB
    GOTO MAIN

RESTA 
    SUBWF OP,0,0 ;Resta W - OP y lo guarda en W
    MOVFF WREG,PORTB ;Mueve lo de W a PORTB
    GOTO MAIN

COMPARA
    MAYOR
	CPFSLT  OP,0
	GOTO MENOR
	MOVLW   '00000001'
	MOVWF	PORTB
	GOTO MAIN
    MENOR
	CPFSGT	OP,0
	GOTO IGUAL
	MOVLW   '00000001'
	MOVWF	PORTB
	GOTO MAIN
    IGUAL
	MOVLW   '00000100'
	MOVWF	PORTB
	GOTO MAIN
       
    
IGUAL
    CPFSEQ  PORTD
    GOTO    MENOR
    MOVLW   B'0000001'
    MOVWF   PORTB
    GOTO    MAIN

MENOR
    CPFSLT  PORTD   
    GOTO    MAYOR
    MOVLW   B'0000010'
    MOVWF   PORTB
    GOTO    MAIN
MAYOR
    MOVLW   B'0000100'
    MOVWF   PORTB
    GOTO    MAIN
    
AND
    MOVFF    PORTA,W
    ANDWF   PORTB,W
    MOVWF   PORTD
    GOTO    MAIN
    
OR
   MOVFF    PORTA,W
   IORWF   PORTB,W
   MOVWF   PORTD
   GOTO    MAIN
    
XOR
  MOVFF   PORTA,W
  XORWF   PORTB,W
  MOVWF   PORTD
  GOTO    MAIN
  
NOT
  COMF    PORTA,W
  MOVWF   PORTD
  GOTO    MAIN
  
ROTACION_IZQ
  MOVFF    PORTA,W
  RLNCF	  WREG,F
  MOVWF   PORTD
  GOTO    MAIN
  
ROTACION_DER
  MOVFF    PORTA,W
  RRNCF	  WREG,F
  MOVWF   PORTD
  GOTO    MAIN


  END