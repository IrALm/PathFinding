
#=
    PATH FINDING 
    fait par AGANZE LWABOSHI Moïse en février 2025

=#

import Pkg
Pkg.add("DataStructures")

using DataStructures

function lire_fichier_map(nom_du_fichier::String)

    lignes = []  # Initialiser un tableau pour stocker les lignes
    
    open(nom_du_fichier, "r") do file # Lecture du fichier

        for ligne in eachline(file)
            push!(lignes, strip(ligne))  # Ajouter chaque ligne après suppression des espaces inutiles
        end
    end
    
    return lignes  # Retourner le tableau contenant les lignes du fichier
end

function estLibre(vi, vj  , nbcolone, lignes_du_fichier ) 

    if vi >= 5 && vi <= length(lignes_du_fichier) && vj >= 1 && vj <= nbcolone

        if lignes_du_fichier[vi][vj]=='.'
            return true
         end
    end

    return false
end

function creation_du_graphe(lignes_du_fichier)
   
    # Récupération du nombre des lignes 

    valeur_ligne = split(lignes_du_fichier[2])[end]
    nbligne = parse(Int , valeur_ligne)
    println(" nombre des lignes : " , nbligne)

    # Récupération du nombre des colonnes

    valeur_colone = split(lignes_du_fichier[3])[end]
    nbcolone = parse(Int , valeur_colone)

    println( " nombre des colonnes : " , nbcolone)

    directions = [(-1, 0), (1, 0), # gauche et droite
                  (0, -1), (0, 1), # haut et bas
                  (-1, -1), (-1, 1), # diagonale 1
                  (1, -1) , (1, 1) ] # diagonale 2
    
    # on va initialiser le graphe comme un dictionnaire vide

    graphe = Dict()

    for i in 5:length(lignes_du_fichier)

        for j in 1:nbcolone

            if lignes_du_fichier[i][j] == '.'

                ses_voisins = []

                for (di , dj) in directions 

                    vi , vj = i + di , j + dj

                    println( " vi et vj : " , (vi,vj) )

                    if estLibre(vi , vj , nbcolone, lignes_du_fichier )
                        println("ca passe dans estLibre")
                        push!( ses_voisins ,((vi , vj) , 1)) # si c'est une zone traversable , j'ajoute dans ses voisins avec un poids 
                    end 
                end

                if length(ses_voisins)>0

                    graphe[((i,j) , 0)] = ses_voisins

                end
            end
        end
    end

    return graphe
    
end

function algoBFS(graphe , D , A)

    # Créer une file d'attente

    file = Queue(Deque{Tuple{Tuple{Int, Int}, Int}}())

    # Ensuite y ajouter le point de départ D

    enqueue!( file , D )

    # Création d'un dictionnaire des prédecesseurs et d'un dictionnaire pour marquer les points visités

    predecesseurs = Dict{Tuple{Tuple{Int, Int}, Int}, Union{Nothing, Tuple{Tuple{Int, Int}, Int}}}() 
    visites = Set(D)
    predecesseurs[D] = nothing

    # je crée ensuite un dictionnaire supplémentaire des vérifications
    verification = Set(D)

    # Tant que la file n'est pas vide

    while !isempty(file)

        noeud = dequeue!( file )

        # marquer le noeud comme visité
        
        push!( visites , noeud)

        println(" les successeur de : " , noeud , " sont : " , graphe[noeud])

        # pour chaque successeur de mon noeud , 

        for succ in graphe[noeud]

            successeur = ( succ[1] , 0)
            # je vérifie s'il n'est pas encore visité 

            if !( successeur in visites) && !( successeur in verification)

                
                    # s'il n'est pas encore visité , je l'ajoute dans la file

                    enqueue!( file , successeur )
                    println( " La taille de la file dans le if : " , length(file))
                    push!( verification , successeur)

                    # ensuite j'enregistre son prédécesseur

                    predecesseurs[successeur] = noeud
                
                
            end
        end
        # Si le nœud d'arrivée est trouvé, on arrête la recherche

        if noeud == A 
            println(" *******************************Le point A a été rétrouvé ")
            break
        end
        
    end

        println( " Les visités : " , visites)
        println( " La taille de la file : " , length(file))
        println( " La taille des visités : " , length(visites))
        println(" La taille des verifiées : " , length(verification))
        println( " La taille des prédecesseurs : " , length(predecesseurs))
        println( " les prédecesseurs : " , predecesseurs)
        
        # Ensuite, je veux reconstituer le chemin du départ càd à partir de D jusqu'à A 

        chemin = []

        # courant récois le point d'arrivé A 
        courant = A 

        #= Tant que je ne suis pas arrivé au point de départ D 
           J'ajoute le prédecesseur de courant dans mon chemin
        =#

        while courant != D 

            push!( chemin , courant)
            courant = predecesseurs[courant]

        end

        push!( chemin , courant)

        # Je vais alors inverser l'orde des élements dans mon tableau pour les renvoyer dans le bon ordre

        return reverse(chemin)

end

function main()

    nom_du_fichier = "didactic.map"
    lignes_du_fichier = lire_fichier_map(nom_du_fichier)
    
    graphe = creation_du_graphe(lignes_du_fichier)
    println( "taille du graphe : " , length(graphe))
    #println(graphe)
    D = ((16 , 5), 0)
    A = ((6 , 12) , 0)
    chemin = algoBFS( graphe , D , A)
    if chemin != nothing
        println(" Distance de D -> A : " , length(chemin))
        println( " Path D -> A : " , chemin)
    else
        println(" Il n'existe aucun chemin")
    end
end