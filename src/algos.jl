using DataStructures  # Pour la file (Queue)

function BFS(G, vD, vA)
    # G : le graphe, sous forme de dictionnaire (clé : noeud, valeur : liste des successeurs)
    # vD : le noeud de départ (start)
    # vA : le noeud d'arrivée (goal)

    # Créer une file F
    F = Queue()

    # Enfiler vD dans F
    enqueue!(F, vD)

    # Créer un dictionnaire pour marquer les noeuds comme visités
    visited = Dict{Any, Bool}()
    
    # Marquer le noeud de départ comme visité
    visited[vD] = true
    
    # Créer un dictionnaire pour enregistrer les prédécesseurs
    predecessors = Dict{Any, Any}()

    # Tant que F ≠ ∅
    while !isempty(F)
        # Défile le premier élément de la file F
        u = dequeue!(F)

        # Si l'on atteint le noeud d'arrivée, on peut arrêter l'algorithme
        if u == vA
            break
        end

        # Obtenir les successeurs de u
        S = G[u]

        # Pour chaque successeur s de u
        for s in S
            # Si s n’est pas visité
            if !(s in visited)
                # Ajouter s dans la file F
                enqueue!(F, s)

                # Marquer s comme visité
                visited[s] = true

                # Enregistrer le prédécesseur de s
                predecessors[s] = u
            end
        end
    end

    # Retourner les prédécesseurs (pour reconstruire le chemin ou obtenir la solution)
    return predecessors
end

#-----------------------------------------------------------------------------------------------------------------------------------------------

function Dijkstra(G, vD, vA)
    # Créer une liste L qui contiendra tous les sommets non permanents
    L = Set()

    # Créer des dictionnaires pour les distances, les prédécesseurs, et pour savoir si un sommet est permanent ou non
    distance = Dict()   # Dictionnaire qui stocke la distance minimale de chaque sommet depuis vD
    predecessor = Dict()  # Dictionnaire qui stocke le prédécesseur de chaque sommet
    permanent = Dict()   # Dictionnaire pour marquer si un sommet a été définitivement visité (permanent)

    # Initialiser les distances à +∞ (infinies) pour tous les sommets, les prédécesseurs à rien (nothing),
    # et les sommets comme non permanents (Faux). Ajouter tous les sommets dans la liste L.
    for v in keys(G)
        distance[v] = Inf         # Distance initiale à +∞
        predecessor[v] = nothing  # Aucun prédécesseur au début
        permanent[v] = false      # Marquer tous les sommets comme non permanents
        push!(L, v)               # Ajouter le sommet v à la liste L
    end

    # La distance du sommet de départ (vD) à lui-même est 0
    distance[vD] = 0

    # Tant qu'il existe des sommets non permanents dans L
    while !isempty(L)
        # Trouver le sommet non permanent dans L ayant la distance minimale
        u = argmin(v -> distance[v], filter(v -> !permanent[v], L))  # Filtrer pour ne garder que les sommets non permanents
        # Trouver celui qui a la plus petite valeur de distance
        # 'argmin' retourne l'indice du sommet avec la distance minimale

        # Retirer u de L et le marquer comme permanent (nous avons fini d'explorer ce sommet)
        pop!(L, u)         # Retirer u de la liste L
        permanent[u] = true  # Marquer u comme permanent

        # Pour chaque successeur v de u dans le graphe
        for v in G[u]  # G[u] donne la liste des voisins (successeurs) de u
            if !permanent[v]  # Si v n'est pas encore permanent
                # Mettre à jour la distance de v si un chemin plus court via u est trouvé
                new_distance = distance[u] + G[u][v]  # Calculer la distance via u
                if new_distance < distance[v]  # Si ce nouveau chemin est plus court que l'ancien
                    distance[v] = new_distance  # Mettre à jour la distance de v
                    predecessor[v] = u  # Mettre à jour le prédécesseur de v à u
                end
            end
        end
    end

    # Reconstituer le chemin de vD à vA en utilisant le dictionnaire des prédécesseurs
    path = []  # Initialiser une liste vide pour le chemin
    current = vA  # Commencer avec le sommet d'arrivée vA

    while current != nothing  # Tant que nous n'avons pas atteint vD (nous remontons le chemin)
        push!(path, current)  # Ajouter le sommet actuel au chemin
        current = predecessor[current]  # Passer au prédécesseur du sommet actuel
    end

    # Vérifier si le chemin existe (c'est-à-dire si on a pu remonter jusqu'à vD)
    if path[end] == vD  # Si le dernier sommet du chemin est vD, alors le chemin est valide
        return reverse(path)  # Retourner le chemin dans l'ordre correct (vD à vA)
    else
        return nothing  # Si le chemin ne mène pas à vD, il n'existe pas de chemin entre vD et vA
    end
end


#--------------------------------------------------------------------------------------------------

function A_star(G, vD, vA, h)
    # Créer des dictionnaires pour les distances (g), les prédécesseurs, et les sommets visités
    g = Dict()  # Coût depuis le départ jusqu'à chaque sommet
    f = Dict()  # f = g + h, coût total estimé
    predecessor = Dict()  # Prédécesseur de chaque sommet
    visited = Set()  # Ensemble des sommets visités

    # Initialisation des dictionnaires
    for v in keys(G)
        g[v] = Inf  # Initialiser le coût à Inf pour tous les sommets
        f[v] = Inf  # Initialiser f à Inf
        predecessor[v] = nothing  # Aucun prédécesseur au début
    end

    # La distance du sommet de départ à lui-même est 0
    g[vD] = 0
    f[vD] = h(vD)  # f = g + h, ici g = 0 et h(vD) est l'heuristique

    # Créer une liste ouverte (open list) et ajouter le sommet de départ
    open_list = Set([vD])

    # Tant que la liste ouverte n'est pas vide
    while !isempty(open_list)
        # Sélectionner le sommet avec le f minimal dans la liste ouverte
        u = argmin(v -> f[v], open_list)

        # Si le sommet d'arrivée a été atteint, on peut reconstruire le chemin
        if u == vA
            path = []
            current = vA
            while current != nothing
                push!(path, current)
                current = predecessor[current]
            end
            return reverse(path)  # Retourner le chemin dans le bon ordre
        end

        # Retirer u de la liste ouverte et marquer comme visité
        delete!(open_list, u)
        push!(visited, u)

        # Pour chaque voisin de u
        for v in G[u]
            if v in visited  # Ne pas traiter les sommets déjà visités
                continue
            end

            # Calculer le coût g pour ce voisin
            tentative_g = g[u] + G[u][v]

            if tentative_g < g[v]  # Si le nouveau coût est meilleur
                g[v] = tentative_g
                f[v] = g[v] + h(v)  # Mettre à jour f(v) = g(v) + h(v)
                predecessor[v] = u  # Le prédécesseur de v est u
                if !(v in open_list)
                    push!(open_list, v)  # Ajouter v à la liste ouverte
                end
            end
        end
    end

    return nothing  # Si aucun chemin n'est trouvé
end
#--------------------------------------------------------------------------------------------


function Greedy(G, vD, vA, h)
    # Créer un dictionnaire pour les prédécesseurs et la liste des sommets visités
    predecessor = Dict()   # Dictionnaire pour stocker le prédécesseur de chaque sommet (pour reconstruire le chemin)
    visited = Set()        # Ensemble pour suivre les sommets déjà visités
    
    # Initialiser le sommet de départ
    current = vD          # Le sommet actuel est le sommet de départ vD
    visited = Set([current])  # Marquer le sommet de départ comme visité
    
    # Créer une liste ouverte avec le sommet de départ
    open_list = Set([current])  # Liste ouverte des sommets à explorer, initialement avec vD
    
    # Tant que la liste ouverte n'est pas vide
    while !isempty(open_list)
        # Sélectionner le sommet non visité avec la plus petite heuristique (meilleure estimation du coût restant)
        u = argmin(v -> h(v), open_list)   # Sélectionner le sommet u dans open_list ayant la valeur minimale de l'heuristique h(v)
        
        # Si on atteint le sommet d'arrivée, reconstruire le chemin
        if u == vA    # Si le sommet actuel u est le sommet d'arrivée vA
            path = []  # Créer une liste vide pour stocker le chemin final
            current = vA  # Commencer la reconstruction du chemin depuis vA
            while current != vD   # Tant qu'on n'atteint pas le sommet de départ vD
                push!(path, current)  # Ajouter le sommet actuel au chemin
                current = predecessor[current]  # Remonter au prédécesseur du sommet actuel
            end
            push!(path, vD)  # Ajouter le point de départ vD au chemin
            return reverse(path)  # Retourner le chemin dans l'ordre correct (du départ à l'arrivée)
        end
        
        # Retirer u de la liste ouverte et marquer comme visité
        delete!(open_list, u)   # Retirer le sommet u de la liste ouverte (il est désormais exploré)
        push!(visited, u)       # Ajouter u à la liste des sommets visités
        
        # Pour chaque voisin v de u, si v n'a pas été visité
        for v in keys(G[u])    # Parcourir chaque voisin v de u dans le graphe G
            if !(v in visited)   # Si v n'a pas encore été visité
                # Ajouter v à la liste ouverte et définir u comme prédécesseur de v
                push!(open_list, v)  # Ajouter v à la liste des sommets à explorer (ouverte)
                predecessor[v] = u  # Définir u comme prédécesseur de v (pour reconstruire le chemin)
            end
        end
    end
    
    # Si aucun chemin n'est trouvé, renvoyer nothing
    return nothing  # Si on ne trouve pas de chemin, retourner nothing (aucun chemin possible)
end
