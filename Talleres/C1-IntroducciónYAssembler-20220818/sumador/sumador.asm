extern print_uint64

section	.data
    number db 8 ;no me sale declarar variables equis de

section	.text
	global _start
_start:
    ;uso registros de 8 bits para sumar dos numeros de 8 bits, no se si eso es lo que esperaban q haga lol
    mov al, 0
    add al, 0xff  ;eflags 0x257 [ CF PF AF ZF IF ] (esto me aparece en gdb)


    ;ahora hago lo mismo con 64 bits
    ;mov rax, 0
    ;add rax, 0xff ;eflags 0x216 [ PF AF IF ]
    ;add rax, -10 ;eflags 0x282   [ SF IF ]
    ;add rax, 0 ;eflags  0x246     [ PF ZF IF ]


    mov rdi, rax
    call print_uint64
    

    mov	al, 1	    
	int	0x80 
