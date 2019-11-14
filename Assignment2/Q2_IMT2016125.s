     THUMB
     AREA     exponential, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		        ;function to get tanx 		
         VLDR.F32  S1, = 1		;to keep tab of number of terms, i
		 MOV R0, #0x1      
		 VLDR.F32  S12, = 1
		 VLDR.F32  S2, = 3.1415		;pi value
		 VLDR.F32  S11, = -0.25
		 VMUL.F32 S2, S2, S11			;value of x (0, pi/4, pi/2, ...)
	     VMOV.F32  S3, S2		        ;S3 as temp to store each term of sin series, initial value = x
		 VLDR.F32  S4, = 1      			;S4 as temp to store each term of cos series. initial value = 1
		 MOV R1,#0x64						;total number of terms (100) 
         VMOV.F32 S0, S2				;output(tanx) initial value = x
		 VMOV.F32 S9, S3				;initial sinx = x
		 VMOV.F32 S10, S4				;initial cosx = 1

		 VNMUL.F32 S5, S2, S2   		;-(x^2)

check		 ADD R0, R0, #0x1
		         CMP R0,R1			;comparing number of terms with total number
		         BLE loop	
				 
		 
stop   B stop

loop     VADD.F32  S1, S1, S12		;i = i + 1 
		   VADD.F32 S6, S1, S1		;S6 = 2*i
		   VSUB.F32 S6, S6, S12		;S6 = 2*i - 1
		   VSUB.F32 S7, S6, S12 		;S7 = 2*i - 2
		   VSUB.F32 S8, S7, S12 		;S8 = 2*i - 3
	       VMUL.F32  S3, S3, S5 		;tempsin = tempsin * -1 * x^2
		   VDIV.F32 S3, S3, S6			;tempsin = tempsin/2*i - 1
		   VDIV.F32 S3, S3, S7			;tempsin = tempsin/2*i - 2
		   VMUL.F32  S4, S4, S5 		;tempcos = tempcos * -1 * x^2
		   VDIV.F32 S4, S4, S7			;tempcos = tempcos/2*i - 2
		   VDIV.F32 S4, S4, S8			;tempcos = tempcos/2*i - 3
		   VADD.F32  S9, S9, S3		;sinx = sinx + tempsinx
		   VADD.F32 S10, S10, S4		;cosx = cosx + tempcosx
		   VDIV.F32 S0, S9, S10		;tanx = sinx/cosx
		   B check
		 

     ENDFUNC
     END
