CC = g++
CFLAGS = -Wall -m64

all: main.o f.o
	$(CC) $(CFLAGS) -o fun main.o f_a.o -lglut -lGLU -lGL

f.o: f.s
	nasm -f elf64 -o f_a.o f.s

main.o: main.cpp
	$(CC) $(CFLAGS) -c -o main.o main.cpp

clean:
	rm -f *.o
