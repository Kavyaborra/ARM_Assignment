     THUMB
	 PRESERVE8
     AREA     logic_neural, CODE, READONLY
     EXPORT __main
	 IMPORT print_inputs
	 IMPORT printout
	 ENTRY 
__main  FUNCTION		        ;to implement logic gates using a neural net
		 MOV R1, #1					;input A
		 MOV R2, #1					;input B
		 MOV R3, #0					;input C
		 MOV R4, #5 				;1-7 to choose the logic operation (5 means XNOR)
		
		;number in R4:
		;1 - AND
		;2 - OR
		;3 - NOT
		;4 - XOR
		;5 - XNOR
		;6 - NAND
		;7 - NOR
		 
		 
		 VMOV.F32 S1, R1
		 VCVT.F32.U32  S1, S1		;converting the inputs to floating point into S1 S2 S3
		 VMOV.F32 S2, R2
		 VCVT.F32.U32  S2, S2
		 VMOV.F32 S3, R3
		 VCVT.F32.U32  S3, S3
		 VLDR.F32  S15, = 1
		 VLDR.F32  S16, = 0.5		;thershold for sigmoid output
					
C1	 CMP R4, #1						;switch case to choose between the logic gates
		 BNE  C2
		 BL logic_AND					;result stored in R0 and moved to R5 after printing 
		 B print
C2     CMP R4, #2
		 BNE  C3
		 BL logic_OR
		 B print
C3	 CMP R4, #3
		 BNE  C4
		 BL logic_NOT
		 B print
C4	 CMP R4, #4
		 BNE  C5
		 BL logic_XOR
		 B print
C5	 CMP R4, #5
		 BNE  C6
		 BL logic_XNOR
		 B print
C6	 CMP R4, #6
		 BNE  C7
		 BL logic_NAND
		 B print
C7	 CMP R4, #7
		 BNE  C2
		 BL logic_NOR
		 B print
		 
print	 MOV R5,R0			;so that output is not lost
		 BL printout			;to print the output
		 ENDFUNC

;Function to implement logic AND gate
logic_AND		FUNCTION
					PUSH{LR}
					VLDR.F32 S4, = -0.6		;bias
					VLDR.F32 S5, = 0.2		;W1
					VLDR.F32 S6, = 0.3		;W2
					VLDR.F32 S7, = 0.2		;W3
					VMOV.F32 S0, S4			;S0 = bias
					VFMA.F32 S0, S5, S1	;S0 = bias + W1*A
					VFMA.F32 S0, S6, S2	;S0 = bias + W1*A + W2*B
					VFMA.F32 S0, S7, S3	;S0 = bias + W1*A + W2*B + W2*C
					BL sig							;calls the sigmoid function --> result in S0
					VCMP.F32 S0, S16		;checks if result is >0.5
					VMRS APSR_nzcv, FPSCR	;to convert FPSCR to APSR to use the flags LT,GT, etc
					MOVLE R0, #0				;output = 0 if sig(bias + W1*A + W2*B + W2*C ) < 0.5
					MOVGT R0, #1				;output = 1 if sig(bias + W1*A + W2*B + W2*C ) > 0.5
					POP{LR}
				    BX lr					
					ENDFUNC

;Function to implement logic OR gate
logic_OR		FUNCTION
					PUSH{LR}
					VLDR.F32 S4, = -0.1		;implementation similar to AND with different weights
					VLDR.F32 S5, = 0.2
					VLDR.F32 S6, = 0.2
					VLDR.F32 S7, = 0.2
					VMOV.F32 S0, S4
					VFMA.F32 S0, S5, S1
					VFMA.F32 S0, S6, S2
					VFMA.F32 S0, S7, S3
					BL sig
					VCMP.F32 S0, S16
					VMRS APSR_nzcv, FPSCR
					MOVLE R0, #0
					MOVGT R0, #1
					POP{LR}
				    BX lr
					ENDFUNC
					
;Function to implement logic NOT gate for the first input (R1/S1)
logic_NOT		FUNCTION
					PUSH{LR}
					VLDR.F32 S4, = 0.1
					VLDR.F32 S5, = -0.2
					VMOV.F32 S0, S4
					VFMA.F32 S0, S5, S1
					BL sig
					VCMP.F32 S0, S16
					VMRS APSR_nzcv, FPSCR
					MOVLE R0, #0
					MOVGT R0, #1
					POP{LR}
				    BX lr
					ENDFUNC
					
;Function to implement logic XOR gate		
;cannot use direct weights on the three inputs, layers/stages required

;A xor B xor C = ABC + (~A)BC + A(~B)C + AB(~C)

;xor( A B C ) = or( (and( A B C )) (and (not(A) B C)) (and (A not(B) C)) (and (A B not(C))))

logic_XOR	FUNCTION
					PUSH{LR}
					BL logic_NOT
					VMOV.F32 S6, R0			
					VCVT.F32.U32 S6, S6		;S6 = ~A
					VMOV.F32 S1, S2
					BL logic_NOT
					VMOV.F32 S7, R0
					VCVT.F32.U32 S7, S7		;S7 = ~B
					VMOV.F32 S1, S3		
					BL logic_NOT
					VMOV.F32 S8, R0
					VCVT.F32.U32 S8, S8		;S8 = ~C
					VMOV.F32 S1, S6
					BL logic_AND
					VMOV.F32 S6, R0				
					VCVT.F32.U32 S6, S17		;S17 = (~A)BC
					VMOV.F32 S1, R1	
					VCVT.F32.U32 S1, S1
					VMOV.F32 S2, S7
					BL logic_AND
					VMOV.F32 S7, R0				
					VCVT.F32.U32 S7, S18		;S18 = A(~B)C
					VMOV.F32 S2, R2
					VCVT.F32.U32 S2, S2
					VMOV.F32 S3, S8
					BL logic_AND
					VMOV.F32 S8, R0
					VCVT.F32.U32 S8, S19		;S19 = AB(~C)
					VMOV.F32 S3, R3
					VCVT.F32.U32 S3, S3
					BL logic_AND
					VMOV.F32 S9, R0
					VCVT.F32.U32 S9, S9		;S9 = ABC
					VMOV.F32 S1, S17
					VMOV.F32 S2, S18
					VMOV.F32 S3, S19
					BL logic_OR
					VMOV.F32 S1, R0
					VCVT.F32.U32 S1, S1		;S1 = OR(S17,S18,S19)
					VMOV.F32 S2, S9				
					VLDR.F32 S3, = 0
					BL logic_OR						;Final output = OR(S1,S9,0) --> basically OR(S17,S18,S19,S9)
					POP{LR}
					BX LR
					ENDFUNC
					
;Function to implement logic XNOR gate
logic_XNOR	FUNCTION
					PUSH{LR}
					BL logic_XOR					;XNOR = NOT(XOR)
					VMOV.F32 S1, R0
					VCVT.F32.U32 S1, S1
					BL logic_NOT
					POP{LR}
				    BX lr
					ENDFUNC
					
;Function to implement logic NAND gate
logic_NAND	FUNCTION
					PUSH{LR}
					BL logic_AND					;NAND = NOT(AND)
					VMOV.F32 S1, R0
					VCVT.F32.U32 S1, S1
					BL logic_NOT
					POP{LR}
				    BX lr
					ENDFUNC
					
;Function to implement logic NOR gate
logic_NOR	FUNCTION
					PUSH{LR}
					BL logic_OR						;NOR = NOT(OR)
					VMOV.F32 S1, R0
					VCVT.F32.U32 S1, S1
					BL logic_NOT
					POP{LR}
				    BX lr
					ENDFUNC
					
;Function to compute sigmoid of S0, result--> S0
sig     FUNCTION
		 PUSH{LR}
		 VNEG.F32 S0, S0		;S0 = -x
         BL exp							;S0 = exp(-x)
		 VADD.F32 S0, S0, S15 ;S0 = exp(-x) + 1
		 VDIV.F32 S0, S15, S0  ;S0 = 1/(exp(-x) + 1)
		 POP{LR}
		 BX LR
		 ENDFUNC

;Function to compute exp(S0) using infinite series -->result in S0 
exp	 FUNCTION
		 PUSH{LR}
		 VLDR.F32 S11, = 0		;to keep tab of number of terms, i
	     VLDR.F32 S12, = 1		;temp to store each component of series
		 VLDR.F32 S13, = 1		;output of exp(x)
		 VLDR.F32 S14, = 50	    ;total number of terms (50)
		 B check
		 
loop   VMUL.F32 S12, S12, S0	  ;temp = temp*x
		 VDIV.F32 S12, S12, S11	  ;temp = temp/i
		 VADD.F32 S13, S13, S12	  ;term added to output
		 B check		 
		 
check		 VADD.F32 S11, S11, S15   ;S11 = S11 + 1 
		         VCMP.F32 S11, S14		  ;comparing number of terms with total number
				 VMRS APSR_nzcv, FPSCR
		         BLE loop
				 VMOV.F32 S0,S13
				 POP{LR}
				 BX LR
		ENDFUNC
		 
stop B stop		 
     END
