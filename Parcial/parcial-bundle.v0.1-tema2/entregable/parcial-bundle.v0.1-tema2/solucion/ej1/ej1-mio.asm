%define OFFSET_text 0
%define OFFSET_text_len 8
%define OFFSET_tag 16
%define SIZE_struct 24
%define TAG_0 0
%define TAG_1 1
%define TAG_2 2
%define TAG_3 3
%define NULL 0
%define MAX_TAGS 4
%define SIZE_POINTER 8

extern malloc

section .data

section .text
global agrupar
;char** agrupar(msg_t* msgArr, size_t msgArr_len);
; msgArr [rdi] , msgLen [rsi]
agrupar:
    ;el resultado es un puntero a un array de chars
    ;con cada posicion del array un string concatenado
    ;de los msgs con la MISMA etiqueta pasado por parametro

;tengo que pedir memoria para cada etiqueta y copiar los que tienen 
;el mismo TAG

    ;1° recorro el msgArr y me fijo cuales tienen la misma etiqueta
    ;voy a recorrer y sumo las longitudes de los arreglos de los mismos TAGS 
    ;2° y luego pido memoria 
    ;3° y luego copio el texto (de nuevo chequeando que sea el mismo TAG)

    ;epilogo
    push rbp
    mov rbp,rsp

    xor r12,r12
    xor r13,r13
    xor r14,r14
    xor r15,r15

    xor r8,r8 ;sumador del offset

.ciclo:   ;va a contar el largo de cada cadena en res
    dec rsi
    cmp rsi,0
    je .pedir_Memoria
    ;nos movemos en rdi
    ;add rdi,OFFSET_struct*r8
    ;nos movemos a tag y vemos cuanto vale
    mov rax,SIZE_struct
    mul r8 
    add rax,OFFSET_tag
    mov rbx,[rdi+rax]

    cmp ebx, TAG_0 ;comparo el tag de rdi[0] con 0
    je .length_tag_0
    cmp ebx, TAG_1 ;comparo el tag de rdi[0] con 0
    je .length_tag_1
    cmp ebx, TAG_2 ;comparo el tag de rdi[0] con 0
    je .length_tag_2
    cmp ebx, TAG_3 ;comparo el tag de rdi[0] con 0
    je .length_tag_3
.vuelta0:
    inc r8
    jmp .ciclo


.length_tag_0:
    ;r12 va a guardar la longitud total de los mensajes con TAG 0
    xor rbx,rbx
    mov ebx,[rdi+OFFSET_text_len]
    
    add rdx,rbx
    jmp .vuelta0 ;sigo buscando los otros TEXTS con TAG 0

.length_tag_1:
    ;r13 va a guardar la longitud total de los mensajes con TAG 0
    xor rbx,rbx
    mov ebx,[rdi+OFFSET_text_len]
    
    add rcx,rbx
    jmp .vuelta0

.length_tag_2:
    ;r14 va a guardar la longitud total de los mensajes con TAG 0
    xor rbx,rbx
    mov ebx,[rdi+OFFSET_text_len]
    
    add r10,rbx
    jmp .vuelta0

.length_tag_3:
    ;r15 va a guardar la longitud total de los mensajes con TAG 0
    xor rbx,rbx
    mov ebx,[rdi+OFFSET_text_len]
    
    add r11,rbx
    jmp .vuelta0


;PEDIMOS MEMORIA
.pedir_Memoria:
    xor rax,rax
    push rdi
    push rsi ;guardo las variables temporales
    push r11
    push r10
    push rcx
    push rdx

    inc r12 ;hay que tener en cuenta el caracter nulo
    mov rdi,r12 ;movemos la longitud TAG_0 que queremos pedir
    call malloc
    mov r12,rax ;movemos el puntero (MSG_TAG_0) a r12 no volatil
    pop rdx
    mov byte[r12+rdx],0 ;en la longitud toddas le ultimo es NULL

    inc r13
    mov rdi,r13 ;movemos la longitud TAG_0 que queremos pedir
    call malloc
    mov r13,rax ;movemos el puntero (MSG_TAG_0) a r12 no volatil
    pop rcx
    mov byte[r13+rcx],0

    inc r14
    mov rdi,r14 ;movemos la longitud TAG_0 que queremos pedir
    call malloc
    mov r14,rax ;movemos el puntero (MSG_TAG_0) a r12 no volatil
    pop r10
    mov byte[r14+r10],0

    inc r15
    mov rdi,r15 ;movemos la longitud TAG_0 que queremos pedir
    call malloc
    mov r15,rax ;movemos el puntero (MSG_TAG_0) a r12 no volatil
    pop r11
    mov byte[r15+r11],0

;pido memoria para rax el cual es un array de 4 elementos que son punteros definidos con los malloc
    mov rdi,0x4 ; 4 por el tamaño de los punteros(8) = 32
    call malloc

    mov [rax],r12 ;muevo el puntero al mensaje  
    mov [rax+8],r13
    mov [rax+16],r14
    mov [rax+24],r15

    pop rsi
    pop rdi

    jmp .ciclo2
    

;como el espacio YA lo tenemos reservado en la memoria
;vamos a ir chequeando tag por tag y guardando es esas posiciones 

    xor rbx,rbx
    xor r9,r9
    xor r8,r8
    ;mov r11,rsi

.ciclo2:
    cmp rsi,0
    jmp .fin
    
    mov rbx,[rdi+OFFSET_tag] ;en rbx tengo el numero del tag
    mov r9,rdi  ;pongo el puntero donde esta el texto

    jmp .concateno
.vuelta:
    add rdi,SIZE_struct
    dec rsi
    jmp .ciclo2


.concateno:
    cmp byte[r9],NULL ;comparo la primera letra con NULL
    je .vuelta
    
    mov r8, rax
    mov r11,rax
    mov rax,SIZE_POINTER
    mul rbx
    add r8,rax
    mov rax,r11
    mov byte[r8],r9b ;copio el primer byte al acceder en la posicion correcta de rax
    inc r8
    inc r9



.fin:
    ;prologo
    pop rbp
    ret


