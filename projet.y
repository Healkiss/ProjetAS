 %{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

//globals
bool firstPoint = true;
FILE *fres;

//declarations
void draw();
void point(int, int);
int premierpoint_x;
int premierpoint_y;
int pointprec_x;
int pointprec_y;
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
%token EOI
%token EOL
%left '+''-'
%left '*' '/'
%nonassoc UMINUS

%%
	input : input line
			| line
			;
	
	line : commande liste EOI EOL
			| EOL
			| error EOL
			;
			
	commande : DRAW {draw();}
		| FILL {draw();}
			;
	
	liste : point
		| '+' translation
		| cycle
		| point SEPARATOR liste
		| '+' translation SEPARATOR liste
		| cycle SEPARATOR liste
			;
		
	point : '(' expr ',' expr ')' {point($2, $4);}
			;

	cycle : CYCLE {point(premierpoint_x, premierpoint_y);}
			;
	translation : '(' expr ',' expr ')' {point(pointprec_x+$2, pointprec_y+$4);}
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
	return EXIT_SUCCESS;
}
void draw()
{
	firstPoint = true;	
}

void point(int x, int y)
{
	if (firstPoint){
		firstPoint = false;
		premierpoint_x=x;
		premierpoint_y=y;
		pointprec_x=x;
		pointprec_y=y;
		fprintf(fres,"\tcairo_move_to(cr,%d, %d) ;\n", x, y);
	}
	else{
		fprintf(fres,"\tcairo_line_to(cr,%d, %d);\n", x, y);
		fprintf(fres,"\tcairo_set_line_width(cr, 1.0);\n");
		pointprec_x=x;
		pointprec_y=y;
	}

}
