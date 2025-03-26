#=

    fait par AGANZE LWABOSHI MOISE en mars 2025
=#

using GLMakie
include("graphe.jl")
include("BFS.jl")
include("Djisktra.jl")
include("Glouton.jl")
include("Aetoile.jl")
include("WAetoile.jl")

function main(fname::String , D::Tuple{Int , Int} , A::Tuple{Int , Int} , w::Float64)

    # Création du graphe
    graphe , nbcolone , nbligne = creation_du_graphe(fname)

    # Création de la figure Makie
    figure = Figure(size = (1200, 600))  
    axe = Axis(figure[1, 3], title="PathFinding" ,xlabel = "x", ylabel = "y")

    # Dessine le graphe

    function dessine_graphe( axe , graphe)
        for i in 1:nbligne 
            for j in 1:nbcolone 
                if haskey(graphe , (i,j)) 
                    if (i,j) == D
                        scatter!(axe , [i] , [j] , color=:green, marker =:rect,markersize=30)
                    elseif (i,j) == A
                        scatter!(axe , [i] , [j] , color=:red, marker =:rect,markersize=30)
                    else
                        scatter!(axe , [i] , [j] , color=:black, markersize=10)
                    end
                else
                    scatter!(axe , [i] , [j] , color=:black, marker =:rect , markersize=80)
                end
            end
        end
    end

    # Sélection de l'algorithme et bouton
    choisir_algorithme = Observable("A*")
    execution = Button(figure[2, 1], label="Exécuter l'algorithme")

    # Dropdown pour choisir l'algorithme
    menu = Menu(figure[3, 1], options=["A*", "WA*", "Dijkstra", "BFS" , "Glouton"], default="A*")
    on(menu.selection) do sel
        choisir_algorithme[] = sel
    end

    # Fonction pour exécuter l'algorithme et visulaiser son comportement

    function execution_de_l_algorithme( axe , choisir_algorithme , graphe , D , A , W) 

        # D'abord commencer par nettoyer l'affichage
        empty!(axe)
        # Ensuite redessiner le graphe
        dessine_graphe(axe , graphe)
        # Ensuite choisir l'algorithme à executer 
        if choisir_algorithme == "A*"
            precedent , nombre_de_sommet , visites = Aetoile(graphe , D , A)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "WA*"
            precedent , nombre_de_sommet , visites = WAetoile(graphe , D , A , w)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "Dijkstra"
            precedent , nombre_de_sommet , visites = Djisktra(graphe , D , A)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "BFS"
            chemin , nombre_de_sommet , distance , visites = BFS(graphe , D , A)
        else
            chemin , nombre_de_sommet , distance , visites = glouton(graphe , D , A)
        end
        # Afficher les noeud visités en rouge
        scatter!( axe , [noeud[1] for noeud in visites] ,
                        [noeud[2] for noeud in visites] ,
                        color=:red ,markersize = 10)
        # Afficher le plus court chemin en vert
        if !isempty(chemin)
            lines!(axe, [noeud[1] for noeud in chemin], 
                    [noeud[2] for noeud in chemin], 
                    color=:blue, linewidth=10)
        end
    end


    # Connecter le bouton à la fonction d'exécution
    on(execution.clicks) do _
        execution_de_l_algorithme(axe, choisir_algorithme[], graphe, D, A , w)
    end

    # Affichage initial du graphe
    dessine_graphe(axe , graphe)
    display(figure)
end
