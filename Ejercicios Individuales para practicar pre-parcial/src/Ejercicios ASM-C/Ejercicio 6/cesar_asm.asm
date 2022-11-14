global cesar_asm
extern strlen
extern malloc

section .data
%define FIRST_CHAR 65
%define MAX_CHARS 26
%define CHAR_C 67
;cesar(char* s, int x){}
; s [rdi] , x [rsi]

section .text


cesar_asm:
    ;prologo
    push rbp   ;alineado
    mov rbp,rsp

    ;guardamos los argumentos en el stack
    push rdi ;string
    push rsi ;entero x

    ;saco la longitud(por convencion C toma primero rdi 
    ;que ya pusheamos al stack)
    call strlen
    mov rbx,rax ;movemos la longitud a un registro 
                ;no volatil (para que no cambie)
    ;inc rbx
    mov rdi,rbx ;por convencion C
    call malloc

    mov r12,rax ;muevo a un reg no volatil el
                ;espacio reservado por malloc  ;recuperamos los argumentos
    
    pop rsi
    pop rdi

    dec rdi
    dec r12

    mov rcx,rbx
    inc rcx

    mov r8,MAX_CHARS
    xor rax,rax
    xor r13,r13

    .ciclo:
        inc rdi
        mov r13b,byte[rdi]
        cmp r13b,CHAR_C
        jne .noIgual

        mov al,byte[rdi]

        ;ord(s[I]) +x -firstChar
        add al,sil ;+x
        sub rax,FIRST_CHAR ;-FIRSTchar
        xor rdx,rdx
        div r8 
        mov rax,rdx
        add rax,FIRST_CHAR ;+FirstChar

        xor r10,r10
        mov r10b,al ;muevo a r10 el primer byte modifficado
        inc r12b;me muevo a la direccion correcta
        mov byte[r12],r10b ;muevo el primer CHAR
        jmp .salgo

        .noIgual:
            xor r10,r10
            mov r10b,byte[rdi]
            inc r12b
            mov byte[r12],r10b

        .salgo:
        loop .ciclo


    ;epilogo
    sub r12,rbx
    mov rax,r12
    pop rbp
    ret