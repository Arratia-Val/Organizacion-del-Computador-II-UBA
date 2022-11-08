section .data
    n dd 4 ;estos se definen como direc de memoria
    ;para acceder al valor uso []
section .text
global _start
_start:
    _llamadora:;desde aca llamar a invocada
        mov rsi,[n]
        call _invocada
        mov rax,1
        int 0x80
    _invocada:
        push rbp
        mov rbp,rsp

        mov rax, rsi
        add rax, [rbp+8]

        mov rsp,rbp
        pop rbp
        ret