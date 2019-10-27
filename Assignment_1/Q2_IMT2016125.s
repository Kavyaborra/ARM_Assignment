     THUMB
     AREA     greatestnum, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         MOV  R0, #0x8	;first number, R0 will also give the greatest number after the program stops
         MOV  R1, #0xA	;second number
	     MOV  R2, #0xA	;third number
	     CMP  R0, R1    ;compares R0 and R1 
	     MOVLT R0, R1	;if R0<R1, sets R0 = R1
	     CMP  R0, R2	;compares R0 and R2
	     MOVLT R0, R2	;if R0<R2, sets R0 = R2
stop	 B stop 
     ENDFUNC
     END
