#include <stdlib.h>
#include <stdio.h>
#include "prefijo.h"
#include <string.h>	


typedef char* (function_ptr)(char*,char*);

void call_function(function_ptr prefijo_de,char* s1,char* s2){
    char* prefijo = prefijo_de(s1, s2);

    printf("%s\n",prefijo);
    free(prefijo);
}

int main(){
    char* s1 = "Astronomia";
    char* s2 = "Astrologia";

    char* prefijo = prefijo_de(s1,s2);
    printf("%s\n",prefijo);
    free(prefijo);

    call_function(prefijo_de,"Pinchado", "Pincel");
    call_function(prefijo_de,"Boca", "River");
    call_function(prefijo_de,"ABCD", "ABCD");

    


    return 0;
}