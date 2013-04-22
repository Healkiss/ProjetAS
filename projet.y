 %{
#include "functions.h"
firstPoint = 1;
line = 0;

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
%token CYCLE
%token SEPARATOR
%token EOI //end of commande
%token EOL //end of line
%token VAR_COOR
%token VAR_PT
%token VAR_LIST
%token VAR_NAME
%left '+''-'
%left '*' '/'
%nonassoc UMINUS

%%
	input : input line {line++;}
			| line {line++;}
			;
	
	line : commande {/*creer liste chaine*/;} liste EOI EOL {/*lire liste chaine*/;}
			| definition EOI EOL{printf("%sdefinition termine%s \n", GREEN,WHITE);}
			| affectation EOI EOL{printf("%saffectation termine%s \n", GREEN,WHITE);}
			| error EOI EOL {printf("%serreur de variable%s\n", RED,WHITE);}
			| EOL
			;
			
	definition : VAR_COOR list_coor {/*instanciation coor*/}
				| VAR_PT list_pt {/*instanciation pt*/}
				| VAR_LIST list_list {/*instanciation list*/}
				;
	
	list_coor : list_coor ',' VAR_NAME {/*instanciation coor*/printf("%s<<definition variable coor : %s >>%s\n", BLUE, $3, WHITE);char *s = $3;ajouterCoor(s,0);}
					|  VAR_NAME {/*instanciation coor*/printf("%s<<definition variable coor : %s >>%s\n", BLUE, $1, WHITE);char *s  = $1;ajouterCoor(s,0);}
					;
					
	list_pt : list_pt ',' VAR_NAME {/*instanciation pt*/printf("%s<<definition variable pt : %s >>%s\n", BLUE, $3, WHITE);}
					|  VAR_NAME {/*instanciation list*/printf("%s<<definition variable pt : %s >>%s\n", BLUE, $1, WHITE);}
					;
					
	list_list : list_list ',' VAR_NAME  {/*instanciation list*/printf("%s<<definition variable list : %s >>%s\n", BLUE, $3, WHITE);}
					|  VAR_NAME {/*instanciation list*/printf("%s<<definition variable list : %s >>%s\n", BLUE, $1, WHITE);} 
					;	
					
	affectation : VAR_NAME '=' value {/*lire liste chaine*/;printf("%s<<affectation variable : %s to %s >>%s\n", BLUE, $3, $1, WHITE);}
				;
		
	value : NB
			| point
			| liste
			;
			
	commande : DRAW {draw();}
		| FILL {draw();}
		| error {printf("%serreur de comande%s\n", RED,WHITE);}
		;
	
	liste : point {/*remplir liste chainee (dernier point)*/;}
		| '+' translation
		| cycle
		| point {/*remplir liste chainee*/;} SEPARATOR liste {}
		| '+' translation SEPARATOR liste {}
		| cycle SEPARATOR liste {}
		;
		
	point : '(' expr ',' expr ')' {creer_point($2, $4);}
			;

	cycle : CYCLE {creer_point(premierpoint_x, premierpoint_y);}
			;
			
	translation : '(' expr ',' expr ')' {creer_point(pointprec_x+$2, pointprec_y+$4);}
			;

	expr : expr '+' expr {$$=$1+$3;}
		| expr '*' expr {$$=$1*$3;}
		| expr '-' expr {$$=$1-$3;}
		| expr '/' expr {$$=$1/$3;}
		| NB {$$=$1;}
		| '(' expr ')' {$$=$2;}
		| '-' expr %prec UMINUS {$$=-$2;}
			;

%%

int yyerror(char *s) {
	printf("%s\n",s);
}
int main(void) {
	fres = fopen("res.c", "w+r+");
	fprintf(fres,"#include <cairo.h> \n");
	fprintf(fres,"#include <cairo-pdf.h> \n");
	fprintf(fres,"int main(void){ \n");
	fprintf(fres,"\tcairo_surface_t *surface; \n");
	fprintf(fres,"\tcairo_t *cr; \n");
	fprintf(fres,"\tcairo_surface_t* pdf_surface = cairo_pdf_surface_create(\"dessin.pdf\",100,100); \n");
	fprintf(fres,"\tcr = cairo_create(pdf_surface);\n");
	yyparse();
	fprintf(fres,"\tcairo_stroke(cr);\n");
	fprintf(fres,"\tcairo_destroy(cr);\n");
	fprintf(fres,"\tcairo_surface_destroy(pdf_surface);\n");
	fprintf(fres,"\treturn 0;\n}");
	printf("Nb ligne %d \n", line);
	printf("variables coordonnees stockees :\n");
	afficherCoors();
	return EXIT_SUCCESS;
}
