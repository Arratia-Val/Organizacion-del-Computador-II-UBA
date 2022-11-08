#include "student.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>


void printStudent(student_t *stud)
{
    /* Imprime por consola una estructura de tipo student_t
    */

    printf("Nombre: %s\n", stud->name);
    printf("dni: %d\n", stud->dni);

        //int size= sizeof(stud->califications)/sizeof(stud->califications[0])   ;
    printf("%s", "califications: ");
    for(int i=0;i<sizeof(stud->califications)-1;i++){
        printf("%d, ", stud->califications[i]);
    };
    printf("%d\n", stud->califications[sizeof(stud->califications)-1]);

    printf("concept: %d\n", stud->concept);

}

void printStudentp(studentp_t *stud)
{
    /* Imprime por consola una estructura de tipo studentp_t
    */
    printf("Nombre: %s\n", stud->name);
    printf("dni: %d\n", stud->dni);

        //int size= sizeof(stud->califications)/sizeof(stud->califications[0])   ;
    printf("%s", "califications: ");
    for(int i=0;i<sizeof(stud->califications)-1;i++){
        printf("%d, ", stud->califications[i]);
    };
    printf("%d\n", stud->califications[sizeof(stud->califications)-1]);

    printf("concept: %d\n", stud->concept);
}
