NASM:=nasm
NASMFLAGS:=-Wall -f elf64 -g -F DWARF -Wall

SRCS:= medir-stack.asm \
		main.c \
       Ej1.asm

TARGET:=app

OBJS=$(SRCS:.asm=.o)

all: $(TARGET)

%.o: %.asm 
	$(NASM) $(NASMFLAGS) $< -o $@

$(TARGET): $(OBJS)
	ld -o $@ $^


clean:
	rm -f main.o medir-stack.o Ej1.o app





.PHONY: all clean
