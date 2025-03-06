

include("structure.jl")

#= 
  Fait par AGANZE LWABOSHI MOISE : mars 2025
=#



function Djisktra(graphe , D , A)

    # Initialisation des distances et prédécesseurs
    distance = Dict{Any, Any}()
    precedent = Dict{Any , Any}()

    #Ensuite une variable qui me permettera de compter le nombre des sommets visités
    nombre_de_sommet = 0

    # je crée ensuite un dictionnaire supplémentaire des vérifications pour ne pas vsiter un même sommet deux fois
    verification = Set()
    push!(verification , D)

   # Initialisation des valeurs par défaut
   for sommet in keys(graphe)
       distance[sommet] = Inf
       precedent[sommet] = nothing , 0.0
   end

   distance[D] = 0.0

   # File de priorité stockant (sommet => poids)
   tas = FileAvecPriorite()
   inserer(tas, D, 0.0)

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

       # On parcourt les voisins de u pour faire la mise à jour de la distance
       # Le but étant de prendre le voisin avec la plus petite distance

       for (v,poids) in graphe[u]

           nouvelle_distance = dist_u + poids
           if nouvelle_distance < distance[v]
               distance[v] = nouvelle_distance
               precedent[v] = u , poids
               if !( v in verification)
                   inserer(tas, v, nouvelle_distance)
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