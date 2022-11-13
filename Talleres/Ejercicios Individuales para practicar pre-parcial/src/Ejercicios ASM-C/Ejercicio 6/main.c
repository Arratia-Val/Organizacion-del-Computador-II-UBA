#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

uint32_t lenght(char* s){
    uint32_t i=0;
    while(s[i] != 0){
        i++;
    }
    return i+1; //devuelve el i más el digito NULL
}


int main(){
    char* s="CASA0";
    //uint32_t x=3;
    for(uint32_t i=0;i<lenght(s);i++){
        if(s[i]==67){
            s[i]='F';
        }
    }
    printf("%s\n", s);
    return 0;
}

