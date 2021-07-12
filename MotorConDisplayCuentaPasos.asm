    LIST P=18F4550
    #INCLUDE<P18F4550.INC>
    
    
    #DEFINE BUTTON PORTE,RE0,0
    
    
    CBLOCK 0X00
    TOPE
    COPIAMOTOR	
    DATO
    DELAY
    ENDC

    ;Definir numeros-----------------
		      ;GFABECD
    #DEFINE NONE     B'11111111'
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
    
    ORG .0
    GOTO INICIO
    
SALIDA
    ADDWF   PCL,1,0	;PCL = WREG + PCL 
    DT NONE, NUEVE, OCHO, SIETE, SEIS, CINCO, CUATRO, TRES, DOS,UNO,CERO
    
RETARDO_1SEG
   MOVLW    .10
   MOVWF    DELAY,1
MAS   
   CALL	    RETARDO
   DECFSZ   DELAY,F,1
   GOTO	    MAS
   RETURN
   
RETARDO
    CLRF    TMR0L,0
    MOVLW   .95
ASK
    CPFSEQ  TMR0L,0
    BRA	    ASK
    RETURN    
    
INICIO
    CLRF    PORTD,0
    CLRF    TRISD,0
    MOVLW   B'11010111'
    MOVWF   T0CON,0
    BSF	    TRISE,0,0
    CLRF    PORTE,0
    MOVLW H'07'		;W=00000111				    
    MOVWF CMCON,0	;COMCON = 7 Y EL COMPARADOR DE VOLTAJES	    
    MOVLW H'0F'		;Se asigna valor de 15			   
    MOVWF ADCON1,0	;ADCON1 = 15 = todo digital
    
    CLRF TRISB,0				    
    CLRF PORTB,0
    MOVLW   .11
    MOVWF   TOPE,0
    CALL    DISPLAY
MAIN 
    ;INICIO DE MOTOR
    MOVLW   B'11001100'
    MOVWF   COPIAMOTOR,0
    
    ;------------------BUTTON
BUTTON_ACTION 
   BTFSS    BUTTON
NO GOTO	    BUTTON_ACTION
SI CALL	    RETARDO
   BTFSC    BUTTON
   GOTO	    SI
   GOTO	    CICLO
 
;RUTINA DE 360�    
CICLO
    MOVLW   .17
    MOVWF   DATO, 1
    CALL    DISPLAY
OTRA
    DECFSZ  DATO, F, 1
    GOTO    ROTAR
    CALL    RETARDO_1SEG
    GOTO    MAIN
    
ROTAR
    MOVFF   COPIAMOTOR, PORTB
    CALL    RETARDO
    RRNCF   COPIAMOTOR, F, 0
    GOTO    OTRA

DISPLAY
    DCFSNZ  TOPE,F,0
    GOTO    INICIO
    MOVFF   TOPE,WREG 
    MULLW   B'00000010'	    ;Se multiplica por dos a Wreg	  
    MOVFF   PRODL,WREG	    			
    CALL    SALIDA	    ;Pasa a la subrutina 
    MOVFF   WREG,PORTD
    RETURN
    END