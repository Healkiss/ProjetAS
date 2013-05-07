%{
	//declarations c
	#include <stdlib.h>
	#include <stdio.h>
	#include "functions.h"
	#include "projet.tab.h"
	int typeVar(char*);
%}   
 
 //declarations d'etats lex  
%x DECLARATION_COOR
%x DECLARATION_PT
%x DECLARATION_LIST

%% 

\n {ECHO;return EOL;}
[0-9]+ {ECHO;yylval.scal = atoi(yytext);return NB;}
"--" {ECHO;return SEPARATOR;}
[+*()-/,=] {ECHO;return yytext[0];}
"draw" {ECHO;return DRAW;}
"fill" {ECHO;return FILL;}
"cycle" {ECHO;return CYCLE;}
";" {ECHO;return EOI;}
[a-z][a-zA-Z0-9]* {ECHO;yylval.str = strdup(yytext);return typeVar(strdup(yytext));}

"var_coor" {ECHO;BEGIN DECLARATION_COOR;return VAR_COOR;}
"var_pt" {ECHO;BEGIN DECLARATION_PT;return VAR_PT;}
"var_list" {ECHO;BEGIN DECLARATION_LIST;return VAR_LIST;}

<DECLARATION_COOR>[,=] {ECHO;return yytext[0];}
<DECLARATION_PT>[(),=] {ECHO;return yytext[0];}
<DECLARATION_LIST>[()-,=] {ECHO;return yytext[0];}

<DECLARATION_COOR>";" {BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_PT>";" {BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_LIST>";" {BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_LIST>"--" {ECHO;return SEPARATOR;}

<DECLARATION_COOR>[a-z][a-zA-Z0-9]* {ECHO;yylval.str = strdup(yytext);return VAR_NAME_COOR;}
<DECLARATION_PT>[a-z][a-zA-Z0-9]* {ECHO;yylval.str = strdup(yytext);return VAR_NAME_PT;}
<DECLARATION_LIST>[a-z][a-zA-Z0-9]* {ECHO;yylval.str = strdup(yytext);return VAR_NAME_LIST;}

<DECLARATION_COOR>[0-9]+ {ECHO;yylval.scal = atoi(yytext);return NB;}
<DECLARATION_PT>[0-9]+ {ECHO;yylval.scal = atoi(yytext);return NB;}
<DECLARATION_LIST>[0-9]+ {ECHO;yylval.scal = atoi(yytext);return NB;}
%%
 int typeVar(char* varname){
	if(chercherDansCoor(varname) == 1){
		return VAR_NAME_COOR;
	}
	if(chercherDansPoint(varname) == 1)
		return VAR_NAME_PT;
	return VAR_NAME_LIST;
}

int chercherDansCoor(char *varname){
	Liste_coor temp = GlobalListeCoor;
	char * id;
	int resultat;
    while(temp != NULL)
    {
    	id = temp->coor->id;
    	resultat = strcmp(id, varname);
    	if (strcmp(id, varname) == 0){
    		return 1;
    	}
        temp = temp->nxt;
        
    }
    return 0;
}
int chercherDansPoint(char *varname){
	Liste_point temp = GlobalListePoint;
	char * id;
    while(temp != NULL)
    {
    	if (strcmp(temp->point->id, varname) == 0)
    		return 1;
        temp = temp->nxt;
    }
    return 0;
}
