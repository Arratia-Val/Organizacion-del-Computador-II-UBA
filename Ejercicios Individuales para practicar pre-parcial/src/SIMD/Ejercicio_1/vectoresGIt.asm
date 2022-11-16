section .text
global SumarVectores
SumarVectores:
    ; rdi : first | rsi : second | rdx : result | rcx : dimension
    xor r8, r8    ; índex
   .cycle:
        movd xmm0, [rdi + r8*4]
        movd xmm1, [rsi + r8*4]
        paddusb xmm0, xmm1
        movd [rdx + r8*4], xmm0
        inc r8  ; Incrementamos el indice
    loop .cycle
    ret
