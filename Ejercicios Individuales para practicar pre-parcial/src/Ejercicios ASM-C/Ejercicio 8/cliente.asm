extern malloc

section .data
%define NUM_ALEATORIO 2
%define SIZEOF_CLIENTE 64

section .text
global aleatorio

;cliente_t* cliente(cliente_t* clientes)
;clientes [rdi]
aleatorio:
    ;prologo
    push rbp
    mov rbp,rsp

    ;peidmos memoria para el resultado
    ;tenemos que guardar en algun lado el sizeof
    ;cliente_t
    ;xor rbx,rbx   ;uso registro NO volatil
    ;xor rax,rax
    ;mov rax,64 ;sizeof(cliente_t)
    ;xor r8,r8
    ;mov r8,3
    ;mul r8 ; * el largo de rdi

    ;movemos a la pila para salvar valores
    ;push rdi
    ;mov rdi,rax
    ;call malloc
    ;mov rbx,rax ;ahora rbx tiene donde va a ir 
                ;el resultado

    ;pop rdi

    ;ahora tengo que moverme en rdi hasta llegar
    ;donde me diga el define NUM_ALEATORIO
    mov rax, NUM_ALEATORIO-1
    xor r8,r8
    mov r8,SIZEOF_CLIENTE
    mul r8
    add rdi,rax

    ;mov rax,rbx
    mov rax,rdi ;muevo el resultado
    ;no como en los strings pues no hacia falta
    ;crear otro espacio en memoria
    ;simplemente imprimir el espacio en memoria
    ;que ya solicité
    ;epilogo
    pop rbp
    ret