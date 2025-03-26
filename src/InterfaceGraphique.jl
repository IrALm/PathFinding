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
include("WStatique.jl")
include("WAstarversion1.jl")

function main(fname::String , D::Tuple{Int , Int} , A::Tuple{Int , Int} , w1::Float64 , w2::Float64 , w3::Float64)

    # Création du graphe
    graphe , nbcolone , nbligne = creation_du_graphe(fname)

    # Création de la figure Makie
    figure = Figure(size = (1200, 900))  
    axe = Axis(figure[0, 1], title="PathFinding" ,xlabel = "x", ylabel = "y")

    # Définition d'un GridLayout pour organiser les éléments
    layout = figure[1,1] = GridLayout()

    # Taille du Box
    largeur = 500
    hauteur = 250

    # Observable pour la taille du texte
    taille_texte = Observable(14)
    contenu = Observable("Affichage des resultats.")

    # Création d'un conteneur avec un espace interne pour éviter le débordement
    aire_boxe = layout[1,1] = GridLayout(padding = (5, 5, 5, 5))  # Padding (haut, bas, gauche, droite)
    titre = Label(aire_boxe[0,1], 
                text = " --- Résultats : Distance - Temps d'éxecution - plus court chemin -- ",  #  Le titre
                fontsize = 16,
                halign = :center, 
                color = :black)
    # Fond gris (Box)
    background = Box(aire_boxe[1,1], 
                    color = :gray75, 
                    strokewidth = 2, 
                    width = largeur, 
                    height = hauteur)

    # Texte bien cadré à l'intérieur du Box
    texte = Label(aire_boxe[1,1], 
                text = contenu, 
                fontsize = taille_texte, 
                tellwidth = false,  
                width = largeur ,  
                height = hauteur , 
                halign =:left, 
                valign =:top,  
                color =:black,
                word_wrap = true)  #  Active le retour à la ligne automatique

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
                        scatter!(axe , [i] , [j] , color=:gray20, markersize=10)
                    end
                else
                    scatter!(axe , [i] , [j] , color=:black, marker =:rect , markersize=40)
                end
            end
        end
    end

    # Sélection de l'algorithme et bouton
    choisir_algorithme = Observable("A*")
    execution = Button(figure[2,1], label="Exécuter l'algorithme" ,buttoncolor=:black, labelcolor = :yellow)

    # Dropdown pour choisir l'algorithme
    menu = Menu(figure[3, 1], options=["A*", "WA3*","WA2*","WA1*", "Dijkstra", "BFS" , "Glouton"], default="A*", 
                cell_color_inactive_even =:gray70 , 
                cell_color_inactive_odd =:gray50)
    on(menu.selection) do sel
        choisir_algorithme[] = sel
    end

    # Fonction pour exécuter l'algorithme et visulaiser son comportement

    function execution_de_l_algorithme( axe , choisir_algorithme , graphe , D , A , w1 , w2 , w3) 

        # D'abord commencer par nettoyer l'affichage
        empty!(axe)
        # Ensuite redessiner le graphe
        dessine_graphe(axe , graphe)
        # Ensuite choisir l'algorithme à executer 
        if choisir_algorithme == "A*"
            t = time()
                precedent , nombre_de_sommet , visites = Aetoile(graphe , D , A)
            dt = round(time() - t , digits=6)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "WA3*"
            t = time()
                precedent , nombre_de_sommet , visites = WAetoile(graphe , D , A , w3)
            dt = round(time() - t , digits=6)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "WA2*"
            t = time()
                precedent , nombre_de_sommet , visites = WStatique(graphe , D , A , w2)
            dt = round(time() - t , digits=6)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "WA1*"
            t = time()
                precedent , nombre_de_sommet , visites = WAversion1(graphe , D , A , w1)
            dt = round(time() - t , digits=6)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "Dijkstra"
            t = time()
                precedent , nombre_de_sommet , visites = Djisktra(graphe , D , A)
            dt = round(time() - t , digits=6)
            chemin , distance = reconstitution_du_chemin(precedent, D , A)
        elseif choisir_algorithme == "BFS"
            t = time()
                chemin , nombre_de_sommet , distance , visites = BFS(graphe , D , A)
            dt = round(time() - t , digits=6)
        else
            t = time()
                chemin , nombre_de_sommet , distance , visites = glouton(graphe , D , A)
            dt = round(time() - t , digits=6)
        end
        if visites != nothing
            # Afficher les noeud visités en rouge
            scatter!( axe , [noeud[1] for noeud in visites] ,
                            [noeud[2] for noeud in visites] ,
                            color=:red ,markersize = 10)
        end
        # Afficher le plus court chemin en vert
        if chemin != nothing
            lines!(axe, [noeud[1] for noeud in chemin], 
                    [noeud[2] for noeud in chemin], 
                    color=:blue, linewidth=10)
            #Affichage textuelle
            contenu[] =" \n  Distance  D -> A             :   $(distance) 
                         \n  Number of states evaluated  :  $(nombre_de_sommet)
                         \n  Temps   :   $(dt)   sec
                         \n  Path D -> A \n" * join([" ( $(element[1]) , $(element[2]) )  $(element!= chemin[end] ? " -> " : "")" for element in chemin])
        end
        
        
    end


    # Connecter le bouton à la fonction d'exécution
    on(execution.clicks) do _
        execution_de_l_algorithme(axe, choisir_algorithme[], graphe, D, A , w1 , w2 , w3)
    end

    # Affichage initial du graphe
    dessine_graphe(axe , graphe)
    display(figure)
end
