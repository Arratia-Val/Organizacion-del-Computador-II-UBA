CC = c99
CFLAGS = -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie
NASM = nasm
NASMFLAGS = -f elf64 -g -F DWARF


OBJS = main.o vectores.o

all: main

main: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

main.o: main.c vectores.h
	$(CC) $(CFLAGS) -c $< -o $@

vectores.o: vectores.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f main
