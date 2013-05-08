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
%x COLORATION
%x COMMENT
%x STRING

%% 

\" 								{printf("%s",yytext); BEGIN STRING; }
\/\* 							{BEGIN COMMENT;}
<COMMENT>\*\/ 					{BEGIN INITIAL;}
<COMMENT>(.|\n) 				{}
<STRING>\\\"					ECHO;
<STRING>\" 						{printf("%s",yytext); BEGIN INITIAL;}
<STRING>(.|\n) 					ECHO;
^\/\/.*n 						{} 
\/\/.*$ 						{}

\n 								{ECHO;return EOL;}
[[:digit:]]+ 					{
									ECHO; yylval.val_scal = atof(yytext);
									/*printf	("\n%s<<digit yytext : %s | atof(strdup(yytext)) : %f | yylval.val_scal %f >>%s\n",
												YELLOW, yytext, atof(strdup(yytext)), yylval.val_scal, WHITE
											);*/
									return NB;
								}
"--" 							{ECHO;return SEPARATOR;}
[+*()-/,=] 						{ECHO;return yytext[0];}
"draw" 							{ECHO;return DRAW;}
"fill" 							{ECHO;return FILL;}
"cycle" 						{ECHO;return CYCLE;}
";" 							{ECHO;return EOI;}
[a-z][a-zA-Z0-9]* 				{ECHO;yylval.str = strdup(yytext);
									if(!typeVar(strdup(yylval.str))){
										printf("\n%s<<la variable \"%s\" n'existe pas %s >>%s\n", RED, yytext, WHITE);
										return VARERROR;
									}else{
										return typeVar(strdup(yylval.str));
									}
								}
"SET_COLOR"						{ECHO;BEGIN COLORATION;return SET_COLOR;}
<COLORATION>[0-9]+,[0-9]+,[0-9]+,[0-9]+	{ECHO;}
<COLORATION>";" 				{ECHO;BEGIN INITIAL;return EOI;}

"var_coor" 						{ECHO;BEGIN DECLARATION_COOR;return VAR_COOR;}
"var_pt" 						{ECHO;BEGIN DECLARATION_PT;return VAR_PT;}
"var_list" 						{ECHO;BEGIN DECLARATION_LIST;return VAR_LIST;}
"var_img" 						{ECHO;BEGIN DECLARATION_LIST;return VAR_IMG;}

<DECLARATION_COOR>[,=] 			{ECHO;return yytext[0];}
<DECLARATION_PT>[(),=] 			{ECHO;return yytext[0];}
<DECLARATION_LIST>[()-,=] 		{ECHO;return yytext[0];}

<DECLARATION_COOR>";" 			{BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_PT>";" 			{BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_LIST>";" 			{BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_LIST>"--" 			{ECHO;return SEPARATOR;}

<DECLARATION_COOR>[a-z][a-zA-Z0-9]* 	{ECHO;yylval.str = strdup(yytext);return VAR_NAME_COOR;}
<DECLARATION_PT>[a-z][a-zA-Z0-9]* 		{ECHO;yylval.str = strdup(yytext);return VAR_NAME_PT;}
<DECLARATION_LIST>[a-z][a-zA-Z0-9]* 	{ECHO;yylval.str = strdup(yytext);return VAR_NAME_LIST;}

<DECLARATION_COOR>[0-9]+ 		{ECHO;yylval.val_scal = atof(strdup(yytext));return NB;}
<DECLARATION_PT>[0-9]+			{ECHO;yylval.val_scal = atof(strdup(yytext));return NB;}
<DECLARATION_LIST>[0-9]+ 		{ECHO;yylval.val_scal = atof(strdup(yytext));return NB;}
%%
int typeVar(char* varname){
	if(existeDansCoor(GlobalListeCoor, profondeur, varname) == 1)
		return VAR_NAME_COOR;
	if(existeDansPoint(GlobalListePoint, profondeur, varname) == 1)
		return VAR_NAME_PT;
	if(existeDansChemin(GlobalListeChemin, profondeur, varname) == 1)
		return VAR_NAME_LIST;
	if(existeDansImage(GlobalListeImage, profondeur, varname) == 1)
		return VAR_NAME_LIST;
	return 0;
}

