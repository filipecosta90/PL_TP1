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
GHashTable *fields_table; 
char* field_id;
char* field;

%}

LETRA [A-Za-z]
LETRA_NUM [0-9A-Za-z]
NUM [0-9]
CATEG \@{LETRA}+\{
FIELD_ID [^=]*=[ ]*
NORM \{
NON_NORM \"

%x INSIDE IN_FIELD_NOR IN_FIELD_NON

%%
{CATEG}[^=]*,            {
                            printf("%s\n", yytext);
                            BEGIN INSIDE;
                         }

<INSIDE>{FIELD_ID}/{NUM}  {   
                         // yytext[yyleng-2]='\0';
                          field_id = strdup(yytext);
                          //printf("START FIELD normalized: %s::::\n", yytext); 
                          BEGIN IN_FIELD_NUM; }

<INSIDE>{FIELD_ID}{NORM}  {   
                          yytext[yyleng-2]='\0';
                          field_id = strdup(yytext);
                          //printf("START FIELD normalized: %s::::\n", yytext); 
                          BEGIN IN_FIELD_NOR; }

<INSIDE>{FIELD_ID}{NON_NORM}  { 
                          yytext[yyleng-2]='\0';
                          field_id = strdup(yytext);
                          //printf("START FIELD non-normalized: %s::::::X:X:X:X:X:\n", yytext); 
                          BEGIN IN_FIELD_NON; }

<IN_FIELD_TXT>[^=]+\"[ ]*, {
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            g_hash_table_insert (  fields_table, (void*) field_id,  (void*) field );
                            //printf("\t\tfield %s\nEND FIELD\n", yytext );
                            BEGIN INSIDE;}

<IN_FIELD_TXT>[^=]+\"[ ]*\n[ ]*\} { 
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            g_hash_table_insert (  fields_table, (void*) field_id,  (void*) field );
                            //printf("\t\tfield %s\n END FIELD\n", yytext );
                            BEGIN INITIAL;
                            }

.|\n|\t { ; }
%%

int yywrap(){return 1;}



int main(){
  fields_table = g_hash_table_new(g_str_hash, g_str_equal);
  yylex();
  return (0);
}

