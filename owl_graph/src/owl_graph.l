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

char* relation;
char* begin;
char* end;
char* data;
char* class;
char* value;

void print_prop();
void print_data();
%}

LETRA [A-Za-z]
LETRA_NUM [0-9A-Za-z]
NUM [0-9]
OBJ_PROP_AXIOM SubObjectPropertyOf|EquivalentObjectProperties|DisjointObjectProperties|InverseObjectProperties|ObjectPropertyDomain|ObjectPropertyRange|FunctionalObjectProperty|InverseFunctionalObjectProperty|ReflexiveObjectProperty|IrreflexiveObjectProperty|SymmetricObjectProperty|AsymmetricObjectProperty|TransitiveObjectProperty
DAT_PROP_AXIOM SubDataPropertyOf|EquivalentDataProperties|DisjointDataProperties|DataPropertyDomain|DataPropertyRange|FunctionalDataProperty

%x IN_PROP IN_DATA RELATION RELATION_BEG_END DATA DATA_BEG_END VALUE

%%


[^<>]*<{DAT_PROP_AXIOM}> { BEGIN IN_DATA; }
[^<>]*<{OBJ_PROP_AXIOM}> { BEGIN IN_PROP; }


<IN_DATA>[^<>]*<DataProperty[ \t\n]*IRI=\" { BEGIN DATA;}
<IN_DATA>[^<>]*<Class[ \t\n]*IRI=\" { BEGIN DATA_BEG_END;}
<IN_DATA>[^<>]*<Datatype[ \t\n]*abbreviatedIRI=\" {  BEGIN VALUE;}

<DATA>[^">]* { data=strdup(yytext);} 

<DATA_BEG_END>[^">]* { class = strdup(yytext); }
<VALUE>[^">]* { value = strdup(yytext); print_data(); }

<IN_DATA><\\ {BEGIN INITIAL;}
<DATA>\/> {BEGIN IN_DATA;}
<DATA_BEG_END>\/> {BEGIN INITIAL;}
<VALUE>\/> {BEGIN IN_DATA;}

<DATA>.|\n {;}
<DATA_BEG_END>.|\n {;}
<VALUE>.|\n {;}
<IN_DATA>.|\n {;}


<IN_PROP>[^<>]*<ObjectProperty[ \t\n]*IRI=\" {BEGIN RELATION;}
<IN_PROP>[^<>]*<Class[ \t\n]*IRI=\" {BEGIN RELATION_BEG_END;}

<RELATION>[^">]* { relation=strdup(yytext);} 

<RELATION_BEG_END>[^">]* {
if ( begin == NULL ){
                  begin = strdup(yytext);
                }
                else{
                  end = strdup(yytext);
                  print_prop();
                } 
                }

<IN_PROP><\\ {BEGIN INITIAL;}
<RELATION>\/> {BEGIN IN_PROP;}
<RELATION_BEG_END>\/> {BEGIN INITIAL;}

<RELATION>.|\n {;}
<RELATION_BEG_END>.|\n {;}
<IN_PROP>.|\n {;}
<INITIAL>.|\n {;}

%%

void print_data(){
printf("\"%s\" [shape = box, style=rounded, fontsize=12 fontname=helvetica];\n", class);
printf("\"%s\" [shape = box, style=filled,color=\"red\", fontsize=12 fontname=helvetica];\n", value);
printf("\"%s\" -> \"%s\" [ label = \"%s\" ]\n", class, value, data );
class=NULL;
value=NULL;
data=NULL;
}

void print_prop(){
printf("\"%s\" [shape = box, style=rounded, fontsize=12 fontname=helvetica];\n", begin);
printf("\"%s\" -> \"%s\" [ label = \"%s\" ]\n", begin, end, relation );
begin=NULL;
relation=NULL;
end=NULL;
}

void graph_print(){

 GHashTableIter iter;
 gpointer key, value;

printf( "digraph pl_2_1 {\n//title\nlabelloc=\"t\";\nlabel=\"OWL concept diagram\";rankdir=TB;\nresolution=300;size=\"8,5\";\n");
} 

int yywrap(){return 1;}

int main(int argc, char** argv){
  graph_print();
yylex();
printf("}\n");
  return (0);
}

