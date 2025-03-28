
# inclure le fichier où j'ai défini ma structure file avec priorité
include("structure.jl") 

#= 
   Fait par AGANZE LWABOSHI MOISE : mars 2025
   Rôle : implémentation de Glouton
   Complexité : o(1) : constant
   Entrées : 2 tuples d'entier
=#

function heuristique_manathan(x, y)
    return abs(x[1] - y[1]) + abs(x[2] - y[2])
end


#=
    Rôle : implémente l'algorithme A*
    Complexité : dans le pire des cas :
                o(nombre des arretes des sommets + 
                  nombres des sommets * log(sommet à explore : pour la file de priorité)) 
    Entrée : le graphe , le point de départ D et le point A 
    Sortie : retoune le nombre des sommets visités , les prédecesseurs de chaque noeud visités ainsi que les noeuds visités
=#

function Aetoile(graphe , D , A )

    #Initialisation des distances et des prédecesseurs
    distance = Dict{Any, Any}()
    precedent = Dict{Any , Any}()

    #Ensuite une variable qui me permettera de compter le nombre des sommets visités
    nombre_de_sommet = 0

    # je crée ensuite un dictionnaire supplémentaire des vérifications pour ne pas visiter un même sommet deux fois
    verification = Set()
    push!(verification , D)

    # File de priorité stockant (sommet => poids)
    tas = FileAvecPriorite()

    #Initialisation des distances à l'infinie
    for sommet in keys(graphe)
        distance[sommet] = Inf
        precedent[sommet] = nothing , 0.0
    end

    distance[D] = 0.0 #la distance du sommet de départ est 0
    inserer(tas, D , 0.0 + heuristique_manathan(D,A)) #f(D) = g(D) + h(D)
    while !estVide(tas)

        # Extraction du sommet avec la plus petite distance
        u = extraire(tas)[1] # coût : logarithmique en la taille du tas
        dist_u = distance[u]

        # marquer le sommet comme visité
        nombre_de_sommet += 1  

        # Si on atteint le point d'arrivée, on peut s'arrêter
        if u == A
            break
        end

        # Mise à jour des voisins
        # coût linéaire au nombre des arrêtes 
        for (v,poids) in graphe[u] 

            new_dist = dist_u + poids
            f_v = new_dist + heuristique_manathan(v,A) # f(v) = g(v) + h(v)
            if new_dist < distance[v]
                distance[v] = new_dist
                precedent[v] = u , poids
                if !( v in verification)
                    inserer(tas, v, f_v) # coût : logarithmique en la taille du tas
                    push!(verification , v) # cût constant
                end
            end

        end
    end
    return precedent , nombre_de_sommet , verification 
end

#= 
    Rôle : reconstitution du chemin 
    complexité : linéaire en A - D
=#

function reconstitution_du_chemin(precedent , D , A) 
    if precedent != nothing 
        chemin = []
        courant = A
        distance = 0.0
        while courant != D
            push!(chemin, courant)
            distance += precedent[courant][2] 
            courant = precedent[courant][1]
        end
        push!(chemin, courant)
        return reverse(chemin) , distance
    end
    return nothing , 0
end
