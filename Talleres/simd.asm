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
mask: db 0x0E, 0x0F, 0x0C, 0x0D, 0x0A, 0x0B, 0x08, 0x09, 0x06, 0x07, 0x04, 0x05, 0x02, 0x03, 0x00, 0x01
    
section .text
;size_t fir_filter_simd(FIR_t*filtro, int16_t *in, unsigned length, int16_t *out)
; *fir_t rdi , *in rsi , length rdx , *out rcx
fir_filter_simd:
    ; Reemplazar con una super eficiente implementación en SIMD!
    push rbp
    mov rbp,rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov rbx,rdi ;filtro
    mov r12,rdx ;length
    mov r13,rcx ;out

    xor r14,r14
    ;memcpy
    add rdi,OFFSET_BUFF ;&filtro->buffer /me muevo a la dir donde comienza el buffer
    mov r14d,dword[rbx+OFFSET_LEN] ; filtro->length
    dec r14 ;filtro->length - 1
    shl r14,1 ; (filtro->length - 1) *2
    add rdi,r14  ;rdi=&filtro->buffer[filtro->length - 1]
    ;shl r14,1
    ;add rdi,r14;le sumo la long
    ;dec rdi
    ;dec rdi
    shl rdx,1
    call memcpy

    ;inicializo para el ciclo
    xor r8,r8 ;=n
    ;xor r9,r9 ;=acc
    xor r10,r10 ;coeff_p
    xor r11,r11 ;in_p
    xor r14,r14
    xor r15,15
    mov r14d,dword[rbx+OFFSET_LEN] ;=filtro->length 

    xor rdi,rdi ;uso rdi para mantener el filtro en rbx

.cicloExterno:
    ;mov r10,[rbx] ;muevo coeff
    lea r11,[rbx+OFFSET_BUFF] ;muevo la dir del buffer

    mov edi,dword[rbx+OFFSET_LEN] ;filtro->length
    dec rdi ;decrementamos length / filtro->length -1
    ;dec rdi
    add rdi,r8 ;sumamos n a length /filtro->length -1 +n
    ;add rdi,r8
    shl rdi,1
    add r11,rdi ;&filtro->buffer[filtro->length - 1 + n]

    mov r10,[rbx] ;coeff_p

    xor r9,r9; =k
    xor rax,rax; =acc
    
;rax = acc
;r10 = coeff_p  es puntero
;r11 = in_p  es puntero
.cicloInterno:
     ;muevo el puntero a coef
    ;sub r11,16
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
    add r10,16 ;lo que entra en cada xmm
    sub r11,16


;#######;salgo del cicloInterno
    add r9,8 ;voy recorriendod de a 8 muestras
    cmp r9,r14
    jne .cicloInterno


    ;saturación
    cmp eax,0x3fffffff
    jg .esMayor
    cmp eax,-0x40000000
    jl .esMenor
    jmp .convertir

.esMayor:
    mov eax,0x3fffffff
    jmp .convertir
.esMenor:
    mov eax,-0x40000000

.convertir:
    ;convertir de Q30 a Q15
    sar eax,15 ;acc >> 15
    mov word[r13+(r8*2)],ax ;muevo de a 2bytes words


;###### ;salgo del cicloExterno
    inc r8
    cmp r8,r12
    jne .cicloExterno


    ;memmove
    xor r15,r15
    mov r15,rbx
    add rbx,OFFSET_BUFF
    mov rdi,rbx ; rdi = &filtro->buffer[0]

    shl r12,1
    lea rsi, [rbx+r12] ; rsi = &filtro->buffer[length]

    mov r15d,dword[r15+OFFSET_LEN] ;(filtro->length)
    dec r15 ;(filtro->length - 1)
    shl r15,1 ;(filtro->length - 1) * sizeof(int16_t)
    mov rdx,r15; rdx = (filtro->length - 1) * sizeof(int16_t)
    
    call memmove

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
