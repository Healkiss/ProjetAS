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
FILE *fres;
#define RED     "\033[1;31m" 
#define WHITE   "\033[0;m" 
#define GREEN   "\033[1;32m" 
#define BLUE    "\033[1;34m" 

/*faire liste de variable, 3 listes, une pour chaque type*/
//type coordonnée, un entier : "1"
typedef struct {
	char* id;
	int valeur;
}struct_coordonnee;
typedef struct_coordonnee* Coordonnee;
//type liste simplement chainée de coordonnées
typedef struct{
	//a rajouter, un entier pour la profondeur ou faire une liste de liste
    Coordonnee coor;
    struct struct_liste_coor *nxt;
}struct_liste_coor;
typedef struct_liste_coor* Liste_coor;
//notre liste globale de variable coordonnées
Liste_coor GlobalListeCoor;

//type point, un couple d'entier : "(0,10)"
typedef struct {
	char* id;
	int x;
	int y;
}struct_point;
typedef struct_point* Point;
//type liste simplement chainée de points
typedef struct{
	//a rajouter, un entier pour la profondeur ou faire une liste de liste
    Point point;
    struct struct_liste_point *nxt;
}struct_liste_point;
typedef struct_liste_point* Liste_point;
//notre liste globale de variable point
Liste_point GlobalListePoint;

//type liste, un chemin de couple d'entier : "(0,10)--(10,10)"
typedef struct
{
	char* id;
    Liste_point chemin;
}struct_chemin;
typedef struct_chemin* Chemin;
//type chemin simplement chainée de listes
typedef struct
{
	//a rajouter, un entier pour la profondeur ou faire une liste de liste
	Chemin chemin;
	struct struct_liste_chemin *nxt;
}struct_liste_chemin;
  
typedef struct_liste_chemin* Liste_chemin;
//notre liste globale de variable liste
Liste_chemin GlobalListeChemin;

//declarations fonctions c
////////////////////////////////////////////////////////////////////////////////
Coordonnee creer_coor(char* id, int val);
Liste_coor ajouterCoor(Liste_coor, char* id);
void afficherCoors(Liste_coor);
//return 1 si la variable id existe, 0 sinon
int affecterCoor(Liste_coor, char* id, int val);

Point creer_point(char* id, int x, int y);
Liste_point ajouterPoint(Liste_point, char* id);
void afficherPoints(Liste_point);
//return 1 si la variable id existe, 0 sinon
int affecterPoint(Liste_point, char* id, int x, int y);
Liste_point ajouterEtAffecterPoint(Liste_point, char*, int, int);

Liste_chemin ajouterChemin(Liste_chemin, char* id);
void afficherChemin(Liste_chemin);
//return 1 si la variable id existe, 0 sinon
int affecterPointToChemin(Liste_chemin, char* id, int x, int y);

int premierpoint_x;
int premierpoint_y;
int pointprec_x;
int pointprec_y;
void draw(void);
void dessiner_point(int, int);

#endif /*FUNCTIONS_H*/
