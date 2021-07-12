;Circuito: Decodificador de circuito aritmetico multiplexado (2 bit).
    LIST P=18F4550
    #INCLUDE<P18F4550.INC>
    
     ;DECODIFICACION
		      ;GFABECD
    #DEFINE CERO     B'11000000'
    #DEFINE UNO      B'11110101'
    #DEFINE DOS	     B'10100010'
    #DEFINE TRES     B'10100100'
    #DEFINE CUATRO   B'10010101'
    #DEFINE CINCO    B'10001100'
    #DEFINE SEIS     B'10001000'
    #DEFINE SIETE    B'11100101'
    #DEFINE OCHO     B'10000000'
    #DEFINE NUEVE    B'10000101'
    
    #DEFINE OP1	    0x09
    #DEFINE SW_0    PORTC,RC0,0
    #DEFINE SW_1    PORTC,RC1,0 
    #DEFINE _N	    STATUS,N,0
   
    ORG 0
    GOTO CONFIGURAR	;PC=0
    
DECODIFICAR
    ADDWF   PCL,1,0	;PCL = WREG + PCL 
    DT CERO,UNO,DOS,TRES,CUATRO,CINCO,SEIS,SIETE,OCHO,NUEVE
    
CONFIGURAR
;**** CONFIGURAR PORTA ***** 
    MOVLW B'00001111'	                                
    MOVWF TRISA,0	;PORTA = SSSSEEEE				    
								    

    MOVLW H'07'		;W=00000111				    
    MOVWF CMCON,0	;COMCON = 7 Y EL COMPARADOR DE VOLTAJES	    

    MOVLW H'0F'		;Se asigna valor de 15			   
    MOVWF ADCON1,0	;ADCON1 = 15 = todo digital		    

    CLRF PORTA,0	;
;**** CONFIGURAR PORTB *****
    CLRF TRISB,0	;Si TRISB = 0000000, todo PORTB son salidas
    CLRF PORTB,0
;*****CONFIG PORTD *****
    CLRF TRISD,0				    
    CLRF PORTD,0	
    
;----------------CONFIG PORTC ---------------------------------------------
    MOVLW B'0011'	
    MOVWF TRISC,0
    CLRF PORTC,0
;--------------------------------------------------------------------------
CALCULAR    
    BTFSC   SW_0		    
    GOTO    SW_0_V1
    GOTO    SW_0_V0
	    
SW_0_V0    
    BTFSC   SW_1
    GOTO    SUMA
    GOTO    APAGAR
	    
SW_0_V1    
    BTFSC   SW_1		    
    GOTO    MULTIPLICA
    GOTO    RESTA
	    
APAGAR   
    MOVLW   H'FF'
    MOVFF   WREG,PORTD
    GOTO    MAIN
	    
SUMA	    
    ADDWF   OP1,0,0	    ;Suma W + OP1 y lo guarda en W
    GOTO    RESULTADO
	    
RESTA
    SUBWF   OP1,1,0	    ;Resta W - OP1 y lo guarda en OP1
    
    
    BTFSC   _N		    ;STATUS N = 0??
    BCF	    PORTB,0,0	    ;Prende led
    
    BTFSC   _N		    ;STATUS N = 0??
    NEGF    OP1,0	    ;NO, ES NEGATIVO, SACO COMPLEMENTO
    MOVFF   OP1,WREG	    ;SI, ES POSITIVO, LO REGRESO A WREG
    
    GOTO    RESULTADO 
    
MULTIPLICA  
    MULWF   OP1,0	    ;Multiplica W * OP1 y lo guarda en PRODL
    MOVFF   PRODL,WREG	    ;Mueve lo de PRODL a WREG
    GOTO    RESULTADO 
    
RESULTADO
    MULLW   B'00000010'	    ;Se multiplica por dos a Wreg	  
    MOVFF   PRODL,WREG	    			
    CALL    DECODIFICAR	    ;Pasa a la subrutina    					   
    MOVFF   WREG,PORTD
    GOTO    MAIN
       
MAIN
    BSF	    PORTB,0,0	    ;Apaga led
    MOVFF   PORTA,WREG	    ;Lo del PORTA lo pasa a WREG
    ANDLW   B'00000011'	    ;Aplica mask1 y guarda en WREG
    MOVFF   WREG,OP1	    ;Guarda el primer operando en OP1
    MOVFF   PORTA,WREG	    ;Lo del PORTA lo pasa a WREG
    ANDLW   B'00001100'	    ;Aplica mask2 y guarda en WREG
    RRNCF   WREG,0,0	 
    RRNCF   WREG,0,0
    GOTO    CALCULAR	    					   
    END