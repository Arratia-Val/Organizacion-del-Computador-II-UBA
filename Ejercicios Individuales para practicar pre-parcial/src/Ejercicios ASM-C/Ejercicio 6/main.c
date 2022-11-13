#include <stdlib.h>
#include <stdio.h>
#include "cesar.h"

typedef char* (*cesar_func_ptr)(char*, int);

int main(){
    char* s="CASA";
    int x=4;

    char* res= cesar(s,x);
    //char r = res;
    printf("%s\n", res);
    free(res);  //libero la memoria que pedi

    return 0;
}

