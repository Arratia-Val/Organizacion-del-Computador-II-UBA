#include <stdio.h>
#include <stdlib.h>

#include "stack.h"
#include "student.h"
#include "teacher.h"

stack_t *stack;

int main()
{

    stack = createStack(100);
    
    student_t stud1 = {
        .name = "Steve Balmer",
        .dni = 12345678,
        .califications = {3,2,1},
        .concept = -2,
    };

    studentp_t stud2 = {
        .name = "Linus Torvalds",
        .dni = 23456789,
        .califications = {9,7,8},
        .concept = 1,
    };

    student_t *st1p = &stud1;
    studentp_t *st2p = &stud2;
    
    // Completar: pushear en la pila ambos estudiantes
    push(stack,st1p);
    push(stack,st2p);
    
    // Una "lista" de profesores:
    teacher_t *teachers = malloc(3*sizeof(teacher_t));
    
    // Completar: pushear la lista de profesores a la pila
    int size= sizeof(teachers)/sizeof(teacher_t);
    teachers[0].name = "Alejandro Furfaro";
    /*for(int i=0; i<3 && teachers[i].name != NULL; i++){
        push(stack,&teachers[i]);
    }
    */
    push(stack,&teachers[0]);
   // printf(stack->top(stack));
    
    printf("Nombre del profesor: %s\n", ((teacher_t *) stack->top(stack))[0].name);
    
    //Completar: Imprimir estudiantes 1 y 2 desde la pila

        printStudent(st1p);
        printStudentp(st2p);


    return 0;
}
