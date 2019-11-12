     THUMB
     AREA     tan, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		    ;function to get tanx 		
         VLDR.F32  S0, = 1		;output
         VLDR.F32  S1, = 0		;to keep tab of number of terms, i
		 MOV R0, #0x0      
		 VLDR.F32  S2, = 0.7853		;value of x
	     VLDR.F32  S3, = 1		;temp to store each component of series
		 VLDR.F32  S4, = 1
		 VLDR.F32  S5, = 2
		 MOV R1,#0x100			;total number of terms 
		 
		 VMUL.F32 S2, S2, S5   ; x --> 2*x

check		 ADD R0, R0, #0x1
		         CMP R0,R1			; comparing number of terms with total number
		         BLE loop	
				 
		 VADD.F32 S6, S0, S4 ;exp(2x) + 1
		 VSUB.F32 S7, S0, S4 ;exp(2x) - 1
		 VDIV.F32 S0, S7, S6  ; tanx = [exp(2x)-1 ]/ [exp(2x) + 1]
		 
stop   B stop

loop   VADD.F32  S1, S1, S4	; S1 = S1 + 1 
	       VMUL.F32  S3, S3, S2 		; S3 = S3*x
		   VDIV.F32 S3, S3, S1            ; S3 = S3/i
		   VADD.F32  S0, S0,S3		; term added to output
		   B check
		 

     ENDFUNC
     END
