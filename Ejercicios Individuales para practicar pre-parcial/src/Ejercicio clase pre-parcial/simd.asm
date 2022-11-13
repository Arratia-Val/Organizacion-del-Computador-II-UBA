%define NULL_TERMINACION 0
;USAR SIMD
;double promedio(char* str):
;*str : rdi

;Calcula el promedio de los caracteres del string 
;sin considerar el carater nulo

;longitud multiplo de 16 bytes
;tiene padding asi que cuanto hasta antes del cero

section .text
global _start
_start:
    push rbp
    mov rbp,rsp
    
    ;vamos a calcular el largo accedo al string
    
    xor rcx,rcx
    mov rsi,rdi
.cicloL:
    cmp byte[rsi],NULL_TERMINACION;comparo la primera letra si es vacia
    je .finLargo
    inc rcx
    inc rsi
    jmp .cicloL
.finL:;
    mov rax,rcx
    pxor xmm0,xmm0
    pxor xmm2,xmm2
.ciclo:
    movdqu xmm1,[rsi];movi 16 letras del string a xmm0
    movdqa xmm3,xmm1
    punpcklbw xmm1,xmm2; extiendola parte baja de xmm1 de byte a word
   ;es decir extiendo de xmm1(64:0)y lo mezclo con
   ;la parte baja de xmm2(64:0)
    ;y como xmm2 tiene cero completa adelante de los
    ;de xmm1 con cero (primero ubica los de dest xmm1)
    ;entonces ahora xmm1 tiene los primeros
    ;8 chars del estring en tamaño word
    ;tengo que hacer lo mismo con la parte alta

    punpcklbw xmm3,xmm2
    ;shora en xmm3 tengo los otros 8

    call sumParcial
    






;una vez tengo la longitud, busco pasarlos
;y sumarlos
.sum:
    cmp rcx,

    

.sumParticular:

.finLargo:
    mov rax,r8
