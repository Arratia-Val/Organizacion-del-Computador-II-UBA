#include <stdlib.h>
#include <stdio.h>
#include <string.h>	
#include "prefijo.h"

char* prefijo_de(char* s1,char* s2){

    int len1 = strlen(s1);
    char* prefijo = malloc(sizeof(char) * (len1 + 1)); //sizeof da el tamaño en bytes 

    int i=0;
    while(s1[i] == s2[i] && i < len1){
        prefijo[i] = s1[i];
        i++;
    }
    return prefijo;
}
