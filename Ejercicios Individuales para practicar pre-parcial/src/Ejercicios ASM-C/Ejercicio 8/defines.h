#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


#define NAME_LEN 21

typedef struct cliente_str {
    char nombre[NAME_LEN];
    char apellido[NAME_LEN];
    uint64_t compra;
    uint32_t dni;
} cliente_t;   //64/72 bytes en memoria
//EN DEFINITIVA MITE 64 
//ES LITERALMENTE LO QUE OCUPE EN MEMORIA

typedef struct __attribute__((__packed__)) packed_cliente_str {
    char nombre[NAME_LEN];
    char apellido[NAME_LEN];
    uint64_t compra;
    uint32_t dni;
} __attribute__((packed)) packed_cliente_t;

cliente_t* aleatorio(cliente_t* clientes);