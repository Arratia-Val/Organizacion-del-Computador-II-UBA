section .text
	global _start
_start
	mov edx, len 
	mov ecx, msg
	mov ebx, 1 ; es el standard output, para salir en pantalla
	mov eax, 4 ; sys_write
	int 0x80
	mov eax, 1 ;sys_exit
	int 0x80 ; (syscall) llamada al sistema operativo interrupcion 80 en hexadecimal
section .data
	msg db 'Hello, world!', 0xa, 'Martin Lei', 0xa, 'Me gusta la pizza', 0xa
	len equ $ - msg ;len es el numero 43. $ se evalua en la pos en mem al ppio de la linea que contiene la expr