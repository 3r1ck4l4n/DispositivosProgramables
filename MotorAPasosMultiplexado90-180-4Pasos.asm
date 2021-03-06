 LIST P=18F4550
    #INCLUDE<P18F4550.INC>
    
    CBLOCK 0X00
    COPIAMOTOR	
    DATO
    DELAY
    ENDC
    #DEFINE SW_0    PORTC,RC0,0
    #DEFINE SW_1    PORTC,RC1,0 
    ORG .0
    GOTO INICIO   
    
RETARDO_2SEG
   MOVLW    .20
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
    CLRF    PORTB,0
    CLRF    TRISB,0
    MOVLW   B'11010111'
    MOVWF   T0CON,0
MAIN 
    ;INICIO DE MOTOR
    MOVLW   B'11001100'
    MOVWF   COPIAMOTOR,0
    
    ;IF
    BTFSC   SW_0
    GOTO    SW_0_V1
    GOTO    SW_0_V0

SW_0_V0    
    BTFSC   SW_1
    GOTO    CICLO90
    GOTO    RESET_ 
SW_0_V1    
    BTFSC   SW_1		    
    GOTO    CICLO4
    GOTO    CICLO180
    
;RUTINA DE 180�    
CICLO180
    MOVLW   .9
    MOVWF   DATO, 1
OTRA1
    DECFSZ  DATO, F, 1
    GOTO    ROTAR1
    CALL    RETARDO_2SEG
    GOTO    MAIN
    
ROTAR1
    MOVFF   COPIAMOTOR, PORTB
    CALL    RETARDO
    RRNCF   COPIAMOTOR, F, 0
    GOTO    OTRA1
    
;RUTINA DE 90�    
CICLO90
    MOVLW   .5
    MOVWF   DATO, 1
OTRA2
    DECFSZ  DATO, F, 1
    GOTO    ROTAR2
    CALL    RETARDO_2SEG
    GOTO    MAIN
    
ROTAR2
    MOVFF   COPIAMOTOR, PORTB
    CALL    RETARDO
    RRNCF   COPIAMOTOR, F, 0
    GOTO    OTRA2
    
;RUTINA DE 4 PASOS    
CICLO4
    MOVLW   .5
    MOVWF   DATO, 1
OTRA3
    DECFSZ  DATO, F, 1
    GOTO    ROTAR2
    CALL    RETARDO_2SEG
    GOTO    MAIN
    
ROTAR3
    MOVFF   COPIAMOTOR, PORTB
    CALL    RETARDO
    RRNCF   COPIAMOTOR, F, 0
    GOTO    OTRA3
    
RESET_
     MOVLW   B'11001100'
     MOVWF   PORTB, 1
    END


