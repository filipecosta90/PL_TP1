
CC = gcc
LIBLDIR=
#include
INCLUDE= 
#flags
CFLAGS= -std=c99 -m64 -Iinclude -Ilib/glib-2.0 -Ilib/glib-2.0/include -lglib-2.0 

pl: lex.yy.o 
	$(CC) $(INCLUDE)  $(CFLAGS) -o bib_norm lex.yy.c  
all: pl

.PHONY: clean
clean:
	rm  *.o && rm bib_norm 
