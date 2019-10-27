     THUMB
     AREA     fibonacci, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         MOV  R0, #0x0 		;R0, R1 to store the previous two numbers in the series, initialised to 0 and 1
         MOV  R1, #0x1
		 MOV  R2, #0x0 		;R2 to store the output, the series numbers one by one, initail numbers should be 0 and 1
	     MOV  R2, #0x1		

loop	 ADD  R2, R0, R1	; R2 = R0 + R1 (previous two numbers)
	     MOV  R0, R1		; new R0 = previous R1
		 MOV  R1, R2		; new R1 = previous R2 
	     B loop			; will keep giving fibonacci values till program is aborted (Ctrl + F5) 
     ENDFUNC
     END
