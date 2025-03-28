# PathFinding : Recherche du plus court chemin

## Description

Ce projet consiste à la production d'une solution logicielle de recherche du plus court chemin, implémentée en Julia.
Ici, j'implémente principalement 4 algorithmes : 

**L'algorithme BFS**,  **L'algorithme Dijkstra** , **L'algorithme A*** et **L'algorithme Glouton**. Ce projet a pour but de résoudre efficacement des problèmes de pathfinding dans divers contextes.

Ensuite j'ajoute 3 algorithmes supplémentaires implémentant **l'algorithme Weighted A*** sous différentes règles:
 
- **avec 0 <= w <= 1 : w*g(x) + (1 - w) * h(x)**
- **avec w statique et >= 1 : g(x) + w * h(x)**
- **avec w dynamique et >= 1: g(x) + w * h(x)**

---

## Fonctionnalités

- En premier lieu, j'ai un fichier .map contenant les informations sur mon graphe : je dois lire ce fichier.
- Ensuite, une fois le fichier lu et les informations sauvergardés dans un tableau, je construis mon graphe à partir
  de ces informations comme suit : je sauvegarde d'abord les informations sur les nombres des lignes et des colonnes de mon fichier, après parcourir les lignes ensuite pour chaque ligne les colones et si à la ligne i , colonne j j'ai un caractère @ ou T alors la zone est impratiquable , sinon , pratiquable et là, je vérifie les sommets voisins en fonction des quatres directions ( gauche , droite , haut et bas). Ensuite, si à la ligne i , colonne j j'ai un caractère S , alors j'ajoute les coordonnées dans les sommets voisins avec un poids de 5 , si c'est un caractère W , alois j'ajoute les coordonnées avec un poids de 8 , sinon si le caractère est différent de @ et T et autre que S et W, j'ajoute les coordonnées avec un poids de 1 ( consignes de l'énoncé). Après, aux coordonnées (i,j) j'associe ses sommets voisins, ainsi de suite et à la fin j'ai mon graphe complet.
- Une fois le graphe crée, j'implement ensuite les quatres algorithmes cités ci-haut et suivra les 3 autres
- En amont **une interface graphique intuitive a été réalisé pour visualiser le comportement des 7 algorithmes**
-Attention : **Fonctionelle pour les petites instances et non les très grandes**
---

## Installation

### Prérequis

- Avoir installer Julia (la version 1.11)

### Étapes d'installation - REALISATION DES TESTS - Grande Instance : "theglaive.map" - Interface Graphique

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/IrALm/PathFinding.git
   cd PathFinding
2 . Pour compiler le fichier d'exécution en terminal et l'interface graphique fonctionnelle sur des petites instances:

    
    julia
    include("src/pathfind.jl")
    include("src/InterfaceGraphique.jl")

    
3. Pour l'exécution sur le terminal et lancer l'interface graphique et 2 tests sur des petites instances:
   
        
        algoBFS("dat/didactic.map" ,(12,5) ,(2,12))
        algoDijkstra("dat/didactic.map" ,(12,5) ,(2,12))
        algoAstar("dat/didactic.map" ,(12,5) ,(2,12))
        algoGlouton("dat/didactic.map" ,(12,5) ,(2,12))
        algoBFS("dat/theglaive.map" , (189,193) ,(226,437))
        algoGlouton("dat/theglaive.map" , (189,193) ,(226,437))
        algoDijkstra("dat/theglaive.map" , (189,193) ,(226,437))
        algoAstar("dat/theglaive.map" , (189,193) ,(226,437))
        algoWAstarVersion1("dat/theglaive.map" , (189,193) ,(226,437) , 0.35)
        algoWStatique("dat/theglaive.map" , (189,193) ,(226,437) , 1.85)
        algoWAstar("dat/theglaive.map" , (189,193) ,(226,437) , 3.95)
        main("dat/didactic.map" , (45 , 5) ,(2,12) , 0.9 , 1.2 , 4.5)
        main("dat/test.map" , (28 , 23) ,(10,16) , 0.56 , 3.9 , 4.5)
   
   ## Explication :
   - algoBFS = nom de la fonction
   - dat/didactic.map = chemin de mon fichier .map
   - (12,5) = coordonnée de départ D
   - (2,12) = coordonnée d'arrivée A
   ## Explication pour l'exécution de l'interface graphique:
   - main = nom de la fonction permettant de démarrer l'interface graphique
   - dat/didactic.map = chemin de mon fichier .map
   - (12,5) = coordonnée de départ D
   - (2,12) = coordonnée d'arrivée A
   - 0.9 : poids w pour la première version de WA* : WAstarversion1
   - 1.2 : poids w pour la deuxième version de WA* : WStatique
   - 4.5 : poids w pour la troisième version de WA* : WAetoile


