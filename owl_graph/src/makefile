
CC = gcc
LIBLDIR=
#include
INCLUDE= 
#flags
CFLAGS= -std=c99 -m64 -Iinclude -Ilib/glib-2.0 -Ilib/glib-2.0/include -lglib-2.0 

a1: lex.yy.o 
	$(CC) $(INCLUDE)  $(CFLAGS) -o owl_graph lex.yy.c  

all: a1 

.PHONY: clean
clean:
	rm  *.o && rm owl_graph
