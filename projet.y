 %{
#include "functions.h"
//est on en train d'affecter une variable ? Si oui, son nom :
char *nomPointEnAffectation = NULL;
char *nomCheminEnAffectation = NULL;
char *nomImageEnAffectation = NULL;
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
	float val_scal ;
	char *str;
}

%token <val_scal> NB
%token VARERROR
%token SET_COLOR
%token DRAW
%token FILL
%token CYCLE
%token TRANSLATE
%token ROTATE
%token SEPARATOR
%token IMG_BEGIN
%token IMG_END
%token EOI //end of commande
%token EOL //end of line
%token <scal> VAR_COOR
%token <str> VAR_PT
%token <str> VAR_LIST
%token <str> VAR_NAME_COOR
%token <str> VAR_NAME_PT
%token <str> VAR_NAME_LIST
%token <str> VAR_IMG
%token <str> VAR_NAME_IMG
%left '+''-'
%left '*' '/'
%nonassoc UMINUS

%type <val_scal> expr
%type <str> point
%type <str> liste
%type <str> translation
%type <str> cycle
%%
	input : input line						{line++;nomCheminEnAffectation = NULL;
												//printf("%sreinitialisation de nomChemin Enaffectation%s\n", YELLOW,WHITE);
											}
			| line 							{line++;nomCheminEnAffectation = NULL;
												//printf("%sreinitialisation de nomChemin Enaffectation%s\n", YELLOW,WHITE);
											}
			;
	
	line : commande 						{/*creer liste chaine*/;}
				liste EOI EOL 				{/*lire liste chaine*/;}
			| definition EOI EOL			{/*printf("%sdefinition termine%s \n", GREEN,WHITE);*/}
			| affectation EOI EOL			{/*printf("%saffectation termine%s \n", GREEN,WHITE);*/}
			| TRANSLATE point				{
												//translation
											}
			| ROTATE '(' liste 				{
												//retenir cette liste pour faire les operations dessus plus tard
											}
					',' point				{
												//retenir le centre de cette rotation
											}
					',' expr			{	//angle on peut faire les calculs tels que
												/*float angle = a * M_PI / 180 ;
												chemin new = creer_chemin() ;
												chemin_debut(c) ;

												int new_point[2] ;

												int* old_point = valeur_chemin(c) ; 

												new_point[0] = cos(angle) * (old_point[0] - pt[0]) - sin(angle) * (old_point[1] - pt[1]) + pt[0] ; 
												new_point[1] = sin(angle) * (old_point[0] - pt[0]) + cos(angle) * (old_point[1] - pt[1]) + pt[1] ; 

												chemin_ajouter(new , new_point) ; 

												while( chemin_a_suivant(c) ) { 
													chemin_suivant(c) ; 

													old_point = chemin_get(c) ;

													new_point[0] = cos(angle) * (old_point[0] - pt[0]) - sin(angle) * (old_point[1] - pt[1]) + pt[0] ; 
													new_point[1] = sin(angle) * (old_point[0] - pt[0]) + cos(angle) * (old_point[1] - pt[1]) + pt[1] ; 

													chemin_ajouter(new , new_point) ; 
												}
												return new;
												*/
											}
			| coloration EOI EOL
			| error EOI EOL 				{/*printf("%serreur : ligne mal formee%s\n", RED,WHITE);*/}
			| EOL
			;
			
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////DEFINITIONS DE VARIABLES////////////////////////////////////////////////////////////////////////////////////			
	definition : VAR_COOR list_coor 		{/*instanciation coor*/}
				| VAR_PT list_pt 			{/*instanciation pt*/}
				| VAR_LIST list_list 		{/*instanciation list*/}
				| VAR_IMG list_img 			{/*instanciation list*/}
				;
	
	list_coor : list_coor ',' VAR_NAME_COOR {
												/*instanciation coor*/
												//printf("%s<<definition variable coor : %s >>%s\n", BLUE, $3, WHITE);
												GlobalListeCoor = ajouterCoor(GlobalListeCoor, profondeur, $3);
											}
					|  VAR_NAME_COOR 		{
												/*instanciation coor*/
												//printf("%s<<definition variable coor : %s >>%s\n", BLUE, $1, WHITE);
												GlobalListeCoor = ajouterCoor(GlobalListeCoor, profondeur, $1);
											}
					| VARERROR				{
												printf("%s<<erreur de definition >>%s\n", RED, WHITE);
											}
					;
					
	list_pt : list_pt ',' VAR_NAME_PT 		{
												/*instanciation pt*/
												//printf("%s<<definition variable pt : %s >>%s\n", BLUE, $3, WHITE);
												GlobalListePoint = ajouterPoint(GlobalListePoint, profondeur, $3);
											}
					|  VAR_NAME_PT 			{
												/*instanciation list*/;
												//printf("%s<<definition variable pt : %s >>%s\n", BLUE, $1, WHITE);
												GlobalListePoint = ajouterPoint(GlobalListePoint, profondeur, $1);
											}
					;
					
	list_list : list_list ',' VAR_NAME_LIST {
												/*instanciation list*/;
												//printf("%s<<definition variable list : %s >>%s\n", BLUE, $3, WHITE);
												GlobalListeChemin = ajouterChemin(GlobalListeChemin, profondeur, $3);
												/*printf("%s<<variable liste chemin globale >>%s\n", YELLOW, WHITE);
												afficherChemins(GlobalListeChemin);			*/									
											}
					|  VAR_NAME_LIST 		{
												/*instanciation list*/;
												//printf("%s<<definition variable list : %s >>%s\n", BLUE, $1, WHITE);
												GlobalListeChemin = ajouterChemin(GlobalListeChemin, profondeur, $1);
												/*printf("%s<<variable liste chemin globale >>%s\n", YELLOW, WHITE);
												afficherChemins(GlobalListeChemin);*/
											} 
					;	
	list_img : list_img ',' VAR_NAME_IMG	{
												printf("%s<<definition variable image : %s >>%s\n", BLUE, "3", WHITE);
												GlobalListeImage = ajouterImage(GlobalListeImage, profondeur, $3);
												//affecterImage(GlobalListeCoor, profondeur, $1, $3);
											}
					|  VAR_NAME_IMG 		{
												printf("%s<<definition variable image : %s >>%s\n", BLUE, "1", WHITE);
												GlobalListeImage = ajouterImage(GlobalListeImage, profondeur, $1);
											}
					;
					
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////AFFECTATIONS DE VARIABLES///////////////////////////////////////////////////////////////////////////////////			
	affectation : VAR_NAME_COOR '=' expr 	{
												/*lire liste chaine*/;
												printf("%s<<affectation variable scal : %f to %s >>%s\n", BLUE, $3, $1, WHITE);
												affecterCoor(GlobalListeCoor, profondeur, $1, $3);
											}
				| VAR_NAME_PT 				{
											//	printf("%snomPointEnAffectation : %s %s\n",YELLOW, "1", WHITE);
												nomPointEnAffectation = $1;
											}
					'=' point 				{
												/*lire liste chaine*/;
												//printf("%s<<affectation variable point : %s to %s >>%s\n", BLUE, "3", $1, WHITE);
												//printf("affecter point name debut : %s \n",nomPointEnAffectation);
											}
				| VAR_NAME_LIST 			{
												nomCheminEnAffectation = $1;
											}
					'=' liste 				{
												/*lire liste chaine*/;
												//printf("%s<<affectation variable liste : %s to %s >>%s\n", BLUE, "3", $1, WHITE);
												//printf("affecter chemin name debut : %s \n",nomCheminEnAffectation);
											}
				| VAR_NAME_IMG  			{
												printf("%saffecter image name debut : %s %s\n",RED, "1", WHITE);
												nomImageEnAffectation = $1;
												
											}
					'=' liste 				{
												printf("%s<<VAR_NAME_LIST %s detecté>>%s\n", RED,"1",WHITE);
												//printf("%s<<affectation variable liste : %s to %s >>%s\n", BLUE, "3", $1, WHITE);
												//printf("affecter chemin name debut : %s \n",nomCheminEnAffectation);
											}
				;
		
	/*value : NB {int* value = malloc(sizeof (int)); *value = $1; $$ = value;}
			| point {char* value = malloc(sizeof (char)); *value = $1; $$ = value;}
			| liste {char* value = malloc(sizeof (char)); *value = $1; $$ = value;}
			;*/
			
	commande : DRAW 						{draw();}
			| FILL 							{draw();}
			| error							{printf("%serreur de comande%s\n", RED,WHITE);}
			;
	
	liste : point 							{$$ = $1;}
			| '+' translation 				{$$ = $2;}
			| cycle
			| point 						{}
				SEPARATOR liste 			{}
			| '+' translation 
				SEPARATOR liste				{}
			| cycle SEPARATOR liste 		{}
			| VAR_NAME_LIST					{		
													printf("%s<<VAR_NAME_LIST %s detecté>>%s\n", RED,$1,WHITE);
													if(nomCheminEnAffectation != NULL){
														//printf("%s<<affecterCheminToChemin(%s to %s)>>%s\n", YELLOW,$1,nomCheminEnAffectation,WHITE);
														affecterCheminToChemin(GlobalListeChemin, profondeur, $1, nomCheminEnAffectation);
													}else{
														printf("%s<<on va dessiner%s>>%s\n", RED,$1,WHITE);
														dessiner_chemin($1);
													}
											}
			;
		
	point : '(' expr ',' expr ')' 			{
												if(nomPointEnAffectation!= NULL)
												{
													affecterPoint(GlobalListePoint, profondeur, nomPointEnAffectation,$2, $4);
													nomPointEnAffectation = NULL;
												}else{
													if(nomCheminEnAffectation != NULL){
														printf("%s<<affecterPointToChemin(%s,%f, %f)>>%s\n", BLUE,nomCheminEnAffectation,$2,$4,WHITE);
														affecterPointToChemin(GlobalListeChemin, profondeur, nomCheminEnAffectation,$2, $4);
													}else{
														dessiner_point($2, $4);
													}
												}
											}
			| VAR_NAME_PT					{
												if(nomPointEnAffectation!= NULL)
												{
													Point p = valeurPoint(GlobalListePoint, profondeur, $1);
													affecterPoint(GlobalListePoint, profondeur, nomPointEnAffectation, p->x, p->y);
													nomPointEnAffectation = NULL;
												}else{
													if(nomCheminEnAffectation != NULL){
														//printf("%s<<affecterPointToCheminAvecPoint(%s)>>%s\n", BLUE,nomCheminEnAffectation,$1,WHITE);
														Point p = valeurPoint(GlobalListePoint, profondeur, $1);
														affecterPointToChemin(GlobalListeChemin, profondeur, nomCheminEnAffectation, p->x, p->y);
													}else{
														Point p = valeurPoint(GlobalListePoint, profondeur, $1);
														dessiner_point(p->x, p->y);
													}
												}
											}
			| '(' expr ':' expr ')' 		{
												$$[0] = $2 * cos($4) ; $$[1] = $2 * sin($4);
										
												if(nomPointEnAffectation != NULL)
												{
													affecterPoint(GlobalListePoint, profondeur, nomPointEnAffectation,$2, $4);
													nomPointEnAffectation = NULL;
												}else{
													if(nomCheminEnAffectation != NULL){
														printf("%s<<affecterPointToChemin(%s,%f, %f)>>%s\n", BLUE,nomCheminEnAffectation,$2,$4,WHITE);
														affecterPointToChemin(GlobalListeChemin, profondeur, nomCheminEnAffectation,$2, $4);
													}else{
														dessiner_point($$[0], $$[1]);
													}
												}
											} /*coordonnée polaires*/

	cycle : CYCLE 							{dessiner_point(premierpoint_x, premierpoint_y);}
			;
			
	translation : '(' expr ',' expr ')' 	{dessiner_point(pointprec_x+$2, pointprec_y+$4);}
				;

	expr : expr '+' expr 					{$$=$1+$3;}
			| expr '*' expr					{$$=$1*$3;}
			| expr '-' expr 				{$$=$1-$3;}
			| expr '/' expr 				{$$=$1/$3;}
			| NB 							{$$=$1;}
			| '(' expr ')' 					{$$=$2;}
			| '-' expr %prec UMINUS 		{$$=-$2;}
			| VAR_NAME_COOR					{	
												Coordonnee c = valeurCoor(GlobalListeCoor, profondeur,$1);
												$$=c->valeur;
												if($$ == -1){
													//printf("%s<<variable %s n'existe pas !>>%s\n", RED,$1,WHITE);
												}else{
													//printf("%s<<variable %s : %d>>%s\n", YELLOW,$1, $$,WHITE);
												}
											}
			;
	coloration : SET_COLOR '(' expr			{}
			| expr							{}
			;
%%

int yyerror(char *s) {
	printf("%s\n",s);
}
int main(void) {
	GlobalListeCoor = NULL;
	GlobalListePoint = NULL;
	GlobalListeChemin = NULL;
	GlobalListeImage = NULL;
	profondeur = 0;
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
	afficherCoors(GlobalListeCoor, profondeur);
	printf("variables point stockees :\n");
	afficherPoints(GlobalListePoint, profondeur);
	printf("variables chemin stockees :\n");
	afficherChemins(GlobalListeChemin, profondeur);
	printf("variables image stockees :\n");
	afficherImages(GlobalListeChemin, profondeur);
	return EXIT_SUCCESS;
}
