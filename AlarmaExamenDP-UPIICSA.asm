 ; @AUTHOR SANDRA GUADALUPE MATIAS AGUILAR
    
    LIST P=18F4550
    #INCLUDE<P18F4550.INC>
    
   #DEFINE BUTTON PORTE,RE0,0
   #DEFINE LED PORTD,RD1,0
   ;---- switch	
   #DEFINE SW PORTA,RA0,0
   #DEFINE SW2 PORTA,RA1,0
   ORG .0
   GOTO INICIO

DELAY_100mS
     CLRF TMR0H,0
    CLRF TMR0L,0
    MOVLW H'FE'
    MOVWF TMR0H,0
    MOVLW H'79'
    MOVWF TMR0L,0
ASK
    BTFSS  INTCON, TMR0IF,0
    GOTO   ASK
    BCF       INTCON,TMR0IF,0
    RETURN 
   
INICIO
   ;----------------CONFIG PORTA ---------------------------------------------
    CLRF PORTA, 0
    MOVLW B'00000011'
    ;----------------CONFIG PORTB ---------------------------------------------
    CLRF TRISB,0	;Si TRISB = 0000000, todo PORTB son salidas
    CLRF PORTB,0
    
    ;----------------CONFIG PORTD ----------------------------------------------
    CLRF TRISD,0
    CLRF PORTD    
    ;----------------CONFIG PORTE ----------------------------------------------
   BSF	    TRISE,0,0
   CLRF	    PORTE,0
   ;---------------------------------------------------------------------------
   MOVLW    .15
   MOVWF    ADCON1,0
   
   MOVLW    .7
   MOVWF    CMCON,0
   
  ;CONFIG RETARDO
    MOVLW B'10010111'
    MOVWF T0CON,0
    MOVLW H'50'
    MOVWF OSCCON,0

MAIN
   CLRF TRISD,0
   BSF	LED
   BTFSS    SW ;SW=PUERTA CERRADA? 1=SI 0=NO.
   GOTO	    MAIN
   BTFSS    SW2 ;SW2= PUERTA OFICINA CERRDADA? 1=SI 0= NO
   GOTO MAIN
   GOTO ALARMA
   
ALARMA
   
   BTFSS    BUTTON
NO GOTO	    MAIN
SI GOTO	    ALARMAACTIVA
   
ALARMAACTIVA  
   MOVLW    B'11110101'
   MOVFF    WREG,PORTD
   BTFSS    SW ;SW=PUERTA CERRADA? 1=SI 0=NO.
   GOTO	    VIOLACIONALARMA
   BTFSS    SW2 ;SW2= PUERTA OFICINA CERRDADA? 1=SI 0= NO
   GOTO	    VIOLACIONALARMA
   GOTO	    ALARMAACTIVA
   
VIOLACIONALARMA  
   CALL	    RESPUESTA
   CALL	    DELAY_100mS
   CALL	    RESPUESTA
   CALL	    DELAY_100mS
   BTFSS    BUTTON
   GOTO	    VIOLACIONALARMA  
WAIT  
   CALL	    RESPUESTA
   CALL	    DELAY_100mS
   CALL	    RESPUESTA
   CALL	    DELAY_100mS
   BTFSS    BUTTON
   GOTO	    WAIT 
   GOTO MAIN
   
RESPUESTA
   BTG	    LED
   RETURN
   
   
   
   END