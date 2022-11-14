#include <stdlib.h>
#include <stdio.h>
#include "cesar.h"
#include <string.h>	

typedef char* (cesar_func_ptr)(char*,int);

void calling_function(cesar_func_ptr cesar, char* s, int x){
    char* res= cesar(s,x);
    printf("%s\n", res);
    free(res);
}


int main(){
    char* s="CASA";
    char* s1="CAROLINA";
    char* s2="COCINA";
    int x=3;
    int x1=1;
    int x2=2;

    char* s0="";
    int x0=5;

    //char* res= cesar(s,x);
    //char* res_asm = cesar_asm(s,x);

    calling_function(cesar,s,x);
    calling_function(cesar_asm,s,x);

    calling_function(cesar,s1,x1);
    calling_function(cesar_asm,s1,x1);

    calling_function(cesar,s2,x2);
    calling_function(cesar_asm,s2,x2);

    calling_function(cesar,s0,x0);
    calling_function(cesar_asm,s0,x0);

    //char r = res;
    //printf("%s\n", res);
    //printf("%s\n", res_asm);
    //free(res);
    //free(res_asm);  //libero la memoria que pedi

    return 0;
}

