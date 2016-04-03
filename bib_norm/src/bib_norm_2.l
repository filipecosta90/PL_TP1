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
GHashTable *txt_fields_table; 
GHashTable *num_fields_table; 
char* field_id;
char* field;
char* author_id = "author";
char* title_id = "title";
char* author_key;
char* title_key;

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

%x INSIDE IN_AUTHOR IN_FIELD_TXT IN_FIELD_NUM INSIDE_CLEAN

%%

{CATEG}[^=]*,/\n?        {
                            printf("%s\n",yytext);
                            BEGIN INSIDE_CLEAN;
                         }

<INSIDE_CLEAN>[\n\r\t] {BEGIN INSIDE_CLEAN;}
<INSIDE_CLEAN>. {BEGIN INSIDE;}

<INSIDE>{TITLE_ID}{FIELD_START}  {   
                          yytext[yyleng-2]='\0';
                          BEGIN IN_FIELD_TXT;}

<INSIDE>{AUTHOR_ID}{FIELD_START}  {   
                          yytext[yyleng-2]='\0';
                          BEGIN IN_FIELD_TXT;}

<INSIDE>{FIELD_ID}/{LETRA_NUM}  {   
                         yytext[yyleng-1]='\0';
                          field_id = strdup ( yytext );
                          field_id = g_strchomp ( field_id );
                          field_id = g_strchug ( field_id );
                          BEGIN IN_FIELD_NUM; }

<INSIDE>{FIELD_ID}{FIELD_START}  {   
                          yytext[yyleng-2]='\0';
                          field_id = strdup ( yytext );
                          field_id = g_strchomp ( field_id );
                          field_id = g_strchug ( field_id );
                          if (strstr(field_id, author_id ) != NULL) {
                              author_key = strdup(field_id);
                              BEGIN IN_AUTHOR;
                          }
                          if (strstr(field_id, title_id ) != NULL) {
                              title_key = strdup(field_id);
                          }
                          if (strstr(field_id, author_id ) == NULL) {
                          BEGIN IN_FIELD_TXT;} 
                          }

<IN_AUTHOR>^.+?\\and     {   yytext[yyleng-3]='\0';
                          char *author;
                          author = strdup ( yytext );
                          author = g_strchomp ( author );
                          author = g_strchug ( author );
                          BEGIN IN_AUTHOR;
                          }

<IN_AUTHOR>{FIELD_BREAK}[ ]*, {
                          yytext[yyleng-2]='\0';
                          char* author;
                          author = g_strchomp ( author );
                          author = g_strchug ( author );
                          BEGIN INSIDE_CLEAN;}

<IN_FIELD_NUM>{FIELD_BREAK_NUM}[ ]*, {
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                           g_hash_table_insert (  num_fields_table, (void*) field_id,  (void*) field );
                            BEGIN INSIDE_CLEAN;}

<IN_FIELD_NUM>{FIELD_BREAK_NUM}[ ]*\n[ ]*\} {
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            g_hash_table_insert (  num_fields_table, (void*) field_id,  (void*) field );
                            pretty_print();

                            BEGIN INITIAL;}

<IN_FIELD_TXT>{FIELD_BREAK}[ ]*, {
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                           field = g_strchomp ( field );
                          field = g_strchug ( field );
                             g_hash_table_insert (  txt_fields_table, (void*) field_id,  (void*) field );
                            BEGIN INSIDE_CLEAN;}



<IN_FIELD_TXT>[^=]+{FIELD_BREAK}[ ]*\n[ ]*\} { 
                            yytext[yyleng-2]='\0';
                            field = strdup(yytext);
                            field = g_strchomp ( field );
                          field = g_strchug ( field );
                            g_hash_table_insert (  txt_fields_table, (void*) field_id,  (void*) field );
                            pretty_print();
                            BEGIN INITIAL;
                            }
%%

void pretty_print(){
int field_num = 0;
char* current_value;
if( title_key != NULL ){
    current_value =  g_hash_table_lookup ( txt_fields_table,(void*) title_key);
    g_hash_table_remove ( txt_fields_table, (void*) title_key);
    printf("\t%s {%s}", title_key, current_value);
    field_num++;
}
if ( author_key != NULL ){
    if(field_num > 0){ printf(",\n"); }
    current_value =  g_hash_table_lookup ( txt_fields_table,(void*) author_key);
    g_hash_table_remove ( txt_fields_table, (void*) author_key);
    printf("\t%s {%s}", author_key, current_value);
    field_num++;
}
int size = g_hash_table_size ( txt_fields_table );
size += g_hash_table_size ( num_fields_table );

GHashTableIter iter;
gpointer key, value;

g_hash_table_iter_init (&iter, txt_fields_table );
while (g_hash_table_iter_next (&iter, &key, &value))
  {
    if(field_num > 0 ){ printf(",\n"); }
   char* val = (char*) value;
   char* ke = (char*) key;
    printf("\t%s {%s}", ke, val);
 g_hash_table_iter_remove (&iter);
} 
g_hash_table_iter_init (&iter, num_fields_table );
while (g_hash_table_iter_next (&iter, &key, &value))
  {
    if(field_num > 0 ){ printf(",\n"); }
   char* val = (char*) value;
   char* ke = (char*) key;
    printf("\t%s %s", ke, val);
 g_hash_table_iter_remove (&iter);
        }
                            printf("\n}\n");
}

int yywrap(){return 1;}

int main(){
  txt_fields_table = g_hash_table_new(g_str_hash, g_str_equal);
  num_fields_table = g_hash_table_new(g_str_hash, g_str_equal);
  yylex();
  return (0);
}

