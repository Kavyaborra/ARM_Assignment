     THUMB
     AREA     exponential, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		    ;function to get e power x 		
         VLDR.F32  S0, = 1		;output
         VLDR.F32  S3, = 0		;to keep tab of number of terms, i
		 VLDR.F32  S2, = 5		;value of x
	     VLDR.F32  S1, = 1		;temp to store each component of series
		 VLDR.F32  S4, = 1

loop	 VADD.F32  S3, S3, S4	; S3 = S3 + 1 
	     VMUL.F32  S1, S1, S2 		; S1 = S1*x
		 VDIV.F32 S1, S1, S3            ; S1 = S1/i
		 VADD.F32  S0, S0,S1		; term added to output
	     B loop			; will keep adding terms to series
     ENDFUNC
     END
