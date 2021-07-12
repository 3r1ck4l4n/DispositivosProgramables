;Circuito combinacional.
    LIST P=18F4550
    #INCLUDE<P18F4550.INC>
    
     ;DECODIFICACION
		      ;GFABECD
    #DEFINE CERO    B'00000010'
    #DEFINE UNO     B'00000001'
    #DEFINE DOS	    B'00000001'
    #DEFINE TRES    B'00000001'
    #DEFINE CUATRO  B'00000010'
    #DEFINE CINCO   B'00000000'
    #DEFINE SEIS    B'00000000'
    #DEFINE SIETE   B'00000000'
    #DEFINE OCHO    B'00000010'
    #DEFINE NUEVE   B'00000000'
    #DEFINE DIEZ    B'00000000'
    #DEFINE ONCE    B'00000000'
    #DEFINE DOCE    B'00000010'
    #DEFINE TRECE   B'00000010'
    #DEFINE CATORCE B'00000010'
    #DEFINE QUINCE  B'00000010'
   
    
    ORG 0
    GOTO CONFIGURAR	;PC=0
    
DECODIFICAR
    ADDWF   PCL,1,0	;PCL = WREG + PCL 
    DT CERO, UNO, DOS, TRES, CUATRO, CINCO, SEIS, SIETE,OCHO
    DT NUEVE, DIEZ, ONCE, DOCE, TRECE, CATORCE, QUINCE
    
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

MAIN
   
    MOVFF   PORTA,WREG	    ;Lo del PORTA lo pasa a WREG
    ANDLW   B'00001111'	    ;Aplica mask1 y guarda en WREG
       
    
RESULTADO
    MULLW   B'00000010'	    ;Se multiplica por dos a Wreg	  
    MOVFF   PRODL,WREG	    			
    CALL    DECODIFICAR	    ;Pasa a la subrutina    					   
    MOVFF   WREG,PORTB
    GOTO    MAIN
       
    					   
    END


