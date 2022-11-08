; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"

global start


; COMPLETAR - Agreguen declaraciones extern según vayan necesitando
;-------------------Taller modo protegido----------------------
extern print_text_pm
extern print_text_rm
extern A20_disable
extern  A20_check
extern A20_enable
extern GDT_DESC
extern screen_draw_layout

;--------------------Taller Interrupcion----------------------
extern idt_init
extern IDT_DESC
extern pic_enable
extern pic_reset
extern mmu_init_kernel_dir

; COMPLETAR - Definan correctamente estas constantes cuando las necesiten
%define CS_RING_0_SEL 8   ;CODE SELECTOR
%define DS_RING_0_SEL 24  ;DATA SELECTOR


; en /home/.bashrc al final agregar export BXSHARE="/opt/bochs-2.7/bios"
; source ~/.bashrc

BITS 16
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

bienvenida db     'Bienvenid a modo real'
bienvenida_len equ    $ - bienvenida

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; COMPLETAR - Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO REAL
    ; (revisar las funciones definidas en print.mac y los mensajes se encuentran en la
    ; sección de datos)

    print_text_rm start_rm_msg, start_rm_len, 0x000e, 0x000a, 0x000a

    ; COMPLETAR - Habilitar A20
    ; (revisar las funciones definidas en a20.asm)
    call A20_disable
    call A20_check
    call A20_enable
    call A20_check

    ; COMPLETAR - Cargar la GDT
    lgdt [GDT_DESC]
    ;xchg bx,bx ;magic breakpoint
    


    ; COMPLETAR - Setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 1 
    mov cr0, eax
    ; COMPLETAR - Saltar a modo protegido (far jump)
    ; (recuerden que un far jmp se especifica como jmp CS_selector:address)
    ; Pueden usar la constante CS_RING_0_SEL definida en este archivo
    jmp CS_RING_0_SEL:modo_protegido

BITS 32
modo_protegido:
    ; COMPLETAR - A partir de aca, todo el codigo se va a ejectutar en modo protegido
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    ; Pueden usar la constante DS_RING_0_SEL definida en este archivo
    mov eax, DS_RING_0_SEL
    mov ds, eax
    mov es, eax
    mov gs, eax
    mov fs, eax
    mov ss, eax 
    ; COMPLETAR - Establecer el tope y la base de la pila
    mov ebp, 0x25000
    mov esp, 0x25000
    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO PROTEGIDO
    print_text_pm start_pm_msg, start_pm_len, 0x000e, 0x000a, 0x000a

    xchg bx,bx ;magic breakpoint
    ; COMPLETAR - Inicializar pantalla
    
    call screen_draw_layout

    ; COMPLETAR - Cargar la IDT
    call idt_init
    lidt [IDT_DESC]
    ;xchg bx,bx ;magic breakpoint
    
    call pic_reset
    call pic_enable
    

    call mmu_init_kernel_dir
    mov cr3,eax
    ;inicializar CR3
    mov eax, cr0
    or eax,0x80000000
    mov cr0, eax
    
    xchg bx,bx
    

    sti

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
