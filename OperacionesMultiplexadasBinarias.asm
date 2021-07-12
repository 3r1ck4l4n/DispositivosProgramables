   
    LIST P=18f4550
    #include<P18F4550.INC>


#DEFINE LED0 PORTC,0,0
#DEFINE LED1 PORTC,1,0 
  
#DEFINE OP 0x07
    
    ORG 0
    
CONFIGURAR
;----------------CONFIG PORTA ---------------------------------------------
    MOVLW B'00111111'	;W=00111111
    MOVWF TRISA,0	;TRISA=00111111
			;Y LOS PINES DE PORTA == SSEEEEEE

    MOVLW H'07'		;W=00000111
    MOVWF CMCON,0	;COMCON = 7 Y EL COMPARADOR DE VOLTAJES

    MOVLW H'0F'		;Se asigna valor de 15
    MOVWF ADCON1,0	;ADCON1 = 15 = todo digital

    CLRF PORTA,0
;----------------CONFIG PORTC ---------------------------------------------
    MOVLW B'00000011'	
    MOVWF TRISC,0	
;----------------CONFIG PORTB ---------------------------------------------
    CLRF TRISB,0	;Si TRISB = 0000000, todo PORTB son salidas
    CLRF PORTB,0

	
MAIN	    MOVFF PORTA,WREG	    ;Lo del PORTA lo pasa a WREG
	    ANDLW B'00000111'	    ;Aplica mask1 y guarda en WREG
	    MOVFF WREG,OP	    ;Guarda el primer operando en OP1
    
	    MOVFF PORTA,WREG	    ;Lo del PORTA lo pasa a WREG
	    ANDLW B'00111000'	    ;Aplica mask2 y guarda en WREG
	    RRNCF WREG,0,0	 
	    RRNCF WREG,0,0	    ;Rota 3 veces a la derecha los bits de WREG
	    RRNCF WREG,0,0
	    
	    BTFSC LED0		    ;RC0 =? 0
	    GOTO LEDoV1
	    GOTO LEDoV0
	    
LEDoV0    BTFSC LED1		    ;RC1 =? 0    
	    GOTO SUMA
	    GOTO APAGAR
	    
LEDoV1    BTFSC LED1		    ;RC1 =? 0
	    GOTO MULTIPLICA
	    GOTO RESTA
	    
APAGAR    CLRF PORTB
	    GOTO MAIN
	    
SUMA	    ADDWF OP,0,0	    ;Suma W + OP y lo guarda en W
	    MOVFF WREG,PORTB	    ;Mueve lo de W a PORTB
	    GOTO MAIN
	    
RESTA	    SUBWF OP,0,0	    ;Resta W - OP y lo guarda en W
	    MOVFF WREG,PORTB	    ;Mueve lo de W a PORTB
	    GOTO MAIN  
	    
MULTIPLICA  MULWF OP,0		    ;Multiplica W * OP y lo guarda en PRODL
	    MOVFF PRODL,PORTB	    ;Mueve lo de PRODL a PORTB
	    GOTO MAIN 
	    

    END


