
include("structure.jl")

#=
    Fait par AGANZE LWABOSHI MOISE : mars 2025
    Rôle : implémente Glouton 
    Complexité : o( nombre des sommets + nombre d'arretes entre sommets) dans le pire des cas
    Entrée : graphe , D , A
    Sortie : chemin , nombre_de_sommet , distance , visites
=# 

function glouton(graphe , D , A) 
    
    # File de priorité  triée selon l'heuristique h(v)
    tas = FileAvecPriorite()

    # Dictionnaire pour suivre le chemin
    precedent = Dict{Any , Any}()
    
    #Ensuite une variable qui me permettera de compter le nombre des sommets visités
    nombre_de_sommet = 0

    # je crée ensuite un dictionnaire supplémentaire des vérifications pour ne pas vsiter un même sommet deux fois
    verification = Set()
    push!(verification , D)

    # Initialisation : on met le départ dans le tas
    inserer(tas, D, Float64(heuristique_manathan(D, A)))

    precedent[D] = nothing , 0.0

    while !estVide(tas)

        # Extraire le sommet avec la plus petite valeur heuristique
        u = extraire(tas)[1]

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
            return chemin , nombre_de_sommet , distance , verification # Retourne le chemin trouvé
        end

        # Explorer les voisins

        for (v, poids) in graphe[u]

            if !haskey(precedent, v)
                precedent[v] = u , poids
                if !( v in verification)
                    inserer(tas, v, Float64(heuristique_manathan(v, A)))
                    push!(verification , v)
                end
            end

        end
    end
    return []  , nombre_de_sommet  , distance , verification # Aucun chemin trouvé
end

