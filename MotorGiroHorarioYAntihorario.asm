 LIST P=18F4550
    #INCLUDE<P18F4550.INC>

    ORG .0
    GOTO INICIO
    
    #DEFINE V_0    PORTC,RC0,0
   
    
    CBLOCK 0X00
    COPIAMOTOR	
    ENDC


RETARDO
    CLRF TMR0H,0
    CLRF TMR0L,0
    MOVLW H'FE'
    MOVWF TMR0H,0
    MOVLW H'79'
    MOVWF TMR0L,0
ASK
    BTFSS  INTCON, TMR0IF,0
    GOTO   ASK
    BCF	   INTCON,TMR0IF,0
    RETURN
    

 
INICIO
    MOVLW B'10010111'
    MOVWF T0CON,0
    MOVLW H'50'
    MOVWF OSCCON,0
    CLRF    PORTD,0
    CLRF    TRISD,0
    MOVLW   B'11010111'
    MOVWF   T0CON,0
    
MAIN  ;1100 0110    0011    1001
    MOVLW   B'11001100'
    MOVWF   COPIAMOTOR,0
    BTFSS   V_0
    GOTO    ROTAR_L
    GOTO    ROTAR_R

ROTAR_R
    MOVFF   COPIAMOTOR,PORTD
    CALL    RETARDO
    RRNCF   COPIAMOTOR,F,0
    BTFSC   V_0  
    GOTO    ROTAR_L
    GOTO    ROTAR_R    
    
    
ROTAR_L
    MOVFF   COPIAMOTOR,PORTD
    CALL    RETARDO
    RLNCF   COPIAMOTOR,F,0
    BTFSC   V_0
    GOTO    ROTAR_L
    GOTO    ROTAR_R
    END
    


