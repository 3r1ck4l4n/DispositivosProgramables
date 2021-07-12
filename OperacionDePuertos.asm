;Multiplicacion de PA * PD
    
LIST P=18f4550
    #include<P18F4550.INC>
  
    #DEFINE OP 0x07
    ORG	.0
    
SETTINGS
  ;----------------CONFIG PORTA ---------------------------------------------
    MOVLW B'00111000'	;W=00111111
    MOVWF TRISA,0	;TRISA=00111000
			;Y LOS PINES DE PORTA == SSEEESSS

    MOVLW H'07'		;W=00000111
    MOVWF CMCON,0	;COMCON = 7 Y EL COMPARADOR DE VOLTAJES

    MOVLW H'0F'		;Se asigna valor de 15
    MOVWF ADCON1,0	;ADCON1 = 15 = todo digital

    CLRF PORTA,0
  ;----------------CONFIG PORTD ---------------------------------------------
    MOVLW B'00000111'	;W=00000111
    MOVWF TRISD,0	;TRISD=00000111
			;Y LOS PINES DE PORTD == SSSSSEEE
    CLRF PORTD,0			
 
    ;----------------CONFIG PORTB ---------------------------------------------
    CLRF TRISB,0    ;TRISB=00000000 PB= SSSSSSSS
    CLRF PORTB,0    ;PORTB=00000000
    
 MAIN
    
    MOVFF PORTD,D1 ;D1 = PA
    MOVLW B'00000111' ;SE ASIGNA LA MASK A W
    ANDWF D1,F,1
    
    MOVFF PORTA,D2
    MOVLW B'00111000'
    ANDWF D2,F,1
    
    RRNCF D2,F,1    ;Rotaciones para obtener un numero de 3 bits (Del 0 al 7)
    RRNCF D2,F,1
    RRNCF D2,F,1
    
    MOVF D1,WREG,1	;WREG = D1 
    MULWF D2,1		;WREG * D2
    MOVFF PRODL,PORTB	;Salida de PRODL en PORTB
    GOTO MAIN
    END

    END


