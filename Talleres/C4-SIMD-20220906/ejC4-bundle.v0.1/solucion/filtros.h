#ifndef FILTROS_H_
#define FILTROS_H_

#include<stddef.h>
#include<stdint.h>
// Máximo número de entradas que se pueden procesar en un llamado
#define MAX_INPUT_BLOCK_LEN 250

// Máxima longitud del filtro
#define MAX_FILTER_LEN 400000

// Longitud del buffer interno
#define BUFFER_LEN (MAX_FILTER_LEN - 1 + MAX_INPUT_BLOCK_LEN)

typedef struct FIR_t
{
    int16_t *coefs;             // coeficientes
    int length;                 // longitud del filtro 
    int16_t buffer[BUFFER_LEN]; // buffer de muestras de entrada
} FIR_t;

typedef struct signal_t
{
    int16_t *values;
    size_t length;
} signal_t;

void fir_init(FIR_t* filtro);
size_t fir_filter(FIR_t*filtro, int16_t *in, unsigned length, int16_t *out);
size_t fir_filter_simd(FIR_t*filtro, int16_t *in, unsigned length, int16_t *out);

#endif //FILTROS_H_

