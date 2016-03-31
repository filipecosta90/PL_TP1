
CC = gcc
LIBLDIR=
#include
INCLUDE= 
#flags
CFLAGS= -std=c99 -m64 -Iinclude -Ilib/glib-2.0 -Ilib/glib-2.0/include -lglib-2.0 

a1: lex.yy.o 
	$(CC) $(INCLUDE)  $(CFLAGS) -o bib_norm_1 lex.yy.c  

a3: lex.yy.o 
	$(CC) $(INCLUDE)  $(CFLAGS) -o bib_norm_3 lex.yy.c  

all: a1 a3

.PHONY: clean
clean:
	rm  *.o && rm bib_norm_1 bib_norm_3
