#include <stdio.h>
#include <stdlib.h>
#include "defines.h"

int main(){

    cliente_t* clientes = malloc(3 * sizeof(cliente_t));

    cliente_t client1 = {
        .nombre = "Steve",
        .apellido = "Balmer",
        .compra = 300,
        .dni = 12345678,
    };

    cliente_t client2 = {
        .nombre = "Valeria",
        .apellido = "Arratia",
        .compra = 550,
        .dni = 12345678,
    };

    cliente_t client3 = {
        .nombre = "Doris",
        .apellido = "Guillen",
        .compra = 1000,
        .dni = 12345678,
    };

    clientes[0]= client1;
    clientes[1]= client2;
    clientes[2]= client3;

    //######## NOTA
    //No pedí memoria en ASM pues alli devuelvo la direccion a donde me movi para
    //obtener el resultado esperado, no me defini una nueva variable con el resultado
    //ME MOVI al resultado
    //ACA EN C estoy DEFINIENDO UNA VARIABLE a la que le voy a poner el resultado
    //por lo tanto necesito ese espacio en memoria
    cliente_t* res = malloc(sizeof(cliente_t));
     free(res);
    res=aleatorio(clientes); //se copia la direccion
                             //donde esta cliente en la lista
                             

    printf("Nombre: %s\n", res->nombre);
    printf("Apellido: %s\n", res->apellido);
    printf("compra: %ld\n", res->compra);
    printf("dni: %d\n", res->dni);
    free(clientes);
    
   
}


