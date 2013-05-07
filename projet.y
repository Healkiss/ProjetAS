 %{
#include "functions.h"
//est on en train d'affecter une variable ? Si oui, son nom :
char *affecterPointName = NULL;
char *affecterCheminName = NULL;
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
%union {
	int scal ;
	char *str;
}

%token <scal> NB
%token DRAW
%token FILL
%token CYCLE
%token SEPARATOR
%token EOI //end of commande
%token EOL //end of line
%token <scal> VAR_COOR
%token <str> VAR_PT
%token <str> VAR_LIST
%token <str> VAR_NAME_COOR
%token <str> VAR_NAME_PT
%token <str> VAR_NAME_LIST
%left '+''-'
%left '*' '/'
%nonassoc UMINUS

%type <scal> expr
%type <str> point
%type <str> liste
%type <str> translation
%type <str> cycle
%%
	input : input line {line++;}
			| line {line++;affecterCheminName = NULL;}
			;
	
	line : commande {/*creer liste chaine*/;} liste EOI EOL {/*lire liste chaine*/;}
			| definition EOI EOL{printf("%sdefinition termine%s \n", GREEN,WHITE);}
			| affectation EOI EOL{printf("%saffectation termine%s \n", GREEN,WHITE);}
			| error EOI EOL {printf("%serreur : ligne mal formee%s\n", RED,WHITE);}
			| EOL
			;
			
	definition : VAR_COOR list_coor {/*instanciation coor*/}
				| VAR_PT list_pt {/*instanciation pt*/}
				| VAR_LIST list_list {/*instanciation list*/}
				;
	
	list_coor : list_coor ',' VAR_NAME_COOR {
												/*instanciation coor*/
												printf("%s<<definition variable coor : %s >>%s\n", BLUE, $3, WHITE);
												GlobalListeCoor = ajouterCoor(GlobalListeCoor, $3);
											}
					|  VAR_NAME_COOR 		{
												/*instanciation coor*/
												printf("%s<<definition variable coor : %s >>%s\n", BLUE, $1, WHITE);
												GlobalListeCoor = ajouterCoor(GlobalListeCoor, $1);
											}
					;
					
	list_pt : list_pt ',' VAR_NAME_PT 		{
												/*instanciation pt*/
												printf("%s<<definition variable pt : %s >>%s\n", BLUE, $3, WHITE);
												GlobalListePoint = ajouterPoint(GlobalListePoint, $3);
											}
					|  VAR_NAME_PT 			{
												/*instanciation list*/;
												printf("%s<<definition variable pt : %s >>%s\n", BLUE, $1, WHITE);
												GlobalListePoint = ajouterPoint(GlobalListePoint, $1);
											}
					;
					
	list_list : list_list ',' VAR_NAME_LIST {
												/*instanciation list*/;
												printf("%s<<definition variable list : %s >>%s\n", BLUE, $3, WHITE);
												GlobalListeChemin = ajouterChemin(GlobalListeChemin, $3);
											}
					|  VAR_NAME_LIST 		{
												/*instanciation list*/;
												printf("%s<<definition variable list : %s >>%s\n", BLUE, $1, WHITE);
												GlobalListeChemin = ajouterChemin(GlobalListeChemin, $1);
											} 
					;	
					
	affectation : VAR_NAME_COOR '=' expr 	{
												/*lire liste chaine*/;
												printf("%s<<affectation variable scal : %d to %s >>%s\n", BLUE, $3, $1, WHITE);
												affecterCoor(GlobalListeCoor, $1, $3);
											}
				| VAR_NAME_PT 	{
									affecterPointName = $1;
								}
					'=' point 	{
									/*lire liste chaine*/;
									printf("%s<<affectation variable point : %s to %s >>%s\n", BLUE, "3", $1, WHITE);
									printf("affecter point name debut : %s \n",affecterPointName);
								}
				| VAR_NAME_LIST {
									affecterCheminName = $1;
								}
					'=' liste 	{
									/*lire liste chaine*/;
									printf("%s<<affectation variable liste : %s to %s >>%s\n", BLUE, "3", $1, WHITE);
									printf("affecter chemin name debut : %s \n",affecterCheminName);
								}
				;
		
	/*value : NB {int* value = malloc(sizeof (int)); *value = $1; $$ = value;}
			| point {char* value = malloc(sizeof (char)); *value = $1; $$ = value;}
			| liste {char* value = malloc(sizeof (char)); *value = $1; $$ = value;}
			;*/
			
	commande : DRAW {draw();}
		| FILL {draw();}
		| error {printf("%serreur de comande%s\n", RED,WHITE);}
		;
	
	liste : point { {$$ = $1;}/*remplir liste chainee (dernier point)*/;}
		| '+' translation {$$ = $2;}
		| cycle
		| point {/*remplir liste chainee*/;} SEPARATOR liste {}
		| '+' translation SEPARATOR liste {}
		| cycle SEPARATOR liste {}
		;
		
	point : '(' expr ',' expr ')' {
									if(affecterPointName!= NULL)
									{
										affecterPoint(GlobalListePoint, affecterPointName,$2, $4);
										affecterPointName = NULL;
									}else{
										if(affecterCheminName != NULL){
											printf("%s<<affecterPointToChemin(%s,%d, %d)>>%s\n", BLUE,affecterCheminName,$2,$4,WHITE);
											affecterPointToChemin(GlobalListeChemin, affecterCheminName,$2, $4);
										}else{
											dessiner_point($2, $4);
										}
									}
								}
			| '(' expr ':' expr ')' {
										$$[0] = $2 * cos($4) ; $$[1] = $2 * sin($4);
										
										if(affecterPointName != NULL)
										{
											affecterPoint(GlobalListePoint, affecterPointName,$2, $4);
											affecterPointName = NULL;
										}else{
											if(affecterCheminName != NULL){
												printf("%s<<affecterPointToChemin(%s,%d, %d)>>%s\n", BLUE,affecterCheminName,$2,$4,WHITE);
												affecterPointToChemin(GlobalListeChemin, affecterCheminName,$2, $4);
											}else{
												dessiner_point($$[0], $$[1]);
											}
										}
									} /*coordonnée polaires*/

	cycle : CYCLE {dessiner_point(premierpoint_x, premierpoint_y);}
			;
			
	translation : '(' expr ',' expr ')' {dessiner_point(pointprec_x+$2, pointprec_y+$4);}
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
	GlobalListeCoor = NULL;
	GlobalListePoint = NULL;
	GlobalListeChemin = NULL;
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
	printf("variables coordonnee stockees :\n");
	afficherCoors(GlobalListeCoor);
	printf("variables point stockees :\n");
	afficherPoints(GlobalListePoint);
	printf("variables chemin stockees :\n");
	afficherChemins(GlobalListeChemin);
	return EXIT_SUCCESS;
}
