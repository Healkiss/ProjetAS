%{
	//declarations c
	#include <stdlib.h>
	#include <stdio.h>
	#include "projet.tab.h"
	int pos = 0;
	int begin = 1;
	int depth = 0; 
%}   
 
 //declarations d'etats lex  
%x DECLARATION_COOR
%x DECLARATION_PT
%x DECLARATION_LIST

%% 

\n {ECHO;return EOL;}
[0-9]+ {ECHO;yylval = atoi(yytext);return NB;}
"--" {ECHO;return SEPARATOR;}
[+*()-/,=] {ECHO;return yytext[0];}
"draw" {ECHO;return DRAW;}
"fill" {ECHO;return FILL;}
"cycle" {ECHO;return CYCLE;}
";" {ECHO;return EOI;}



"var_coor" {ECHO;BEGIN DECLARATION_COOR;return VAR_COOR;}
"var_pt" {ECHO;BEGIN DECLARATION_PT;return VAR_PT;}
"var_list" {ECHO;BEGIN DECLARATION_LIST;return VAR_LIST;}
<DECLARATION_COOR>[,=] {ECHO;return yytext[0];}
<DECLARATION_PT>[(),=] {ECHO;return yytext[0];}
<DECLARATION_LIST>[()-,=] {ECHO;return yytext[0];}
<DECLARATION_LIST>"--" {ECHO;return SEPARATOR;}
<DECLARATION_COOR>";" {BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_PT>";" {BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_LIST>";" {BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_COOR>[a-z][a-zA-Z0-9]* {ECHO;yylval = yytext;return VAR_NAME;}
<DECLARATION_PT>[a-z][a-zA-Z0-9]* {ECHO;yylval = yytext;return VAR_NAME;}
<DECLARATION_LIST>[a-z][a-zA-Z0-9]* {ECHO;yylval = yytext;return VAR_NAME;}
<DECLARATION_COOR>[0-9]+ {ECHO;yylval = atoi(yytext);return NB;}
<DECLARATION_PT>[0-9]+ {ECHO;yylval = atoi(yytext);return NB;}
<DECLARATION_LIST>[0-9]+ {ECHO;yylval = atoi(yytext);return NB;}
%%  
