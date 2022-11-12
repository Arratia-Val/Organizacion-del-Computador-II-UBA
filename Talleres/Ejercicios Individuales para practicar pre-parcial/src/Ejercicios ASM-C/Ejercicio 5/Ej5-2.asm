
section .data
entero: db 10       ;se definen como dirección de memoria

section .text

global _Ejercicio5
_Ejercicio5:
    _llamadora:
        mov rsi, [entero]
        push rsi            ;creo que no hace falta porque se cumple la convencion C
        call _invocada

    _incovada: ;como es una funcion INVOCADA tengo que armar el STACK FRAME
        push rbp            ; se pushea el rbp es decir la direccion base (REAL) del stack 
        mov rbp,rsp         ; el nuevo RBP va a ser el RSP (pues este va a avanzar y queremos guardar
                            ; la "base" del stack frame para despues recuperarlo y retornar la función
                            ; donde verdaderamente estabamos)
        xor rax,rax
        mov rax,rsi
        add rax,[rbp+8]       ; le sumo la dirección que guarda de donde fue llamada invocada

        mov rsp,rbp
        pop rbp
        ret                 ;retornar
