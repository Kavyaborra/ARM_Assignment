     THUMB
     AREA     circle, CODE, READONLY
     EXPORT __main
     IMPORT printMsg
	 IMPORT printMsg2p
	 IMPORT printMsg4p
	 ENTRY 
__main  FUNCTION		        ;function to get points of circle with a given centre and radius 		
		 VLDR.F32 S0, = 100		;radius = 100 pix
		 VLDR.F32 S1, = 350		;centre x coordinate, a
		 VLDR.F32 S2, = 250		;centre y coordinate, b
		 MOV R11,#0x64			;total number of terms in the infinite series (100) 
		 MOV R9,#0x168			;max theta 360 degrees in hex
		 MOV R10,#0x0				;theta value (1-360)
		 VLDR.F32 S14, =0		;count variable k for the angle
		 VLDR.F32  S11, = 1
		 VLDR.F32  S17, = 0.0174532		;1 degree = pi/180 = 0.0174532
		 
acheck		 ADD R10, R10, #0x1		;increments the angle
				 CMP R10, R9				;checks if angle = 360
				 BLE loop						;if angle<= 360, branch to loop

stop   B stop

loop     VADD.F32 S14, S14, S11		;increment count variable k
		   VMUL.F32 S12, S17, S14	    ;new theta = 0.0174*k
		   VMOV.F32  S4, S12		        ;S4 as temp to store each term of sin series, initial value = theta
		   VLDR.F32  S5, = 1      			;S5 as temp to store each term of cos series. initial value = 1
		   VMOV.F32 S9, S4					;initial sin(theta) = theta
		   VMOV.F32 S10, S5				;initial cos(theta) = 1
		   VNMUL.F32 S13, S12, S12   	;-(theta^2)
		   MOV R12, #0x1      				;count variable i (1-100)
		   VLDR.F32  S3, = 1					;to keep tab of number of terms, i
		   BL sin									;sin subroutine --> S9 now has sin(theta)
		   MOV R12, #0x1      				;count variable i (1-100)
		   VLDR.F32  S3, = 1					;to keep tab of number of terms, i
		   BL cos									;cos subroutine --> S10 now has cos(theta)
		   VMUL.F32 S9,S9,S0				;S9 = r*sin(theta)
		   VMUL.F32 S10,S10,S0			;S10 = r*cos(theta)
		   VADD.F32 S10,S10,S1			;S10 = r*cos(theta) + centre x coordinate
		   VADD.F32 S9,S9,S2				;S9 = r*sin(theta) + centre y coordinate
		   VCVTR.U32.F32 S15,S9			;converting the final coordinates from floating point to integer
		   VCVTR.U32.F32 S16,S10
		   VCVTR.U32.F32 S18,S0
		   VMOV.F32 R0,S18					;radius in R0	
		   MOV R1,R10							;theta value(degrees) in R1		   
		   VMOV.F32 R2,S16 				;x coordinate in R2 
		   VMOV.F32 R3,S15					;y coordinate in R3
		   BL printMsg4p
	       B acheck
				 
sin       VADD.F32 S3, S3, S11		;i = i + 1 
		   VADD.F32 S6, S3, S3		;S6 = 2*i
		   VSUB.F32 S6, S6, S11		;S6 = 2*i - 1
		   VSUB.F32 S7, S6, S11 		;S7 = 2*i - 2
		   VMUL.F32  S4, S4, S13 		;tempsin = tempsin * -1 * theta^2
		   VDIV.F32 S4, S4, S6			;tempsin = tempsin/2*i - 1
		   VDIV.F32 S4, S4, S7			;tempsin = tempsin/2*i - 2
		   VADD.F32  S9, S9, S4		;sin = sin + tempsin
		   ADD R12, R12, #0x1			;increment count variable i
           CMP R12,R11			 		;comparing number of terms with total number(100)
		   BLE sin
		   BX lr
		   
cos      VADD.F32 S3, S3, S11		;i = i + 1 
		   VADD.F32 S6, S3, S3		;S6 = 2*i
		   VSUB.F32 S6, S6, S11		;S6 = 2*i - 1
		   VSUB.F32 S7, S6, S11 		;S7 = 2*i - 2
		   VSUB.F32 S8, S7, S11 		;S8 = 2*i - 3
		   VMUL.F32  S5, S5, S13 		;tempcos = tempcos * -1 * theta^2
		   VDIV.F32 S5, S5, S7			;tempcos = tempcos/2*i - 2
		   VDIV.F32 S5, S5, S8			;tempcos = tempcos/2*i - 3
		   VADD.F32 S10, S10, S5		;cos = cos + tempcos
		   ADD R12, R12, #0x1	 		;increment count variable i
           CMP R12,R11			 		;comparing number of terms with total number(100)
		   BLE cos
		   BX lr
		   
     ENDFUNC
     END
