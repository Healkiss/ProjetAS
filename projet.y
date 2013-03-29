%{
#include <stdio.h>
#include <stdlib.h>
%}
 /*
 %union {
 	double reel
 	int nb
 }
 %token <nb> NB
 %token <reel> REEL
 ensuite on s'en ser en faisant
 yylaval.nb=atoi...
 ou
 yylvla.reel=atoi
 */
%token  NB
%token  DRAW
%token  FILL
%token SEPARATOR
%left '+''-'
%left '*'
%nonassoc UMINUS

%%
	input : commande liste
			;
			
	commande : DRAW {printf(" -> draw executé");}
		| FILL {printf(" -> fill executé");}
			;
	
	liste : point
		| point SEPARATOR liste
			;
				
	point : '(' NB ',' NB ')' {printf(" -> ( %d , %d )",$2 , $4);}
			;
%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
  return EXIT_SUCCESS;
}
