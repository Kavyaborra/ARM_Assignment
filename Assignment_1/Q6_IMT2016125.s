     THUMB
     AREA     fibonacci, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         MOV  R0, #0xA	;number A
         MOV  R1, #0x8	;number B
		 
loop	 CMP  R0, R1    	;compares A and B
		 SUBGT R0, R1  	;A = A - B
		 SUBLT R1, R0		;B = B - A
	 	 BNE loop		 		;loop continues till A = B, resultant GCD stored in R0
		 
stop	 B stop 
     ENDFUNC
     END
