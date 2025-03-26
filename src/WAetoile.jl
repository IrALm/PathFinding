
#=

    fait par AGANZE LWABOSHI MOISE en mars 2025
=#

include("structure.jl")
include("Aetoile.jl")

function WAetoile( graphe , D , A , w_init ) 
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
    inserer(tas, D , 0.0 + heuristique_manathan(D,A) * w_init) #f(D) = g(D) + w * h(D)
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
        #verifions le nombre d'arrête qui partent du somment un
        d_u = length(graphe[u])
        #= Ensuite on va ajuster dynamiquement w en fonction de la nature du graphe
            si d_u > 4 : je considère que mon graphe est dense : 
            là je diminue w pour eviter de déborder et faire des explorations inutiles
            si d_u <= 4 : je considère que j'ai un graphe clairsemé :
            là j'augmente w pour aller plus vite
        =#
        if d_u > 4 
            w = max( 1.0 , w_init - 0.1)
        else
            w = min( 2.5 , w_init + 0.1)
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

function reconstitution_du_chemin(precedent , D , A) 
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
