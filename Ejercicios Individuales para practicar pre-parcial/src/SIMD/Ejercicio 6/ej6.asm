;aca los extern

section .rodata
section .data

section .text

global InicializarVector
;void InicializarVector(short *A, short valorInicial, int dimension)
; *A: [rdi] , valorInicial: [rsi] , dimension: [rdx]
InicializarVector:
    mov rcx,rdx
    xor r8,r8
    movq xmm1, rsi ; xmm1= w w w w w w w rsi ;pues me mueve el quadword que como rsi es un word me mueve words
    movq xmm2, rsi ; xmm2= w w w w w w w rsi
    pslldq xmm2, 2 ; xmm2= w w w w w w rsi 0

    por xmm1, xmm2 ;xmm1= w w w w w w rsi rsi

.shiftAndOr:
    movq xmm1, rsi ; xmm1= w w w w w w w rsi ;pues me mueve el quadword que como rsi es un word me mueve words
    movq xmm2, rsi ; xmm2= w w w w w w w rsi
    pslldq xmm2, 2*r8 ; xmm2= w w w w w w rsi 0

    por xmm1, xmm2




