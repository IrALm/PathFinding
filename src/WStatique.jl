
#=

    fait par AGANZE LWABOSHI MOISE en mars 2025
=#

include("Aetoile.jl")

#=
  Rôle : implémentation de wA* avec w statique
  complexité : dans le pire des cas idem pour A* sauf que si w est assez grand , on visite moins des noeuds
  entréés : même entréés que les autres algos précedents
  sorties : même sorties que les autres algos précedents
=#

function WStatique( graphe , D , A , w ) 
    if  w >= 1
        #Initialisation des distances et des prédecesseurs
        distance = Dict{Any, Any}()
        precedent = Dict{Any , Any}()

        #Ensuite une variable qui me permettera de compter le nombre des sommets visités
        nombre_de_sommet = 0

        # je crée ensuite un dictionnaire supplémentaire des vérifications pour ne pas vsiter un même sommet deux fois
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
        inserer(tas, D , 0.0 + heuristique_manathan(D,A) * w) #f(D) = g(D) + w * h(D)
        while !estVide(tas) 
            # Extraction du sommet avec la plus petite distance
            u = extraire(tas)[1]
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
                f_v = new_dist + heuristique_manathan(v,A) * w  # f(v) = g(v) + w * h(v)
                if new_dist < distance[v]
                    distance[v] = new_dist
                    precedent[v] = u , poids
                    if !( v in verification)
                        inserer(tas, v, f_v)
                        push!(verification , v)
                    end
                end

            end
        end
        return precedent , nombre_de_sommet , verification
    end
    println(" W est inférieur à 1 ")
    return nothing , 0 , nothing
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
