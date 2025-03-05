
#=
    PATHFINDING 
    fait par AGANZE LWABOSHI Moïse en février 2025

=#

import Pkg
Pkg.add("DataStructures")

using DataStructures

#= Rôle :Fonction permettant de lire la carte 
   Complexité :
   Entrées :
=#

function lire_fichier_map(nom_du_fichier::String)

    lignes = []  # Initialiser un tableau pour stocker les lignes
    quatres_premieres_lignes = []
    open(nom_du_fichier, "r") do file # Lecture du fichier
        cpt = 0
        for ligne in eachline(file)
            cpt += 1
            if cpt <= 4 push!(quatres_premieres_lignes, strip(ligne))
            else push!(lignes, strip(ligne)) end # Ajouter chaque ligne après suppression des espaces inutiles
        end
    end
    return lignes , quatres_premieres_lignes  # Retourner le tableau contenant les lignes du fichier
end

#= Rôle :Fonction permettant de verifier si un point donné est compris dans la limite des lignes du fichier 
   Complexité :
   Entrées :
=#

function estLibre(vi, vj  , nbcolone, lignes_du_fichier ) 
    if vi >= 1 && vi <= length(lignes_du_fichier) && vj >= 1 && vj <= nbcolone
        return true
    end
    return false
end

#= Rôle :Fonction permettant de créer le graphe 
   Complexité :
   Entrées :
=#

function creation_du_graphe( quatres_premieres_lignes , lignes_du_fichier)
   
    # Récupération du nombre des lignes 
    valeur_ligne = split(quatres_premieres_lignes[2])[end]
    nbligne = parse(Int , valeur_ligne)
    # Récupération du nombre des colonnes
    valeur_colone = split(quatres_premieres_lignes[3])[end]
    nbcolone = parse(Int , valeur_colone)
    directions = [(-1, 0), (1, 0), # gauche et droite
                  (0, -1), (0, 1), # haut et bas
                  #=(-1, -1), (-1, 1), # diagonale 1
                  (1, -1) , (1, 1) =#] # diagonale 2
    # on va initialiser le graphe comme un dictionnaire vide
    graphe = Dict()
    for i in 1:length(lignes_du_fichier) # parcourir les lignes
        for j in 1:nbcolone # Ensuite les colones
            if lignes_du_fichier[i][j] != '@' # si la zone est pratiquable
                #= j'initialise un tableau vide et dans ce tableau je stockerai les
                   points voisins en fonction des quatres directions 
                =#
                ses_voisins = [] 
                for (di , dj) in directions 
                    vi , vj = i + di , j + dj #déplacement x , y
                    if estLibre(vi , vj , nbcolone, lignes_du_fichier )
                        # si c'est une zone traversable , j'ajoute dans ses voisins avec un poids
                        if lignes_du_fichier[vi][vj]=='S' # marais
                            push!( ses_voisins ,((vi , vj) , 5.0))  
                        elseif lignes_du_fichier[vi][vj]=='W' #eau
                            push!( ses_voisins ,((vi , vj) , 8.0))
                        elseif lignes_du_fichier[vi][vj]!='@' # autre que S et W mais pratiquables
                            push!( ses_voisins ,((vi , vj) , 1.0))
                        end
                    end 
                end
                if length(ses_voisins)> 0 # s'il a des voisins
                    graphe[(i,j)] = ses_voisins # à ce point, j'associe ses voisins
                end
            end
        end
    end
    return graphe
end

#= Rôle : implémentation de BFS
   Complexité :
   Entrées :
=#

function BFS(graphe , D , A)

    # Créer une file d'attente
    file = Queue(Deque{Tuple{Int, Int}}())
    # Ensuite y ajouter le point de départ D
    enqueue!( file , D )
    # Création d'un dictionnaire des prédecesseurs
    predecesseurs = Dict{Any , Any}() 
    predecesseurs[D] = nothing
    nombre_de_sommet = 0
    # je crée ensuite un dictionnaire supplémentaire des vérifications
    verification = Set()
    push!(verification , D)
    # Tant que la file n'est pas vide
    while !isempty(file)
        noeud = dequeue!( file )
        # marquer le noeud comme visité
        nombre_de_sommet += 1
        # pour chaque successeur de mon noeud , 
        for succ in graphe[noeud]
            successeur = succ[1] # dans cet algo, je n'ai pas besoin des poids
            # je vérifie s'il n'est pas encore visité 
            if !( successeur in verification)
                # s'il n'est pas encore visité , je l'ajoute dans la file
                enqueue!( file , successeur )
                push!( verification , successeur)
                # ensuite j'enregistre son prédécesseur
                predecesseurs[successeur] = noeud
            end
        end
        # Si le nœud d'arrivée est trouvé, on arrête la recherche
        if noeud == A 
            break
        end
    end
    # Ensuite, je veux reconstituer le chemin du départ càd à partir de D jusqu'à A 
    chemin = []
    # courant récois le point d'arrivé A 
    courant = A 
    distance = 0.0
    #= Tant que je ne suis pas arrivé au point de départ D 
        J'ajoute le prédecesseur de courant dans mon chemin
    =#
    while courant != D 
        push!( chemin , courant)
        distance += 1.0
        courant = predecesseurs[courant]
    end
    push!( chemin , courant) # quand courant = D
    # Je vais alors inverser l'orde des élements dans mon tableau pour les renvoyer dans le bon ordre
    return reverse(chemin), nombre_de_sommet , distance
end

#= Rôle : implémentation de Djisktra
   Complexité :
   Entrées :
=#

function Djisktra(graphe , D , A)

     # Initialisation des distances, prédécesseurs et sommets visités
     distance = Dict{Tuple{Int, Int}, Float64}()
     precedent = Dict{Any , Any}()
     nombre_de_sommet = 0
     verification = Set()
    # Initialisation des valeurs par défaut
    for sommet in keys(graphe)
        distance[sommet] = Inf
        precedent[sommet] = nothing , 0.0
    end
    distance[D] = 0.0
    # File de priorité stockant (sommet => distance)
    tas = PriorityQueue{Tuple{Int, Int}, Float64}()
    enqueue!(tas, D, 0.0)
    while !isempty(tas)
        # Extraction du sommet avec la plus petite distance
        u = dequeue!(tas)
        dist_u = distance[u]
        # marquer le sommet comme visité
        nombre_de_sommet += 1
        # Si on atteint le point d'arrivée, on peut s'arrêter
        if u == A
            break
        end
        # Mise à jour des voisins
        for (v,poids) in graphe[u]
            new_dist = dist_u + poids
            if new_dist < distance[v]
                distance[v] = new_dist
                precedent[v] = u , poids
                if !( v in verification)
                    enqueue!(tas, v, new_dist)
                    push!(verification , v)
                end
            end
        end
    end
    chemin = []
    courant = A
    distance = 0.0
    while courant != D
        push!(chemin, courant)
        distance += precedent[courant][2] 
        courant = precedent[courant][1]
    end
    push!(chemin, courant)
    return reverse(chemin), nombre_de_sommet , distance

end

#= Rôle : implémentation de A*
   Complexité :
   Entrées :
=#

function heuristique( x , y ) 

    return sqrt((y[1] - x[1])^2 + abs(y[2] - x[2])^2) #Distance euclidienne

end

#=
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
=#

function Aetoile(graphe , D , A )

    #Initialisation des distances et des prédecesseurs
    distance = Dict{Tuple{Int, Int}, Float64}()
    precedent = Dict{Any , Any}()
    nombre_de_sommet = 0
    verification = Set()
    #File de priorité pour selectionner le sommet avec la plus petite valeur
    tas = PriorityQueue{Tuple{Int, Int}, Float64}()
    #Initialisation des distances à l'infinie
    for sommet in keys(graphe)
        distance[sommet] = Inf
        precedent[sommet] = nothing , 0.0
    end
    distance[D] = 0.0 #la distance du sommet de départ est 0
    enqueue!(tas, D , 0.0 + heuristique(D,A)) #f(D) = g(D) + h(D)
    while !isempty(tas) 
        #extraire le sommet avec la plus petite valeur
        u = dequeue!(tas)
        dist_u = distance[u]
        # marquer le sommet comme visité
        nombre_de_sommet += 1        
        # Si on atteint le point d'arrivée, on peut s'arrêter
        if u == A
            break
        end
        # Mise à jour des voisins
        for (v,poids) in graphe[u]
            new_dist = dist_u + poids
            f_v = new_dist + heuristique(v,A) # f(v) = g(v) + h(v)
            if new_dist < distance[v]
                distance[v] = new_dist
                precedent[v] = u , poids
                if !( v in verification)
                    enqueue!(tas, v, f_v)
                    push!(verification , v)
                end
            end
        end
    end
    chemin = []
    courant = A
    distance = 0.0
    while courant != D
        push!(chemin, courant)
        distance += precedent[courant][2] 
        courant = precedent[courant][1]
    end
    push!(chemin, courant)
    return reverse(chemin), nombre_de_sommet , distance
end

#= Rôle : implémentation de Glouton
   Complexité :
   Entrées :
=#

function heuristique_manathan(x, y)
    return abs(x[1] - y[1]) + abs(x[2] - y[2])
end

#=
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
=# 

function glouton(graphe , D , A) 
    
    # File de priorité  triée selon l'heuristique h(v)
    tas = PriorityQueue{Tuple{Int, Int}, Float64}()
    # Dictionnaire pour suivre le chemin
    precedent = Dict{Any , Any}()
    nombre_de_sommet = 0
    verification = Set()
    # Initialisation : on met le départ dans le tas
    enqueue!(tas, D, heuristique_manathan(D, A))
    precedent[D] = nothing , 0.0
    while !isempty(tas)
        # Extraire le sommet avec la plus petite valeur heuristique
        u = dequeue!(tas)
        # marquer le sommet comme visité
        nombre_de_sommet += 1
        # Si on atteint le sommet d'arrivée, on reconstruit le chemin
        if u == A
            chemin = []
            distance = 0.0
            while u != D
                pushfirst!(chemin, u)
                distance += precedent[u][2]
                u = precedent[u][1]
            end
            pushfirst!(chemin, u)
            return chemin , nombre_de_sommet , distance # Retourne le chemin trouvé
        end
        # Explorer les voisins
        for (v, poids) in graphe[u]  # On ignore les poids dans cette algorithme de glouton
            if !haskey(precedent, v)
                precedent[v] = u , poids
                if !( v in verification)
                    enqueue!(tas, v, heuristique_manathan(v, A))
                    push!(verification , v)
                end
            end
        end
    end
    return []  , nombre_de_sommet , distance # Aucun chemin trouvé
end

#=
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
=#

function algoBFS(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    lignes_du_fichier , quatres_premieres_lignes = lire_fichier_map(fname)
    if lignes_du_fichier[D[1]][D[2]] == '@' || lignes_du_fichier[A[1]][A[2]] == '@'
        println("l'un des deux points est impratiquables")
    else
        graphe = creation_du_graphe(quatres_premieres_lignes , lignes_du_fichier)
        chemin , nombre_de_sommet , distance = BFS(graphe , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
=#

function algoDijkstra(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})
    
    lignes_du_fichier , quatres_premieres_lignes = lire_fichier_map(fname)
    if lignes_du_fichier[D[1]][D[2]] == '@' || lignes_du_fichier[A[1]][A[2]] == '@'
        println("l'un des deux points est impratiquables")
    else
        graphe = creation_du_graphe(quatres_premieres_lignes , lignes_du_fichier)
        chemin , nombre_de_sommet , distance = Djisktra(graphe , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
=#

function algoGlouton(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    lignes_du_fichier , quatres_premieres_lignes = lire_fichier_map(fname)
    if lignes_du_fichier[D[1]][D[2]] == '@' || lignes_du_fichier[A[1]][A[2]] == '@'
        println("l'un des deux points est impratiquables")
    else
        graphe = creation_du_graphe(quatres_premieres_lignes , lignes_du_fichier)
        chemin , nombre_de_sommet , distance = glouton(graphe , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
=#

function algoAstar(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    lignes_du_fichier , quatres_premieres_lignes = lire_fichier_map(fname)
    if lignes_du_fichier[D[1]][D[2]] == '@' || lignes_du_fichier[A[1]][A[2]] == '@'
        println("l'un des deux points est impratiquables")
    else
        graphe = creation_du_graphe(quatres_premieres_lignes , lignes_du_fichier)
        chemin , nombre_de_sommet , distance = Aetoile(graphe , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end
