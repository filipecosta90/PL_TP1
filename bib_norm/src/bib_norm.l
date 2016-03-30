%{

#include <stdio.h>
#include <glib.h>
#include <stdlib.h>
#include <string.h>

char* eu;
char* ele;
int contador = 0;

//HashTable
GHashTable *table; 

%}

LETRA [A-Za-z]
CATEG ^@{LETRA}+\{ 

%%
{CATEG}      {
              yytext++; yytext[yyleng-2]='\0'; printf("%s",yytext);
              char* key = strdup(yytext);
              if ( g_hash_table_contains ( table ,(void*) key ) ){
                int value = (int) g_hash_table_lookup ( table,(void*) key);
  value++;
g_hash_table_replace (  table, (void*) key, (void*) value );
                  //            printf("%s already exists: \n", yytext );
              }
              else {
              int value = 1;
//              printf("\t>>>>>>>>>>>>>>>>>>>>>>>>>>>>NEW %s: \n", yytext );
              gboolean add_result = g_hash_table_insert (  table, (void*) key, (void*) value );
//              add_result == 1 ? printf("ADD OK\n") : printf("!!!!!! ERROR ADD !!!!!!!!\n");
}
             }
.            { }
%%

int yywrap(){return 1;}


static void print_key_value(gpointer key, gpointer value, gpointer userdata)
{
        int val = (int) value;
        char* ke = (char*) key;
        printf("%s %d\n", ke, val);

}


int main(){
  table = g_hash_table_new(g_str_hash, g_str_equal);

yylex();
g_hash_table_foreach(table,print_key_value, NULL );
return (0);
}

