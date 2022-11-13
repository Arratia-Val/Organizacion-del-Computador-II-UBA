#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

typedef struct s_nodoDos
{
    char tipo;           //1 byte    --> offset=0
    void* data;            // 8 bytes   --> offset= 8
    void* derecha;          // 8 bytes   --> offset= 16
    void* izquierda;        // 8 bytes   --> offset= 24
}nodoDos;

typedef struct s_nodoTres
{
    char tipo;          //1 byte    --> offset=0
    void* data;         // 8 bytes   --> offset= 8
    void* derecha;      // 8 bytes   --> offset= 16
    void* izquierda;    // 8 bytes   --> offset= 24
    void* centro;       // 8 bytes   --> offset= 32
}nodoTres;


void BorrarCentro(void **nodo, funBorrar *fb){}
