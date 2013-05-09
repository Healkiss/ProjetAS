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
%x DECLARATION_IMG
%x COLORATION
%x COMMENT
%x STRING
%s IMAGE

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
"translate" 					{ECHO;return TRANSLATE;}
"rotate" 						{ECHO;return ROTATE;}
"cycle" 						{ECHO;return CYCLE;}
";" 							{ECHO;return EOI;}

"image{" 						{ECHO;BEGIN IMAGE; profondeur++; printf("%s profondeur %i %s\n",BLUE,profondeur,WHITE);return IMAGE;}
<IMAGE>"}"						{ECHO;BEGIN INITIAL; profondeur--; printf("%s profondeur %i %s \n",BLUE, profondeur, WHITE);return yytext[0];}
[a-z][a-zA-Z0-9]* 				{ECHO;yylval.str = strdup(yytext);
									int type = typeVar(strdup(yylval.str));
									if(!type){
										printf("\n%s<<la variable \"%s\" n'existe pas>>%s\n", RED, yytext, WHITE);
										return VARERROR;
									}else{
										//printf("\n%s<<variable \"%d\" existe >>%s\n", RED, type, WHITE);
										return type;
									}
								}
								
"SET_COLOR"						{ECHO;BEGIN COLORATION;return SET_COLOR;}
<COLORATION>[0-9]+,[0-9]+,[0-9]+,[0-9]+	{ECHO;}
<COLORATION>";" 				{ECHO;BEGIN INITIAL;return EOI;}

"var_coor" 						{ECHO;BEGIN DECLARATION_COOR;return VAR_COOR;}
"var_pt" 						{ECHO;BEGIN DECLARATION_PT;return VAR_PT;}
"var_list" 						{ECHO;BEGIN DECLARATION_LIST;return VAR_LIST;}
"var_img" 						{ECHO;BEGIN DECLARATION_IMG;return VAR_IMG;}

<DECLARATION_COOR>[,=] 			{ECHO;return yytext[0];}
<DECLARATION_PT>[(),=] 			{ECHO;return yytext[0];}
<DECLARATION_LIST>[()-,=] 		{ECHO;return yytext[0];}
<DECLARATION_IMG>[,=]	 		{ECHO;return yytext[0];}

<DECLARATION_COOR>";" 			{BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_PT>";" 			{BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_LIST>";" 			{BEGIN INITIAL;ECHO;return EOI;}
<DECLARATION_LIST>"--" 			{ECHO;return SEPARATOR;}
<DECLARATION_IMG>";" 			{BEGIN INITIAL;ECHO;return EOI;}

<DECLARATION_COOR>[a-z][a-zA-Z0-9]* 	{ECHO;yylval.str = strdup(yytext);return VAR_NAME_COOR;}
<DECLARATION_PT>[a-z][a-zA-Z0-9]* 		{ECHO;yylval.str = strdup(yytext);return VAR_NAME_PT;}
<DECLARATION_LIST>[a-z][a-zA-Z0-9]* 	{ECHO;yylval.str = strdup(yytext);return VAR_NAME_LIST;}
<DECLARATION_IMG>[a-z][a-zA-Z0-9]* 		{ECHO;yylval.str = strdup(yytext);return VAR_NAME_IMG;}

<DECLARATION_COOR>[0-9]+ 		{ECHO;yylval.val_scal = atof(strdup(yytext));return NB;}
<DECLARATION_PT>[0-9]+			{ECHO;yylval.val_scal = atof(strdup(yytext));return NB;}
<DECLARATION_LIST>[0-9]+ 		{ECHO;yylval.val_scal = atof(strdup(yytext));return NB;}
<DECLARATION_IMG>[0-9]+ 		{ECHO;yylval.val_scal = atof(strdup(yytext));return NB;}

%%
int typeVar(char* varname){
	//afficherCoors(GlobalListeCoor, 0);
	//afficherImages(GlobalListeImage, 0);
	if(existeDansCoor(GlobalListeCoor, profondeur, varname) == 1)
		return VAR_NAME_COOR; 
	if(existeDansPoint(GlobalListePoint, profondeur, varname) == 1)
		return VAR_NAME_PT;
	if(existeDansChemin(GlobalListeChemin, profondeur, varname) == 1)
		return VAR_NAME_LIST;
	if(existeDansImage(GlobalListeImage, profondeur, varname) == 1)
		return VAR_NAME_IMG;
	return 0;
}

