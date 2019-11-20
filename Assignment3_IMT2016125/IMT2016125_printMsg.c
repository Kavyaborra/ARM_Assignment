
#include "stm32f4xx.h"
#include <string.h>
void printout(const int a)						//to print the output
{
	 char Msg[100];
	 char *ptr;
	sprintf(Msg, "Output:\t");
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}

void print_inputs(const int a, const int b, const int c, const int d)			//to print the inputs

{

	 char Msg[100];

	 char *ptr;
	
	 sprintf(Msg, "A\t\tB\t\tC\n");

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }

	 sprintf(Msg, "%d\t\t", b);

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }

	 sprintf(Msg, "%d\t\t", c);

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }

	 sprintf(Msg, "%d\n\n", d);

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

	 }

}
