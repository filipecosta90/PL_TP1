%{

/*
********************************************************************************
*   Copyright(C) 2016 Filipe Oliveira, Universidade do Minho
*   All Rights Reserved.
*
********************************************************************************
*   Content : Simple bibtex category counter (phDThesis, Misc, InProceeding,
*             etc.), that occur in a document
*
********************************************************************************/

#include <stdio.h>
#include <glib.h>
#include <stdlib.h>
#include <string.h>

//HashTable
GHashTable *coautor_table; 
int flag = 0;

%}

%x AUTOR_STATE

LETRA [A-Za-z]
CATEG ^@{LETRA}+\{ 
AUTOR_START author[ ]*=[ ]*[\"\{]

%%

{AUTOR_START}         { printf("##\t\tAuthors:::::.%s\n", yytext); BEGIN AUTOR_STATE; }
<AUTOR_STATE>.+(\\\{[^\}]\})?and      { printf("##\t\tAuthor:%s\n",yytext); BEGIN AUTOR_STATE; }
<AUTOR_STATE>[^\}]+(\\\{[^\}]\})?[^\}]*(\}|\")  { printf("##\t\tEnd Author:%s\n",yytext); BEGIN INITIAL; }

.|\n|\t      {;}

%%

int yywrap(){return 1;}


static void print_key_value(gpointer key, gpointer value, gpointer userdata)
{
        int val = (int) value;
        char* ke = (char*) key;
        printf("<li>%s : %d</li>\n", ke, val);
}


int main(){
  coautor_table = g_hash_table_new(g_str_hash, g_str_equal);
  yylex();
  printf("\n\n%d\n\n<!DOCTYPE html>\n<html>\n<body>\n<ul>\n", flag);
  //g_hash_table_foreach(table,print_key_value, NULL );
  printf("</ul>\n</body>\n</html>\n");
  return (0);
}

