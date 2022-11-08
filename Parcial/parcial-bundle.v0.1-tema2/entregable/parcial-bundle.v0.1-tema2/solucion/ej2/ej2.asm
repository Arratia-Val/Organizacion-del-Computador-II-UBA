extern malloc
global filtro

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;int16_t* filtro (const int16_t* entrada, unsigned size)
; entrada rdi , size rsi

;entrada apunta a una 'secuencia' de 16bit 2bytes del tam de size
filtro:
    push rbp
    mov rbp,rsp

    mov rax, 4
    mul rsi
    sub rax, 12
    call malloc
    
    mov r10, rax ;el resultado de malloc en r10
    mov r12,3

    pxor xmm3,xmm3
    pxor xmm4,xmm4
    sub rsi,3
    mov r8,rsi
    mov r9,rdi
.ciclo:
    dec r8
    cmp r8,0xffff
    je .fin

    mov xmm1,word[r9]  ;xmm1= los primeros 8 valores ( aca voy a guardar los impares)
    mov xmm2,word[r9]

    pslld xmm1,16   ;xmm1=| 11 0 || 13 0 || 11 0 || 13 0
    psrld xmm1,16   ;xmm1=| 0 11 || 0 13 || 0 11 || 0 13
    psrld xmm2,16  ;xmm1=| 0 10 || 13 0 || 11 0 || 13 0

    packssdw xmm1, xmm3 ;mm2= |0|0|0|0|11|13|11|13|  words
    packssdw xmm2, xmm4 ;xmm2= |0|0|0|0|10|13|11|13|

    punpcklwd xmm1, xmm3  ;xmm1= | 11 | 13 | 11 | 13| 
    punpcklwd xmm2, xmm4

    phaddd xmm1, xmm3    ;xmm1= | 0+0 | 0+0 | 11 + 13 | 11 + 13|
    phaddd xmm2, xmm4    ;xmm1= | 0+0 | 0+0 | 11 + 13 | 11 + 13|

    phaddd xmm1, xmm3;xmm1=| 0+00+0+0 | 0+0+0+0| 0+0+0+0 | 11 + 13 + 11 + 13|
    phaddd xmm2, xmm4

    packssdw xmm1,xmm3
    packssdw xmm2,xmm4

    movd edx,xmm1
    movd ecx,xmm2
    

    mov dx,4
    mov cx,4

    div dx
    mov r10w,ax
    div cx
    mov r11w,ax

    mov [rax],r8 ;a rax le ponemos un puntero a r8
    add rax,2
   ;mov rax, r9

    add r9, 8 



.fin:
    pop rbp
    ret 


