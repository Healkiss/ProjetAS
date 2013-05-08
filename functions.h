#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

//globals
int firstPoint;
int line;
int profondeur;
FILE *fres;
#define RED     "\033[1;31m" //error
#define WHITE   "\033[0;m" 		//text
#define GREEN   "\033[1;32m" 	//success
#define YELLOW    "\033[1;33m" //debug
#define BLUE    "\033[1;34m" //info

///////////////////
////SCALAIRES/////////
/*faire liste de variable, 3 listes, une pour chaque type*/
//type coordonnée, un float : "1"
typedef struct {
	char* id;
	float valeur;
}struct_coordonnee;
typedef struct_coordonnee* Coordonnee;
//type liste simplement chainée de coordonnées
typedef struct{
	int profondeur;
    Coordonnee coor;
    struct struct_liste_coor *nxt;
}struct_liste_coor;
typedef struct_liste_coor* Liste_coor;
//notre liste globale de variable coordonnées
Liste_coor GlobalListeCoor;

///////////////////
////POINTS/////////
//type point, un couple de float : "(0,10)"
typedef struct {
	char* id;
	float x;
	float y;
}struct_point;
typedef struct_point* Point;
//type liste simplement chainée de points
typedef struct{
	int profondeur;
    Point point;
    struct struct_liste_point *nxt;
}struct_liste_point;
typedef struct_liste_point* Liste_point;
//notre liste globale de variable point
Liste_point GlobalListePoint;

///////////////////
////CHEMINS/////////
//type liste, un chemin de couple de float : "(0,10)--(10,10)"
typedef struct
{
	char* id;
    Liste_point chemin;
}struct_chemin;
typedef struct_chemin* Chemin;
//type chemin simplement chainée de listes
typedef struct
{
	float profondeur;
	Chemin chemin;
	struct struct_liste_chemin *nxt;
}struct_liste_chemin;
  
typedef struct_liste_chemin* Liste_chemin;
//notre liste globale de variable liste
Liste_chemin GlobalListeChemin;

///////////////////
////IMAGES/////////
typedef struct {
	char* id;
	char* nameInsctruction;
	Liste_point chemin;
}struct_instruction;
typedef struct_instruction* Instruction;
typedef struct
{
	Instruction instruction;
	struct struct_liste_instruction *nxt;
}struct_liste_instruction;
  
typedef struct_liste_instruction* Liste_instruction;
typedef struct
{
	char* id;
    Liste_instruction image;
}struct_image;
typedef struct_image* Image;
typedef struct
{
	int profondeur;
	Image image;
	struct struct_liste_image *nxt;
}struct_liste_image;
typedef struct_liste_image* Liste_image;
Liste_image GlobalListeImage;
////////////////////////////////////////
//declarations fonctions c/////////////////////
/////////////////////////////////////////////////////
////////////////
/////////SCALAIRES
Coordonnee creer_coor(char* id, float val);
Liste_coor ajouterCoor(Liste_coor, int profondeur, char* id);
//return 1 si la variable id existe, -1 sinon
int affecterCoor(Liste_coor listeCoor, int profondeur, char* id, float val);
int affecterCoorToCoor(Liste_coor listeCoor, int profondeur, char*, char*);
int existeDansCoor(Liste_coor listeCoor, int profondeur, char *varname);
//return la valeur, -1 si n'existe pas
Coordonnee valeurCoor(Liste_coor listeCoor, int profondeurchar,char *varname);
void afficherCoors(Liste_coor listeCoor, int profondeur);

////////////////
/////////POINTS
Point creer_point(char*, float, float);
Liste_point ajouterPoint(Liste_point, int profondeur,  char*);
//return 1 si la variable id existe, -1 sinon
int affecterPoint(Liste_point, int profondeur, char* id, float x, float y);
Liste_point ajouterEtAffecterPoint(Liste_point, int profondeur, char*, float, float);
int existeDansPoint(Liste_point, int profondeur, char *varname);
//return la valeur, -1 si n'existe pas
Point valeurPoint(Liste_point, int profondeur, char *varname);
void afficherPoints(Liste_point, int profondeur);

////////////////
/////////CHEMINS
Liste_chemin ajouterChemin(Liste_chemin, int profondeur, char* id);
//affecter chemin id to chemin id2
int affecterCheminToChemin(Liste_chemin, int profondeur,  char* id, char* id2);
//return 1 si la variable id existe, -1 sinon
int affecterPointToChemin(Liste_chemin, int profondeur,  char* id, float x, float y);
int existeDansChemin(Liste_chemin, int profondeur, char *varname);
//return la valeur, -1 si n'existe pas
Chemin valeurChemin(Liste_chemin, int profondeur, char *varname);
void afficherChemin(Liste_chemin, int profondeur);
void dessiner_chemin(char * id);

//////////////////
/////////IMAGES
Liste_image ajouterImage(Liste_image, int profondeur, char* id);
int existeDansImg(Liste_image listeImage, int profondeur, char *varname);
Image valeurImage(Liste_image listeImage, int profondeur, char *varname);


float premierpoint_x;
float premierpoint_y;
float pointprec_x;
float pointprec_y;
void draw(void);
void dessiner_point(float, float);

#endif /*FUNCTIONS_H*/
