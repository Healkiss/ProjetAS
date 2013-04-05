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
			
	commande : DRAW {draw();}
		| FILL {draw();}
			;
	
	liste : point
		| point SEPARATOR liste
			;
				
	point : '(' NB ',' NB ')' {point($2, $4);}
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
	fprintf(fres,"\tcairo_surface_t* pdf_surface = cairo_pdf_surface_create(\"lignesBrisees.pdf\",100,100); \n");
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
		fprintf(fres,"\tcairo_move_to(cr,%d, %d) ;\n", x, y);
	}
	else{
		fprintf(fres,"\tcairo_line_to(cr,%d, %d);\n", x, y);
		fprintf(fres,"\tcairo_set_line_width(cr, 2.0);\n");
	}

}
