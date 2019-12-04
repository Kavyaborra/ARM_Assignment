
#include "stm32f4xx.h"
#include <string.h>

void print_gate(const int a)
{
	 char Msg[100];
	 char *ptr;
	
	switch (a) {
            case 1:
								sprintf(Msg, "\n\nlogicAND\n");
                break;
            case 2:
								sprintf(Msg, "\n\nlogicOR\n\n");
                break;
						case 3:
								sprintf(Msg, "\n\nlogicNOT\n");
                break;
						case 4:
								sprintf(Msg, "\n\nlogicXOR\n");
                break;
						case 5:
								sprintf(Msg, "\n\nlogicXNOR\n");
                break;
						case 6:
								sprintf(Msg, "\n\nlogicNAND\n");
                break;
						case 7:
								sprintf(Msg, "\n\nlogicNOR\n");
                break;
        }

	 ptr = Msg ;

   while(*ptr != '\0')
	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }
}
	
void print_head(const int a)						//to print the output
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "A\tB\tC\tOut\n");

	 ptr = Msg ;

   while(*ptr != '\0')
	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }
}

void print_headnot(const int a)						//to print the output
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "A\tOut\n");

	 ptr = Msg ;

   while(*ptr != '\0')
	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }
}

void print_innot(const int a, const int b)						//to print the output
{
	  char Msg[100];

	 char *ptr;

	 sprintf(Msg, "%d\t", b);

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }
}

void print_inputs(const int a, const int b, const int c, const int d)			//to print the inputs

{

	 char Msg[100];

	 char *ptr;

	 sprintf(Msg, "%d\t", b);

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }

	 sprintf(Msg, "%d\t", c);

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

   }

	 sprintf(Msg, "%d\t", d);

	 ptr = Msg ;

   while(*ptr != '\0')

	 {

      ITM_SendChar(*ptr);

      ++ptr;

	 }

}

void printout(const int a)						//to print the output
{
	 char Msg[100];
	 char *ptr;
	
	 sprintf(Msg, "%d\n", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}
