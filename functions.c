#include "functions.h"

void draw()
{
	firstPoint = 1;	
}

void dessiner_point(int x, int y)
{
	if (firstPoint){
		firstPoint = 0;
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
//////////////////////////////////////////////////////////////////////////////////////////////////
////////FONCTIONS COORDONNES /////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
Coordonnee creer_coor(char* id, int val){
	struct_coordonnee* coord;
	coord = malloc(sizeof(Coordonnee));
	coord->id = id;
	coord->valeur = val;
	return coord;
}

Liste_coor ajouterCoor(Liste_coor listCoor, char* id)
{
	Coordonnee coord = creer_coor(id, 0);
	/* On crée un nouvel élément */
	struct_liste_coor* nouvelElement;
	nouvelElement = malloc(sizeof(Liste_coor));
	/* On assigne la valeur au nouvel élément */
	nouvelElement->coor = coord;
  
	/* On ajoute en fin, donc aucun élément ne va suivre */
	nouvelElement->nxt = NULL;
  
	if(listCoor == NULL)
    {
        /* Si la liste est videé il suffit de renvoyer l'élément créé */
		listCoor = nouvelElement;
    }
    else
    {
        /* Sinon, on parcourt la liste à l'aide d'un pointeur temporaire et on
        indique que le dernier élément de la liste est relié au nouvel élément */
		Liste_coor temp = listCoor;
        while(temp->nxt != NULL)
        {
            temp = temp->nxt;
        }
        temp->nxt = nouvelElement;
    }
    return listCoor;
}

void afficherCoors(Liste_coor listCoor)
{
	char * id;
	int val;
	Liste_coor temp = listCoor;
	while(temp != NULL)
    {
        /* Si la liste est videé il suffit de renvoyer l'élément créé */
		id = temp->coor->id;
		val =  temp->coor->valeur;
		printf("%s = %d \n", id, val);
		temp = temp->nxt;
    }
    
}

Liste_coor affecterCoor(Liste_coor listCoor, char* id, int val)
{
	Liste_coor temp = listCoor;
	char * idtmp;
	int resultat;
    while(temp != NULL)
    {
    	idtmp = temp->coor->id;
    	resultat = strcmp(idtmp, id);
    	if (strcmp(idtmp, id) == 0){
    		
    		temp->coor->valeur = val;
    		return listCoor;
    	}
        temp = temp->nxt;
        
    }
    return listCoor;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
////////FONCTIONS POINT //////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
Point creer_point(char* id, int x, int y){
	struct_point* point;
	point = malloc(sizeof(Point));
	point->id = id;
	point->x = x;
	point->y = y;
	return point;
}

Liste_point ajouterPoint(Liste_point listePoint, char* id)
{
	Point point = creer_point(id,0,0);
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

void afficherPoints(Liste_point listePoint)
{
	char * id;
	int x;
	int y;
	Liste_point temp = listePoint;
	while(temp != NULL)
    {
        /* Si la liste est vide il suffit de renvoyer l'élément créé */
		id = temp->point->id;
		x =  temp->point->x;
		y =  temp->point->y;
		printf("%s = %d , %d \n", id, x, y);
		temp = temp->nxt;
    }
    
}

Liste_point affecterPoint(Liste_point listePoint, char* id, int x, int y)
{
	Liste_point temp = GlobalListePoint;
	char * idtmp;
	int resultat;
    while(temp != NULL)
    {
    	idtmp = temp->point->id;
    	resultat = strcmp(idtmp, id);
    	if (resultat == 0){
    		
    		temp->point->x = x;
    		temp->point->y = y;
    		return listePoint;
    	}
        temp = temp->nxt;
        
    }
    return listePoint;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
////////FONCTIONS LISTES /////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
Chemin creer_chemin(char* id){	
	struct_liste_chemin* chemin;
	chemin = malloc(sizeof(Chemin));
	chemin->id = id;
	chemin->chemin = NULL;
	
	return chemin;
}

Liste_chemin ajouterChemin(Liste_chemin listeChemin, char* id)
{
	Chemin chemin = creer_chemin(id);
	/* On crée un nouvel élément */
	struct_liste_chemin* nouvelElement;
	nouvelElement = malloc(sizeof(Liste_chemin));
	/* On assigne la valeur au nouvel élément */
	nouvelElement->id = id;
	nouvelElement->chemin = chemin;
  
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

void afficherChemins(Liste_chemin listeChemin)
{
	char * id;
	int x;
	int y;
	Liste_chemin temp = listeChemin;
	while(temp != NULL)
    {
		id = temp->id;
		printf("%s = \n", temp->id);
		Liste_point tempListe = temp->chemin;
		while(tempListe != NULL)
		{
			x =  tempListe->point->x;
			y =  tempListe->point->y;
			printf("%d , %d \n", x, y);
			tempListe = tempListe->nxt;
		}
		temp = temp->nxt;
    }
    
}

Liste_chemin affecterPointToChemin(Liste_chemin listeChemin, char* id, int x, int y)
{
	Liste_chemin temp = GlobalListeChemin;
	char * idtmp;
	int resultat;
	Point point = creer_point(NULL, x, y);
    while(temp != NULL)
    {
    	idtmp = temp->id;
    	resultat = strcmp(idtmp, id);
    	if (resultat == 0){
    		printf("chemin trouvé\n");
    		ajouterPointToChemin(temp->chemin, point);
    		return listeChemin;
    	}
        temp = temp->nxt;
        
    }
    return listeChemin;
}

int ajouterPointToChemin(chemin, point)
{
	Chemin newChemin = creer_chemin(NULL);
	newChemin->point = point;
	newChemin->nxt = NULL;
	Liste_chemin temp = chemin;
    while(temp->nxt != NULL)
    {
        temp = temp->nxt;
    }
    printf("ajout du nouveau chemin'point'\n");
    temp->nxt = newChemin;
}
