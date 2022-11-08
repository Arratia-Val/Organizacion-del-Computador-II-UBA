%define OFFSET_text 0
%define OFFSET_text_len 8
%define OFFSET_tag 12
%define OFFSET_struct 16


global agrupar

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;char** agrupar(msg_t *msgArr, size_t msgArr_len);
; msgArr: rdi , msgArr_Len : rsi 
agrupar:

    push rbp
    mov rbp,rsp

    ;mov rcx, 0x4 
    mov r9,rdi 
    
    
    mov r12,rsi 

.ciclo0:
    cmp r12,0
    je .finC0  
    dec r12 
    mov edx,[r9+OFFSET_tag] 
    cmp edx,0   
    je .agregar  
    
    add r9,OFFSET_struct       
    jmp .ciclo0 
.finC0:;

    mov r9,rdi
    mov r12,rsi
.ciclo1:
    
    cmp r12,0
    je .finC1 
    dec r12 
  
    mov edx,[r9+OFFSET_tag] 
    cmp edx,1
    je .agregar

    add r9,OFFSET_struct  
    jmp .ciclo1
.finC1:;

    mov r9,rdi
    mov r12,rsi

.ciclo2:

    cmp r12,0
    je .finC2
    dec r12 

   
    mov edx,[r9+OFFSET_tag] 
    cmp edx,2
    je .agregar
    add r9,OFFSET_struct  
    jmp .ciclo2
.finC2:;
    mov r9,rdi
    mov r12,rsi

.ciclo3:
    
    cmp r12,0
    je .finC3
    dec r12 
  
    mov edx,[r9+OFFSET_tag]
    cmp edx,3
    je .agregar
    add r9,OFFSET_struct
    jmp .ciclo3
.finC3:;

.fin:
    push rax
    pop rax
    pop rbp
    ret


.agregar:
  
    mov rax,rdi
    ;add rax,[rdi+OFFSET_text_len]  ;muevo en rax la dire
    ;del texto
    ;add rax,8
    ;add r9,4 

    add r9,OFFSET_struct
    cmp edx,0
    je .ciclo0
    cmp edx,1
    je .ciclo1
    cmp edx,2
    je .ciclo2
    cmp edx,3
    je .ciclo3





