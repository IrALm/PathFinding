# PathFinding : Recherche du plus court chemin

## Description

Ce projet consiste à la production d'une solution logicielle de recherche du plus court chemin, implémentée en Julia.
Ici, j'implémente principalement 4 algorithmes : 

**L'algorithme BFS**,  **L'algorithme Dijkstra** , **L'algorithme A*** et **L'algorithme Glouton**. Ce projet a pour but de résoudre efficacement des problèmes de pathfinding dans divers contextes.

---

## Fonctionnalités

- En premier lieu, j'ai un fichier .map contenant les informations sur mon graphe : je dois lire ce fichier.
- Ensuite, une fois le fichier lu et les informations sauvergardés dans un tableau, je construis mon graphe à partir
  de ces informations comme suit : je sauvegarde d'abord les informations sur les nombres des lignes et des colonnes de mon fichier, après parcourir les lignes ensuite pour chaque ligne les colones et si à la ligne i , colonne j j'ai un caractère @ alors la zone est impratiquable , sinon , pratiquable et là, je vérifie les sommets voisins en fonction des quatres directions ( gauche , droite , haut et bas). Ensuite, si à la ligne i , colonne j j'ai un caractère S , alors j'ajoute les coordonnées dans les sommets voisins avec un poids de 5 , si c'est un caractère W , alois j'ajoute les coordonnées avec un poids de 8 , sinon si le caractère est différent de @ et autre que S et W, j'ajoute les coordonnées avec un poids de 1 ( consignes de l'énoncé). Après, aux coordonnées (i,j) j'associe ses sommets voisins, ainsi de suite et à la fin j'ai mon graphe complet.
- Une fois le graphe crée, j'implement ensuite les quatres algorithmes cités ci-haut.
---

## Installation

### Prérequis

- Avoir installer Julia (la version 1.11)

### Étapes d'installation

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/IrALm/PathFinding.git
   cd PathFinding
2 . Pour compiler :

    
    julia
    include("src/pathfind.jl")
    
3. Pour l'exécution :
   
        
        algoBFS("dat/didactic.map" ,(12,5) ,(2,12))
        algoDijkstra("dat/didactic.map" ,(12,5) ,(2,12))
        algoAstar("dat/didactic.map" ,(12,5) ,(2,12))
        algoGlouton("dat/didactic.map" ,(12,5) ,(2,12))
   
   ## Explication :
   - algoBFS = nom de la fonction
   - dat/didactic.map = chemin de mon fichier .map
   - (12,5) = coordonnée de départ D
   - (2,12) = coordonnée d'arrivée A

