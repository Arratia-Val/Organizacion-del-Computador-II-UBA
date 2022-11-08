global fir_filter_simd
extern fir_filter
extern memcpy
extern memmove

%define OFFSET_COEFS 0
%define OFFSET_LEN 8
%define OFFSET_BUFF 16
;o 16?
%define MAX_INPUT_BLOCK_LEN 256
%define MAX_FILTER_LEN 400000

section .data
mask: dw 0x14, 0x15, 0x12, 0x13, 0x10, 0x11, 0x08, 0x09, 0x06, 0x07, 0x04, 0x05, 0x02, 0x03, 0x00, 0x01
    
section .text
;size_t fir_filter_simd(FIR_t*filtro, int16_t *in, unsigned length, int16_t *out)
; *fir_t rdi , *in rsi , length rdx , *out rcx
fir_filter_simd:
    ; Reemplazar con una super eficiente implementación en SIMD!
    push rbp
    mov rbp,rsp

    mov rbx,rdi ;filtro
    mov r12,rdx ;length
    mov r13,rcx ;out

    ;memcpy
    add rdi,OFFSET_BUFF ;me muevo a la dir donde comienza el buffer
    add edi,dword[rbx+OFFSET_LEN];le sumo la long
    dec rdi
    add rdx,rdx
    call memcpy

    ;inicializo para el ciclo
    xor r8,r8 ;=n
    ;xor r9,r9 ;=acc
    xor r10,r10
    xor r11,r11
    xor r14,r14
    xor r15,15
    mov r14d,dword[rbx+OFFSET_LEN] ;=filtro->length 

.cicloExterno:
    ;mov r10,[rbx] ;muevo coeff
    lea r11,[rbx+OFFSET_BUFF] ;muevo la dir del buffer
    add rbx,OFFSET_LEN ;me muevo a length
    dec rbx ;decrementamos length
    add rbx,r8 ;sumamos n a length
    add r11,rbx ;&filtro->buffer[filtro->length - 1 + n]

    xor r9,r9; =k
    xor rax,rax; =acc

;rax = acc
;r10 = coeff_p  es puntero
;r11 = in_p  es puntero
.cicloInterno:
    mov r10,[rbx] ;muevo el puntero a coef
    movdqu xmm1, [r10] ;muevo los coeff a xmm1 /mueve 8 coef/ xmm1=|c0|c1|...|c7|
    movdqu xmm2, [r11] ;muevo las muestras a xmm2 /mueve 8 muestras/ xmm2=|b0|b1|...|b7|

    ;invierto las muestras
    movdqu xmm3,[mask]
    pshufb xmm2,xmm3 ;xmm2=|b7|b6|...|b0|
    movdqu xmm0,xmm2 ;xmm0=|b7|b6|...|b0|
    ;multiplico y sumo
    pmaddwd xmm0,xmm1 ;xmm0=|b7*c0+b6*c1|b5*c2+b4*c3|b3*c4+b2*c5|b1*c6+b0*c7|
    phaddd xmm0,xmm0 ;xmm0=|...|b7*c0+b6*c1 + b5*c2+b4*c3 | b3*c4+b2*c5 + b1*c6+b0*c7|
    phaddd xmm0,xmm0 ;xmm0=|...|b7*c0+b6*c1+b5*c2+b4*c3 + b3*c4+b2*c5+b1*c6+b0*c7|

    ;==> xmm0 = acc
    movd r15d,xmm0
    add rax,r15
    ;actualizo los coeff y in_p
    add r14,16 ;lo que entra en cada xmm
    sub r11,16


    ;salgo del cicloInterno
    add r9,8 ;voy recorriendod de a 8 muestras
    cmp r9,r14
    jne .cicloInterno


    ;saturación
    cmp eax,0x3fffffff
    jg .esMayor
    cmp eax,-0x40000000
    jl .esMenor

.esMayor:
    mov eax,0x3fffffff
.esMenor:
    mov eax,-0x40000000

    ;convertir de Q30 a Q15
    sar eax,15 ;acc >> 15
    mov word[rcx+r8],ax


    ;salgo del cicloExterno
    inc r8
    cmp r8,r12
    jne .cicloExterno


    ;memmove
    xor r15,r15
    mov r15,rbx
    add rbx,OFFSET_BUFF
    mov rdi,rbx ;&filtro->buffer[0]

    ;add rbx,r12
    ;mov rsi,rbx
    lea rsi, [rbx+r12] ;&filtro->buffer[length]

    mov r15d,dword[r15+OFFSET_LEN]
    dec r15
    shl r15,1
    mov rdx,r15
    ;ahora en rdx muevo el filtro->length-1

    pop rbp
    ret
