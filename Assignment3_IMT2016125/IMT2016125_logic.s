     THUMB
	 PRESERVE8
     AREA     logic_neural, CODE, READONLY
     EXPORT __main
	 IMPORT print_gate
	 IMPORT print_inputs
	 IMPORT printout
	 IMPORT print_head
	 IMPORT print_headnot
	 IMPORT print_innot

	 ENTRY 
__main  FUNCTION		        ;to implement logic gates using a neural net
		 MOV R1, #0					;input A
		 MOV R2, #0					;input B
		 MOV R3, #0			;input C
		 MOV R4, #1 				;1-7 to choose the logic operation (5 means XNOR)
		 MOV R9, #0
		 MOV R10, #0
		
		;number in R4:
		;1 - AND
		;2 - OR
		;3 - NOT
		;4 - XOR
		;5 - XNOR
		;6 - NAND
		;7 - NOR
		 
		 
start	 VMOV.F32 S1, R1
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
		 MOV R6, R1
		 MOV R7, R2
		 MOV R8, R3
		 CMP R4, #3			;special printing for not gate
		 BNE head
		 ADD R10,R10,#1
		 CMP R10, #1
		 BNE notin
		 MOV R0,R4
		 BL print_gate
		 BL print_headnot
		 
notin	 MOV R1,R6
		 BL print_innot
		 MOV R0, R5
		 BL printout
		 MOV R1,R6
		 MOV R2, R7
		 MOV R3, R8
		 CMP R1, #0
		 MOV R1, #1
		 MOVNE R1, #0
		 ADDNE R4, R4, #1
		 B start
		 		 
		 
head	 ADD R9, R9, #1
		 CMP R9, #9
		 MOVGE R9, #1
		 CMP R9, #1
		 BNE input
		 MOV R0, R4
		 BL print_gate		 
		 BL print_head
		 
input	 MOV R1, R6
		 MOV R2, R7
		 MOV R3, R8
		 BL print_inputs
		 MOV R0, R5
		 BL printout			;to print the output
		 MOV R1, R6
		 MOV R2, R7
		 MOV R3, R8
		 CMP R3,#0
		 BNE add1
		 MOV R3,#1
		 B start
		 
add1	MOV R3, #0
		CMP R2, #0
		BNE add2
		MOV R2,#1
		B start
		
add2 MOV R2, #0
	   CMP R1, #0
	   MOV R1,#1
	   MOVNE R1,#0
	   ADDNE R4, R4, #1
	   B start
		 
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
					VMOV.F32 S20, R0			
					VCVT.F32.U32 S20, S20		;S20 = ~A
					VMOV.F32 S1, S2
					BL logic_NOT
					VMOV.F32 S21, R0
					VCVT.F32.U32 S21, S21		;S21 = ~B
					VMOV.F32 S1, S3		
					BL logic_NOT
					VMOV.F32 S22, R0
					VCVT.F32.U32 S22, S22		;S22 = ~C
					VMOV.F32 S1, S20
					VMOV.F32 S2, S21
					BL logic_AND
					VMOV.F32 S23, R0				
					VCVT.F32.U32 S23, S23		;S23 = (~A)(~B)C
					VMOV.F32 S1, R1	
					VCVT.F32.U32 S1, S1
					VMOV.F32 S3, S22
					BL logic_AND
					VMOV.F32 S24, R0				
					VCVT.F32.U32 S24, S24		;S24 = A(~B)(~C)
					VMOV.F32 S2, R2
					VCVT.F32.U32 S2, S2
					VMOV.F32 S1, S20
					BL logic_AND
					VMOV.F32 S25, R0
					VCVT.F32.U32 S25, S25		;S25 = (~A)B(~C)
					VMOV.F32 S3, R3
					VCVT.F32.U32 S3, S3
					VMOV.F32 S1, R1
					VCVT.F32.U32 S1, S1
					BL logic_AND
					VMOV.F32 S26, R0
					VCVT.F32.U32 S26, S26		;S26 = ABC
					VMOV.F32 S1, S23
					VMOV.F32 S2, S24
					VMOV.F32 S3, S25
					BL logic_OR
					VMOV.F32 S1, R0
					VCVT.F32.U32 S1, S1		;S1 = OR(S23,24,25)
					VMOV.F32 S2, S26				
					VLDR.F32 S3, = 0
					BL logic_OR						;Final output = OR(S1,S26,0) --> basically OR(S23,24,25,26)
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
