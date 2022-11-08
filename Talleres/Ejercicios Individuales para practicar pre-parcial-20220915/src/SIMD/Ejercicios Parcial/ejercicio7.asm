
;EJERICIOS PARCIAL
;Ejercicio 7
;Considerar un vector de 16 números enteros con signo de 24 bits almacenados en big-
;endian.
;a) Construir una función en ASM utilizando SIMD que dado un puntero al vector de
;números mencionado, retorne la suma de los números del vector como un entero
;de 4 bytes.
;b) Modificar la función anterior para que a los números pares los multiplique por π.
;En este caso el resultado debe ser retornado como double.


;en big endian es decir el mas significativo es el primero
;me voy a crear mi funcion en c

section .data
;crear vectos de 16 num enteros con signo de 24bits
    mask db  
    2,1,0,15,
    5,4,3,15,
    8,7,6,15,
    11,10,9,15
    ;quiero que el ultimo sea un 15 mecreo una mask para extender los bytes a 4 para asi
    ;poner el signo y sumar con signo
section .text

global _start
;void(vector<int> *vector,int res){}
;quiero que retorne la suma de los num del vector EN un entero de 4bytes = int

; el vector tiene enteros de 24 bits es decir 3 bytes. Entonces un registro xmm puede almacenar 5.33
; de estos, podemos pasarlos a 4bytes y llenariamos con 4enteros el xmm ENTONCES
;si vamos a trabajar simultaneamente con 4, van a sobrar 4bytes en xmm
; de la parte alta que vamos a dejar libre entonces
_start:
;rdi tiene el puntero al arreglo
    mov rsi,16;muevo la cant de eltos
    movdqu xmm1,[mask] ;muevo los 16 eltos a xmm1
    ;y ahora voy a trabajar de a 4 eltos


    mov xmm0, rdi 


;VAMOS a hacer la mascara ahora
    pshufb xmm0,xmm1;usamos la mask de xmm1 en xmm0
    ;ahora estan en little ordenados
    pslld xmm0, 1






