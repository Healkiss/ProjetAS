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

%% 
 
[0-9]+ {ECHO;yylval = atoi(yytext);return NB;}
"--" {ECHO;return SEPARATOR;}
 /*[+*] {ECHO;return yytext[0];}*/
"," {ECHO;return yytext[0];}
"(" {ECHO;return yytext[0];}
")" {ECHO;return yytext[0];}
"draw" {ECHO;return DRAW;}
"fill" {ECHO;return FILL;}
%%  
