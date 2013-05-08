#include "functions.h"

void draw()
{
	firstPoint = 1;	
}

void dessiner_point(float x, float y)
{
	if (firstPoint){
		firstPoint = 0;
		premierpoint_x=x;
		premierpoint_y=y;
		pointprec_x=x;
		pointprec_y=y;
		fprintf(fres,"\tcairo_move_to(cr,%f, %f) ;\n", x, y);
	}
	else{
		fprintf(fres,"\tcairo_line_to(cr,%f, %f);\n", x, y);
		fprintf(fres,"\tcairo_set_line_width(cr, 1.0);\n");
		pointprec_x=x;
		pointprec_y=y;
	}

}

void setColor(float red, float green, float blue, float alpha){
	fprintf(fres,"\tcairo-set-source-rgba(cr,%f, %f,%f, %f) ;\n", red, green, blue, alpha);
}
//////////////////////////////////////////////////////////////////////////////////////////////////
////////FONCTIONS COORDONNES /////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
Coordonnee creer_coor(char* id, float val){
	struct_coordonnee* coord;
	coord = malloc(sizeof(Coordonnee));
	coord->id = id;
	coord->valeur = val;
	return coord;
}

Liste_coor ajouterCoor(Liste_coor listeCoor, int profondeur, char* id)
{
	Coordonnee coord = creer_coor(id, -1);
	/* On crée un nouvel élément */
	struct_liste_coor* nouvelElement;
	nouvelElement = malloc(sizeof(Liste_coor));
	/* On assigne la valeur au nouvel élément */
	nouvelElement->coor = coord;
  	nouvelElement->profondeur = profondeur;
	/* On ajoute en fin, donc aucun élément ne va suivre */
	nouvelElement->nxt = NULL;
  
	if(listeCoor == NULL)
    {
        /* Si la liste est videé il suffit de renvoyer l'élément créé */
		listeCoor = nouvelElement;
    }
    else
    {
        /* Sinon, on parcourt la liste à l'aide d'un pointeur temporaire et on
        indique que le dernier élément de la liste est relié au nouvel élément */
		Liste_coor temp = listeCoor;
        while(temp->nxt != NULL)
        {
            temp = (Liste_coor)temp->nxt;
        }
        temp->nxt = nouvelElement;
    }
    return listeCoor;
}

int affecterCoor(Liste_coor listeCoor, int profondeur, char* id, float val)
{
	Liste_coor temp = listeCoor;
	char * idtmp;
	int resultat;
    while(temp != NULL)
    {
    	idtmp = temp->coor->id;
    	resultat = strcmp(idtmp, id);
    	if (strcmp(idtmp, id) == 0){
    		
    		temp->coor->valeur = val;
    		return 1;
    	}
        temp = temp->nxt;
        
    }
    return 0;
}
int affecterCoorToCoor(Liste_coor listeCoor, int profondeur, char* id1, char* id2){
	Liste_coor temp1 = listeCoor;
	char * id;
	int resultat;
    while(temp1 != NULL)
    {
    	id = temp1->coor->id;
    	resultat = strcmp(id, id1);
    	if (strcmp(id, id1) == 0){
    		Liste_coor temp2 = listeCoor;
			while(temp2 != NULL)
			{
				id = temp2->coor->id;
				resultat = strcmp(id, id1);
				if (strcmp(id, id2) == 0){
					temp1->coor->valeur = temp2->coor->valeur;
					return 1;
				}
				temp2 = temp2->nxt;
				
			}
    		return 1;
    	}
        temp1 = temp1->nxt;
        
    }

    return 0;
}

int existeDansCoor(Liste_coor listeCoor, int profondeur, char *varname){
	Liste_coor temp = listeCoor;
	char * id;
	int resultat;
    while(temp != NULL)
    {
    	id = temp->coor->id;
    	resultat = strcmp(id, varname);
    	if (strcmp(id, varname) == 0){
    		return 1;
    	}
        temp = temp->nxt;
        
    }
    return 0;
}

Coordonnee valeurCoor(Liste_coor listeCoor, int profondeur, char *varname){
	Liste_coor temp = listeCoor;
	char * id;
    while(temp != NULL)
    {
    	id = temp->coor->id;
    	if (strcmp(id, varname) == 0){
    		return temp->coor;
    	}
        temp = temp->nxt;
        
    }
    return -1;
}

void afficherCoors(Liste_coor listeCoor, int profondeur)
{
	char * id;
	float val;
	Liste_coor temp = listeCoor;
	while(temp != NULL)
    {
        /* Si la liste est videé il suffit de renvoyer l'élément créé */
		id = temp->coor->id;
		val =  temp->coor->valeur;
		printf("%s = %f \n", id, val);
		temp = temp->nxt;
    }
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////
////////FONCTIONS POINT //////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
Point creer_point(char* id, float x, float y){
	struct_point* point;
	point = malloc(sizeof(Point));
	point->id = id;
	point->x = x;
	point->y = y;
	return point;
}

Liste_point ajouterPoint(Liste_point listePoint, int profondeur, char* id)
{
	Point point = creer_point(id,-1,-1);
	/* On crée un nouvel élément */
	struct_liste_point* nouvelElement;
	nouvelElement = malloc(sizeof(Liste_point));
	/* On assigne la valeur au nouvel élément */
	nouvelElement->point = point;
	nouvelElement->profondeur = profondeur;
   
	/* On ajoute en fin, donc aucun élément ne va suivre */
	nouvelElement->nxt = NULL;
  
	if(listePoint == NULL)
    {
        /* Si la liste est videé il suffit de renvoyer l'élément créé */
		listePoint = nouvelElement;
    }
    else
    {
        /* Sinon, on parcourt la liste à l'aide d'un pointeur temporaire et on
        indique que le dernier élément de la liste est relié au nouvel élément */
		Liste_point temp = listePoint;
        while(temp->nxt != NULL)
        {
            temp = temp->nxt;
        }
        temp->nxt = nouvelElement;
    }
    return listePoint;
}

int affecterPoint(Liste_point listePoint, int profondeur, char* id, float x, float y)
{
	Liste_point temp = listePoint;
	char * idtmp;
	int resultat;
    while(temp != NULL)
    {
    	idtmp = temp->point->id;
    	resultat = strcmp(idtmp, id);
    	if (resultat == 0){
    		
    		temp->point->x = x;
    		temp->point->y = y;
    		return 1;
    	}
        temp = temp->nxt;
        
    }
    return 0;
}

int affecterPointAvecPoint(Liste_point listePoint, int profondeur, char* id, Point point)
{
	Liste_point temp = listePoint;
	char * idtmp;
	int resultat;
    while(temp != NULL)
    {
    	idtmp = temp->point->id;
    	resultat = strcmp(idtmp, id);
    	if (resultat == 0){
    		temp->point->x = point->x;
    		temp->point->y = point->y;
    		return 1;
    	}
        temp = temp->nxt;
        
    }
    return 0;


}
Liste_point ajouterEtAffecterPoint(Liste_point listePoint, int profondeur, char* id, float x, float y)
{
	Point point = creer_point(id,x,y);
	/* On crée un nouvel élément */
	struct_liste_point* nouvelElement;
	nouvelElement = malloc(sizeof(Liste_point));
	/* On assigne la valeur au nouvel élément */
	nouvelElement->point = point;
  
	/* On ajoute en fin, donc aucun élément ne va suivre */
	nouvelElement->nxt = NULL;
  
	if(listePoint == NULL)
    {
        /* Si la liste est videé il suffit de renvoyer l'élément créé */
		listePoint = nouvelElement;
    }
    else
    {
        /* Sinon, on parcourt la liste à l'aide d'un pointeur temporaire et on
        indique que le dernier élément de la liste est relié au nouvel élément */
		Liste_point temp = listePoint;
        while(temp->nxt != NULL)
        {
            temp = temp->nxt;
        }
        temp->nxt = nouvelElement;
    }
    return listePoint;
}

int existeDansPoint(Liste_point listePoint, int profondeur, char *varname){
	Liste_point temp = listePoint;
	char * id;
    while(temp != NULL)
    {
    	if (strcmp(temp->point->id, varname) == 0)
    		return 1;
        temp = temp->nxt;
    }
    return 0;
}

Point valeurPoint(Liste_point listePoint, int profondeur, char *varname){
	Liste_point temp = listePoint;
	char * id;
    while(temp != NULL)
    {
    	if (strcmp(temp->point->id, varname) == 0)
    		return temp->point;
        temp = temp->nxt;
    }
    return -1;
}

void afficherPoints(Liste_point listePoint, int profondeur)
{
	char * id;
	float x;
	float y;
	Liste_point temp = listePoint;
	while(temp != NULL)
    {
        /* Si la liste est vide il suffit de renvoyer l'élément créé */
		id = temp->point->id;
		x =  temp->point->x;
		y =  temp->point->y;
		printf("%s = %f , %f \n", id, x, y);
		temp = temp->nxt;
    }
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////
////////FONCTIONS LISTES /////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
Chemin creer_chemin(char* id){	
	struct_chemin* chemin;
	chemin = malloc(sizeof(Chemin));
	chemin->id = id;
	chemin->chemin = NULL;
	
	return chemin;
}

Liste_chemin ajouterChemin(Liste_chemin listeChemin, int profondeur, char* id)
{
	Chemin chemin = creer_chemin(id);
	/* On crée un nouvel élément */
	struct_liste_chemin* nouvelElement;
	nouvelElement = malloc(sizeof(Liste_chemin));
	/* On assigne la valeur au nouvel élément */
	nouvelElement->chemin = chemin;
	nouvelElement->profondeur = profondeur;
	
	/* On ajoute en fin, donc aucun élément ne va suivre */
	nouvelElement->nxt = NULL;
  
	if(listeChemin == NULL)
    {
        /* Si la liste est videé il suffit de renvoyer l'élément créé */
		listeChemin = nouvelElement;
    }
    else
    {
        /* Sinon, on parcourt la liste à l'aide d'un pointeur temporaire et on
        indique que le dernier élément de la liste est relié au nouvel élément */
		Liste_chemin temp = listeChemin;
        while(temp->nxt != NULL)
        {
            temp = temp->nxt;
        }
        temp->nxt = nouvelElement;
    }
    return listeChemin;
}

int affecterPointToChemin(Liste_chemin listeChemin, int profondeur, char* id, float x, float y)
{
	Liste_chemin temp = listeChemin;
	char * idtmp;
	int resultat;
	Point point = creer_point(NULL, x, y);
	//afficherChemins(listeChemin);
    while(temp != NULL)
    {
    	idtmp = temp->chemin->id;
    	resultat = strcmp(idtmp, id);
    	if (resultat == 0){
    		//printf("chemin %s trouvé\n",id);
    		temp->chemin = ajouterEtAffecterPoint(temp->chemin, profondeur, NULL,  point->x, point->y);
    		return 1;
    	}
        temp = temp->nxt;
        
    }
    return 0;
}

int affecterCheminToChemin(Liste_chemin listeChemin , int profondeur,  char* id, char* id2){
	Liste_chemin temp = listeChemin;
	printf("chemin %s to chemin %s\n",id, id2);
    while(temp != NULL)
    {
    	printf("compare %s to %s \n",temp->chemin->id, id);
    	printf("compare %s to %s \n",temp, temp->nxt);
    	if (strcmp(temp->chemin->id, id2) == 0){
    		printf("%schemin %s to chemin %s trouvé%s\n",YELLOW,temp->chemin->id, id2,WHITE);
    		temp->chemin = valeurChemin(listeChemin, profondeur,id);
    		return 1;
        }
        temp = temp->nxt;
    }
    return -1;
}

int existeDansListe(Liste_chemin listeChemin, int profondeur, char *varname){
	Liste_chemin temp = listeChemin;
    while(temp != NULL)
    {
    	if (strcmp(temp->chemin->id, varname) == 0)
    		return 1;
        temp = temp->nxt;
    }
    return 0;
}

Chemin valeurChemin(Liste_chemin listeChemin, int profondeur, char *varname){
	Liste_chemin temp = listeChemin;
    while(temp != NULL)
    {
    	if (strcmp(temp->chemin->id, varname) == 0)
    		return temp->chemin;
        temp = temp->nxt;
    }
    return -1;
}

void afficherChemins(Liste_chemin listeChemin, int profondeur)
{
	char * id;
	float x;
	float y;
	Liste_chemin temp = listeChemin;
	int first;
	while(temp != NULL)
    {
		id = temp->chemin->id;
		
		/*}else{*/
		Liste_point tempListe = temp->chemin;
		
		tempListe = (tempListe->nxt != NULL)?tempListe->nxt:tempListe;
		if(tempListe->point != NULL){
			printf("%s = \n", temp->chemin->id);
			while(tempListe != NULL)
			{
				x =  tempListe->point->x;
				y =  tempListe->point->y;
				printf("%f , %f \n", x, y);
				tempListe = tempListe->nxt;
			}
		//}
		}else{
			printf("%s n'est pas initialisé \n", temp->chemin->id);
		}
		temp = temp->nxt;
		//check for a  segfault
		
    }
    
}
