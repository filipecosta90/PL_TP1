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
char* author_id;
char* title_id;

//function sig
void pretty_print();

%}

LETRA [A-Za-z]
LETRA_NUM [0-9A-Za-z]
NUM [0-9]
CATEG \@{LETRA}+\{
FIELD_ID [^=]+=[ ]*
FIELD_BREAK [^=]+(\"|\})
FIELD_BREAK_NUM [^=]+
FIELD_START [\{\"]
AUTHOR_ID author[ ]*=[ ]*
TITLE_ID title[ ]*=[ ]*

%x INSIDE IN_FIELD_TXT IN_FIELD_NUM INSIDE_CLEAN

%%

{CATEG}[^=]*,/\n?            {
                            printf("%s|\n", yytext);
                            BEGIN INSIDE_CLEAN;
                         }

<INSIDE_CLEAN>[\n\r\t] {BEGIN INSIDE_CLEAN;}
<INSIDE_CLEAN>. {BEGIN INSIDE;}

<INSIDE>{TITLE_ID}{FIELD_START}  {   
                          yytext[yyleng-2]='\0';
                          printf("TIT %s {", yytext);
                          BEGIN IN_FIELD_TXT;}

<INSIDE>{AUTHOR_ID}{FIELD_START}  {   
                          yytext[yyleng-2]='\0';
                          printf("AUT|%s {", yytext);
                          BEGIN IN_FIELD_TXT;}

<INSIDE>{FIELD_ID}/{LETRA_NUM}  {   
                         yytext[yyleng-1]='\0';
                          printf("NUM|%s|\n", yytext);
                          field_id = strdup(yytext);

                          BEGIN IN_FIELD_NUM; }

<INSIDE>{FIELD_ID}{FIELD_START}  {   
                          yytext[yyleng-2]='\0';
                          field_id = strdup ( yytext );
                          field_id = g_strchomp ( field_id );
                          field_id = g_strchug ( field_id );
                          printf("TXT|%s|\n", field_id );
                          BEGIN IN_FIELD_TXT; }


<IN_FIELD_NUM>{FIELD_BREAK_NUM}[ ]*, {
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            g_hash_table_insert (  fields_table, (void*) field_id,  (void*) field );
                            //printf("\t\tfield %s\nEND FIELD\n", yytext );
                            BEGIN INSIDE_CLEAN;}

<IN_FIELD_NUM>{FIELD_BREAK_NUM}[ ]*\n[ ]*\} {
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            g_hash_table_insert (  fields_table, (void*) field_id,  (void*) field );
                            //printf("\t\tfield %s\nEND FIELD\n", yytext );
                            pretty_print();
                            BEGIN INITIAL;}

<IN_FIELD_TXT>{FIELD_BREAK}[ ]*, {
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            g_hash_table_insert (  fields_table, (void*) field_id,  (void*) field );
                            //printf("\t\tfield %s\nEND FIELD\n", yytext );
                            BEGIN INSIDE_CLEAN;}



<IN_FIELD_TXT>[^=]+{FIELD_BREAK}[ ]*\n[ ]*\} { 
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            g_hash_table_insert (  fields_table, (void*) field_id,  (void*) field );
                            //printf("\t\tfield %s\n END FIELD\n", yytext );
                            pretty_print();
                            BEGIN INITIAL;
                            }


%%

void pretty_print(){



}

int yywrap(){return 1;}

int main(){
  fields_table = g_hash_table_new(g_str_hash, g_str_equal);
  yylex();
  return (0);
}

