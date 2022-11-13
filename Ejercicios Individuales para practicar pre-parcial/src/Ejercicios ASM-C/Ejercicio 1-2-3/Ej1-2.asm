;ACA VAN LOS EXTERN (FUNCION C)

;#######  SECTION .DATA
section .data
    vector dd 0,1,2,3 ;guardados en memorio asi como estan entran al registro "de iquierda a derecha"
;#######   SECTION .TEXT
section .text

global _start
_start:
    ;epilogo //pusheo al stack actualizo rbp y rsp lo ubico con rbp
    push rbp
    mov rbp,rsp

    push rsi ;para preservar el registro


    xor rsi,rsi ;nuestro sumador
    xor rdx,rdx ;nuestro contador para bytes
    mov rcx,0x4 ;contador del vector

.ciclo:
    mov edi,[vector+rdx*4] ;agraga el primer número / *4 el numero de bytes que me muevo
    add esi,edi
    inc rdx
    loop .ciclo

.fin:
    mov rax,rsi ;guardo el resultado en RAX

    ;prologo
    mov rsp,rbp
    pop rbp

    mov rax, 1;posicion de retornoooo donde esta ej1
    int 0x80