     THUMB
     AREA     evenodd, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
     MOV  R0, #0x7	; given number
	 ; if number is odd result will be 1 and if its even result will be 0. Result will be stored in R0
	 AND   R0, #0x1    ; logical AND with 1 will give the LSB of the given number
		; if the number is odd, LSB = 1 else LSB = 0
stop	 B stop 
     ENDFUNC
     END
