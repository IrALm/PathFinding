
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
                  #=(-1, -1), (-1, 1), # diagonale 1
                  (1, -1) , (1, 1) =#] # diagonale 2
    
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
                        push!( ses_voisins ,((vi , vj) , 1.0)) # si c'est une zone traversable , j'ajoute dans ses voisins avec un poids 
                    end 
                end

                if length(ses_voisins)>0

                    graphe[(i,j)] = ses_voisins

                end
            end
        end
    end

    return graphe
    
end

function algoBFS(graphe , D , A)

    # Créer une file d'attente

    file = Queue(Deque{Tuple{Int, Int}}())

    # Ensuite y ajouter le point de départ D

    enqueue!( file , D )

    # Création d'un dictionnaire des prédecesseurs et d'un dictionnaire pour marquer les points visités

    predecesseurs = Dict{Tuple{Int, Int}, Union{Nothing, Tuple{Int, Int}}}() 
    visites = Set()
    predecesseurs[D] = nothing

    # je crée ensuite un dictionnaire supplémentaire des vérifications
    verification = Set()
    push!(verification , D)

    # Tant que la file n'est pas vide

    while !isempty(file)

        noeud = dequeue!( file )
        print(" noeud : " , noeud)
        

        # marquer le noeud comme visité
        
        push!( visites , noeud)

        println(" les successeur de : " , noeud , " sont : " , graphe[noeud])

        # pour chaque successeur de mon noeud , 

        for succ in graphe[noeud]

            successeur = succ[1] 
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

# ------------------ Djisktra ---------------------------------------------------------

function djisktra(graphe , D , A)

     # Initialisation des distances, prédécesseurs et sommets visités
     distance = Dict{Tuple{Int, Int}, Float64}()
     precedent = Dict{Tuple{Int, Int}, Union{Nothing, Tuple{Int, Int}}}()
     visites = Set{Tuple{Int, Int}}()
     verification = Set()

     # Initialisation des valeurs par défaut
    for sommet in keys(graphe)
        distance[sommet] = Inf
        precedent[sommet] = nothing
    end
    distance[D] = 0.0
    # File de priorité stockant (sommet => distance)
    tas = PriorityQueue{Tuple{Int, Int}, Float64}()
    enqueue!(tas, D, 0.0)
    while !isempty(tas)
        # Extraction du sommet avec la plus petite distance
        println("Tas avant extraction: ", tas)
        u = dequeue!(tas)
        dist_u = distance[u]
        println("Sommet extrait: ", u, " avec distance: ", dist_u)
        println("Tas après extraction: ", tas)

        # Si le sommet est déjà visité, on passe
        if u in visites
            continue
        end
        push!(visites, u)

        # Si on atteint le point d'arrivée, on peut s'arrêter
        if u == A
            break
        end

        # Mise à jour des voisins
        for (v,poids) in graphe[u]
            
            if v in visites
                continue
            end
            
            new_dist = dist_u + poids
            println("************ new_dist :  " , new_dist )
            if new_dist < distance[v]
                
                distance[v] = new_dist
                print("====== distance[v] = " , distance[v])
                precedent[v] = u
                if !( v in verification)
                    enqueue!(tas, v, new_dist)
                    push!(verification , v)
                end
            end
        end
    end
    print("taille des visités : " , length(visites))
    path = []
    current = A

    while current !== nothing
        push!(path, current)
        current = precedent[current]
    end

    return (path[end] == D) ? reverse(path) : nothing

end

#------------------------------------------ A* ------------------------------------

function heuristique( x , y ) 

    return sqrt((y[1] - x[1])^2 + abs(y[2] - x[2])^2) #Distance euclidienne

end

function Aetoile(graphe , D , A )

    #Initialisation des distances et des prédecesseurs
    distance = Dict{Tuple{Int, Int}, Float64}()
    precedent = Dict{Tuple{Int, Int} , Union{Nothing, Tuple{Int, Int}}}()
    visites = Set{Tuple{Int, Int}}()
    verification = Set()
    #File de priorité pour selectionner le sommet avec la plus petite valeur
    tas = PriorityQueue{Tuple{Int, Int}, Float64}()
    #Initialisation des distances à l'infinie
    for sommet in keys(graphe)
        distance[sommet] = Inf
        precedent[sommet] = nothing 
    end
    distance[D] = 0.0#la distance du sommet de départ est 0
    enqueue!(tas, D , 0.0 + heuristique(D,A)) #f(D) = g(D) + h(D)
    while !isempty(tas) 
        #extraire le sommet avec la plus petite valeur
        u = dequeue!(tas)
        dist_u = distance[u]
        # Si le sommet est déjà visité, on passe
        if u in visites
            continue
        end
        push!(visites, u)

        # Si on atteint le point d'arrivée, on peut s'arrêter
        if u == A
            break
        end
        # Mise à jour des voisins
        for (v,poids) in graphe[u]
            
            if v in visites
                continue
            end
            
            new_dist = dist_u + poids
            f_v = new_dist + heuristique(v,A) # f(v) = g(v) + h(v)
            println("************ f_v :  " , f_v )
            if new_dist < distance[v]
                
                distance[v] = new_dist
                print("====== distance[v] = " , distance[v])
                precedent[v] = u
                if !( v in verification)
                    enqueue!(tas, v, f_v)
                    push!(verification , v)
                end
            end
        end
    end
    print("taille des visités : " , length(visites))
    path = []
    current = A

    while current !== nothing
        push!(path, current)
        current = precedent[current]
    end

    return (path[end] == D) ? reverse(path) : nothing



end

#---------------------- Glouton ------------------------------------
function heuristique_manathan(x, y)
    return abs(x[1] - y[1]) + abs(x[2] - y[2])
end
function glouton(graphe , D , A) 

    # File de priorité  triée selon l'heuristique h(v)
    tas = PriorityQueue{Tuple{Int, Int}, Float64}()
    
    # Dictionnaire pour suivre le chemin
    precedent = Dict{Tuple{Int, Int}, Union{Nothing, Tuple{Int, Int}}}()
    visites = Set{Tuple{Int, Int}}()
    verification = Set()
    
    # Initialisation : on met le départ dans le tas
    enqueue!(tas, D, heuristique_manathan(D, A))
    precedent[D] = nothing
    while !isempty(tas)
        # Extraire le sommet avec la plus petite valeur heuristique
        u = dequeue!(tas)

        # Si le sommet est déjà visité, on passe
        if u in visites
            continue
        end
        push!(visites, u)

        # Si on atteint le sommet d'arrivée, on reconstruit le chemin
        if u == A
            chemin = []
            while u !== nothing
                pushfirst!(chemin, u)
                u = get(precedent, u, nothing)
            end
            print("taille des visités : " , length(visites))
            return chemin  # Retourne le chemin trouvé
        end

        # Explorer les voisins
        for (v, _) in graphe[u]  # On ignore les poids dans cette algorithme de glouton
            if !haskey(precedent, v)
                precedent[v] = u
                if !( v in verification)
                    enqueue!(tas, v, heuristique_manathan(v, A))
                    push!(verification , v)
                end
            end
        end
    end
    print("taille des visités : " , length(visites))
    return []  # Aucun chemin trouvé
end

function main()

    nom_du_fichier = "didactic.map"
    lignes_du_fichier = lire_fichier_map(nom_du_fichier)
    
    graphe = creation_du_graphe(lignes_du_fichier)
    println( "taille du graphe : " , length(graphe))
    #println(graphe)
    D = (16 , 5)
    A = (6 , 12)
    chemin = glouton(graphe , D , A)
    if chemin != nothing
        println(" Distance de D -> A : " , length(chemin) - 1 )
        println( " Path D -> A : " , chemin)
    else
        println(" Il n'existe aucun chemin")
    end
    #=chemin = algoBFS( graphe , D , A)
    if chemin != nothing
        println(" Distance de D -> A : " , length(chemin) - 1 )
        println( " Path D -> A : " , chemin)
    else
        println(" Il n'existe aucun chemin")
    end=#
end