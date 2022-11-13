.SUFFIXES: .o .c .asm

CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie

.asm.o:
	nasm -f elf64 -g -F DWARF $^ -o $@

all: ej6

clean:
	rm -f main.o ej6.o ej6

ejercicio: main.o ej6.o
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: all clean