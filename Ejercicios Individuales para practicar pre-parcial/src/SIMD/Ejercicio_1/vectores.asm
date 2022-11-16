%define CHAR_SIZE 1
section .data

section .text
global SumarVectores
;void SumarVectores(char *A, char *B, char *Resultado, int dimension)
;RDI = *A
;RSI = *B
;RDX = *Resultado
;RCX = dimension multiplo de la cant de eltos que procesa (para cada char*)
SumarVectores:
    shr rcx,4 ;pensa que lo dividis entre 16 porque sabes que osn de 1 byte

    ;como la dimension es multiplo de la cant de eltos que procesa simultaneamente
    ;no me preocupo por si quedan bytes sin usar en xmm todos van a estar ocupados
    ;entonces tenemos que hacer esto repetidas veces como nos diga la dimencion
    xor r8,r8
    pxor xmm0,xmm0
.ciclo:
    cmp rcx,0
    je .fin

    movdqu xmm1,[rdi] ;me mueve de 16 bytes los que entran en xmm
    movdqu xmm2,[rsi] ; =primeros 16 bytes de B
    add rdi,16
    add rsi,16

    paddusb xmm1,xmm2
    movdqu xmm0,xmm1


#############BOTH ARE OKAY##############
    movdqu [rdx],xmm0 ;movemos los 16 bytes de una
    add rdx,16
;----------------esto esta bien pero
;ES CON QUADWORD
    movq [rdx],xmm0 ;mueve 8 bytes = xmm0[7:0]
    add rdx,8
    PSRLDQ xmm0,4 ;#################################ESTO ES MUY NECESARIO PARA MOVERNOS EN LOS XMM
    movq [rdx],xmm0 ;q porque quiero que mueva 64 bits
;d p;orque es lo que entra en el registro de 8 bytes
    add rdx,8
;-------------------------
    inc r8
    dec rcx
    jmp .ciclo

.fin:
    ret
