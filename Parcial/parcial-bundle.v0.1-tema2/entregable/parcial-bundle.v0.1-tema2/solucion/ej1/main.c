#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ej1.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	msg_t a;
	a.tag=0;
	char *ch="aaa";
	a.text=ch;
	
	a.text_len=3;
	//size_t b=3;
	char** c;
	c= agrupar(&a,1);
	printf(**c);
	return 0;    
}


