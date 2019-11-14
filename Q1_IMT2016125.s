     THUMB
     AREA     exponential, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		        ;function to get e power x 		
         VLDR.F32  S0, = 1		;output
         VLDR.F32  S1, = 0		;to keep tab of number of terms, i
		 MOV R0, #0x0      
		 VLDR.F32  S2, = -15		;value of x
	     VLDR.F32  S3, = 1		;temp to store each component of series
		 VLDR.F32  S4, = 1
		 MOV R1,#0x32			    ;total number of terms (50)
		 
check		 ADD R0, R0, #0x1
		         CMP R0,R1			; comapring number of terms with total number
		         BLE loop		 

stop   B stop

loop   VADD.F32  S1, S1, S4	; S1 = S1 + 1 
	     VMUL.F32  S3, S3, S2 		; S3 = S3*x
		 VDIV.F32 S3, S3, S1            ; S3 = S3/i
		 VADD.F32  S0, S0,S3		; term added to output
		 B check
		 

     ENDFUNC
     END
