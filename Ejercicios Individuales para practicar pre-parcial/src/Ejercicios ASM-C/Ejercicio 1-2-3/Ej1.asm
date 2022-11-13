;ACA VAN LOS EXTERN (FUNCION C)
    
;%define BYTE_CHAR 1

;########### SECCION DE DATOS
section .data
;LOS OTROS DEFINE DB DW DD
vector dd 4,2,1,5,4,3,8,4,7,8,2,7,6,9,9,4 ;83 or 0x53 | DD = 4B = 32b | DQ = 8B = 64b

;########### SECCION DE TEXTO (PROGRAMA)
;sumador(vector<int>* v){}
;v[rdi]
section .text
global ej1
ej1:
    ;epilogo //pusheo al stack actualizo rbp y rsp lo ubico con rbp
    push rbp
    mov rbp, rsp 
    push rsi ;fija el valor de rsi

    mov rcx,0x10 ;tamaño del vector recorda que va en hexa
    xor rdx,rdx

    xor rsi,rsi ;vacio rsi mi sumador
.sum:
    mov edi, [vector+rdx*4] ;ubica el primer numero
    add rsi, rdi
    inc rdx
    loop .sum

.fin:
    mov rax,rsi
    
    ; prologue
    pop rsi

    mov rsp, rbp
    pop rbp
exit:
    mov rax, 1;posicion de retornoooo donde esta ej1
    int 0x80



;ej2:
;a) ¿Cómo realizó las lecturas de los enteros desde memoria? Si utilizó un registro indique cuantos bits tiene.
;b) Ahora, escriba un programa en Assembler que lea los enteros en un registro de 32 bits y los sume en 64 bits
;c) ¿Qué ventaja encuentra en sumarlos en 64 bits?
;d) Asuma que los registros de 64bits están completos con unos. ¿Que pasarı́a cuando muevan los enteros de 32 bits y
;sume en 64 bits? Escriba un código para solucionar el problema.

