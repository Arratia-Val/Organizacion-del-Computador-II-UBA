#include "vectores.h"

int main(void){
    //uint8_t a[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
    //uint8_t b[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
//    uint8_t a[16] = {127, 128, 62, 64, 65, 129, 6, 7, 8, 9, 10, 11, 12, 13, 150, 255};
//    uint8_t b[16] = {127, 128, 62, 64, 65, 129, 6, 7, 8, 9, 10, 11, 12, 13, 150, 255};
//    uint8_t *res = malloc(sizeof(uint8_t) * 16);
//
//    SumarVectores(a, b, res, 4);
//
//    printf("{");
//    for(int i = 0; i<16;i++){
//        printf("%d, ", res[i]);
//    }
//    printf("}\n");
//

    //char* a = "000000000000000";
	//char* b = "111111111111111";
   //int dimension = 2;
	//char* resultado =malloc(sizeof(char)*16); 

    char* a = "1111000011111115982084444444444";
	char* b = "1111333311111119489081111111111";
	uint64_t dimension = 32;
    int l=sizeof(a);
    printf("%d/n, ", l);
    char* resultado = malloc(sizeof(uint8_t)*32);
    //use 16 porque estoy moviendo de a 16 /chars
	
	SumarVectores(a, b, resultado, dimension);
	printf("Ejercicio 1: sumar vectores = %s \n", resultado);
	
    for(int i = 0; i<32;i++){
         printf("%d, ", resultado[i]);
    }
    free(resultado);
	

    //short a[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    //InicializarVector(a,69,4);
    //for(int i = 0; i<16;i++){
    //    printf("%d, ", a[i]);
    //}

    return 0;
}
