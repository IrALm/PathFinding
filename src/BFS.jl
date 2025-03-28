#= 
  Fait par AGANZE LWABOSHI MOISE : mars 2025
=#

include("structure.jl") 

#= 
   
   Fait par AGANZE LWABOSHI MOISE : mars 2025
   Rôle : implémentation de BFS
   Complexité : o( nombre des sommets + nombres d'arretes entre sommets)
   Entrées :le graphe , le point de départ D et le point A 
   Sorties : 

=#

function BFS(graphe , D , A)

    # Créer une file d'attente
    file = File()

    # Ensuite y ajouter le point de départ D
    enfiler(file , D)

    # Création d'un dictionnaire des prédecesseurs
    predecesseurs = Dict{Any , Any}() 
    predecesseurs[D] = nothing

    #Ensuite une variable qui me permettera de compter le nombre des sommets visités
    nombre_de_sommet = 0

    # je crée ensuite un dictionnaire supplémentaire des vérifications pour ne pas vsiter un même sommet deux fois
    verification = Set()
    push!(verification , D)

    # Tant que la file n'est pas vide
    while !estvide(file)

        #je défile la tête
        noeud = defiler( file ) # coût constant

        # marquer le noeud comme visité
        nombre_de_sommet += 1

        # pour chaque successeur de mon noeud ( ses voisins )
        for succ in graphe[noeud]

            successeur = succ[1] # dans cet algo, je n'ai pas besoin des poids , du coup ils sont ignorés

            # je vérifie s'il n'est pas encore visité 
            if !( successeur in verification)

                # s'il n'est pas encore visité , je l'ajoute dans la file
                enfiler( file , successeur ) # coût constant
                push!( verification , successeur) # coût constant

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

    # la distance réelle du chemin
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
    return reverse(chemin), nombre_de_sommet , distance,verification
end

