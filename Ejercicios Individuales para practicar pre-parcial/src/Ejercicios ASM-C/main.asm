%define OFFSET_TIPO 0
%define OFFSET_DATA 8
%define OFFSET_D 16
%define OFFSET_I 24
%define OFFSET_C 32
%define OFFSET_TIPO 0

extern BorrarCentro

section .text
;void BorrarCentro(void **nodo, funBorrar *fb){}
; **nodo : [rdi] , *fb : [rsi]

global _start:
_start:
    push rbp
    mov rbp,rsp
    mov rdx,[rdi]
    cmp rdx,0
    je .fin
    mov bl,[rsi] ;ahora tengo el primer valor del nodo aca
; el cual me dice que tipo es
    cmp bl,2
    je .voyDos
   
    jmp .borroTres
    



.fin: 
    pop rbp
    ret

.voyDos:
    mov bl,[rsi+OFFSET_D]
    cmp bl,2
    mov bl,[rsi+8]
    cmp bl,2
    je .
    je .borroTres

.borroTres:
    mov [rsi+OFFSET_C],0



borroDos:
    sub rsp,8
    push r12
    push r13
    mov r12,[rdi]
    mov r13,rsi
    mov rdi,[r12+OFFSET_DATA] ;muevo la data a rdi
    call r13 ;  y la elimino
    LEA rdi,[r12+OFFSET_I]  ; vuelvo a poner en rdi la dire correspondiente
    mov rsi,r13 ; muevo a rsi la funcion
    CALL _start ; hago denuevo el ciclo con 