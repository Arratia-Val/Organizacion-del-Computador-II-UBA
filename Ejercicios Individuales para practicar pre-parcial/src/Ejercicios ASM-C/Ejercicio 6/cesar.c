#include <stdlib.h>
#include <string.h>
#include "cesar.h"


char chr(int n){
    return (char)n;
}

int ord(char c){
    return (int)c;
}

char* cesar(char* s,int x){

    int len = strlen(s);

    int firstChar = ord('A');
    int maxLetras = 26; //#letras en el alfabeto
    //pido memoria para el resultado
    char* res;
    res= malloc((len + 1) * sizeof(char)); //HAY QUE PEDIR MEMORIA

    for(int i=0;i<len;i++){

        if(chr(ord(s[i])) == 'C'){
            res[i] = chr( firstChar + (ord(s[i]) + x - firstChar) % maxLetras );
        }else{
            res[i]=s[i];
        }
    }
    res[len]=0;
    return res;

}