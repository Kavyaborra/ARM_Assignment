     THUMB
     AREA     fibonacci, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         MOV  R0, #0xA	;first number
         MOV  R1, #0xB	;second number
	     MOV  R2, #0xC	;third number
	     CMP  R0, R1    	;compares number1 and number2
	     BLT   jump			;if number1<number2 (R0<R1), executes from jump point. else, continues 
	     CMP R0, R2			;compares R0 and R2 (numbers 1 and 3)
		 MOVLT R0, R2  	;if R0<R2, greatest number is number 3, moved to R0. else the greatest number is R0(number1) itself
		 B stop
		 
jump  MOV R0,R1			;moves number 2 to R0
		 CMP R0, R2			;compares R0 and R2 (numbers 2 and 3)
		 MOVLT R0, R2   	;if R0<R2, greatest number is number 3, moved to R0. else the greatest number is R0(number 2) itself
		 
stop	 B stop 
     ENDFUNC
     END
		 
/* nested if else to find the largest of three numbers and store it in R0

if (R0>R1) (using CMP)
{
	if(R0<R2) (using another CMP so GT, LT, NE flags get updated)
			R0 = R2 (largest number 3)
	else
			R0 = R0 (largest number 1)
}
else
{
	R0 = R1 (R0 gets number 2)
	if(R0<R2)
			R0 = R2 (largest number 3)
	else
			R0 = R0 (largest number 2)
}

*/	
