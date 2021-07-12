  ;Los diez bits resultados de la conversion AD de la señal
    ;que ingresa por canal AN0 se muetran en portb(ADRESL) y portc (ADRESH)
    
    LIST P=18F4550
    #INCLUDE<P18F4550.INC>
    
    #DEFINE LED PORTD,RD0,0
    
    ORG .0
    
INICIO
    CLRF    PORTA,0
    BSF	    TRISA,AN0,0
    
    CLRF    PORTB,0
    CLRF    TRISB,0
    
    CLRF    PORTC,0
    CLRF    TRISC,0
    
    CLRF    PORTD,0
    CLRF    TRISD,0
    
    MOVLW   .7
    MOVWF   CMCON,0
    
    MOVLW   B'00000001'
    MOVWF   ADCON0,0
    
    MOVLW   B'00001110'
    MOVWF   ADCON1,0
    
    MOVLW   B'10001111'
    MOVWF   ADCON2,0
    
MAIN
    BSF	    ADCON0,GO_DONE,0	;GO PARA EL CAD
ASK
    BTFSC   ADCON0,GO_DONE,0	;TERMINO
    GOTO    ASK
    MOVFF   ADRESL,PORTB
    MOVFF   ADRESH,PORTC
    
    MOVLW   B'00000011'
    CPFSEQ  ADRESH
    GOTO    COM
    GOTO    ENCENDER

COM    
    MOVLW   B'11001100'
    CPFSLT  ADRESL
    GOTO    AL
    GOTO    APAGAR
    
AL    
    MOVLW   B'00000010'	    	  
    CPFSLT  ADRESH
    GOTO    ENCENDER
    GOTO    APAGAR
   
    
ENCENDER
    BSF	    LED
    GOTO    MAIN
    
APAGAR
    BCF	    LED
    GOTO    MAIN
    
    END


