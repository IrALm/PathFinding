
#=
  Fait par AGANZE LWABOSHI MOISE : mars 2025
=#

#= 
   Rôle :Fonction permettant de verifier si un point donné est compris dans la limite des lignes du fichier 
   Complexité :
   Entrées :
=#

function estLibre(vi, vj  , nbcolone, lignes_du_fichier ) 
    if vi >= 1 && vi <= length(lignes_du_fichier) && vj >= 1 && vj <= nbcolone
        return true
    end
    return false
end

function creation_du_graphe(nom_du_fichier::String)

    graphe = Dict()
    poids = Dict( '.' => 1.0 , 'S' => 5.0 , 'W' => 8.0 , '@' => nothing , 'T' => 1.0 )
    directions = [(-1, 0), (1, 0), # gauche et droite
                      (0, -1), (0, 1)] # haut et bas
    lignes = []  # Initialiser un tableau pour stocker les lignes
    quatres_premieres_lignes = []
    i = 0
    open(nom_du_fichier, "r") do file # Lecture du fichier
        push!(quatres_premieres_lignes, strip(readline(file)))
        push!(quatres_premieres_lignes, strip(readline(file)))
        push!(quatres_premieres_lignes, strip(readline(file)))
        push!(quatres_premieres_lignes, strip(readline(file)))
        # Récupération du nombre des colonnes
        valeur_colone = split(quatres_premieres_lignes[3])[end]
        nbcolone = parse(Int , valeur_colone)
        push!(lignes, strip(readline(file)))
        push!(lignes, strip(readline(file)))
        construire_les_arcs( lignes, 1 , poids , directions , nbcolone , graphe)
        deleteat!(lignes , 2)
        seekstart(file)
        cpt = 0
        for ligne in eachline(file)
            cpt += 1
            if  cpt > 5
                i += 1
                push!(lignes, strip(ligne))
                if i <= length(lignes) - 1 && i >= 2 
                    construire_les_arcs( lignes, i , poids , directions , nbcolone , graphe)
                end
            end
        end
    end
    # Récupération du nombre des colonnes
    valeur_colone = split(quatres_premieres_lignes[3])[end]
    nbcolone = parse(Int , valeur_colone)
    construire_les_arcs( lignes, length(lignes) , poids , directions , nbcolone , graphe)
    return graphe  # Retourner le tableau contenant les lignes du fichier
end

function construire_les_arcs( lignes, i , poids , directions , nbcolone , graphe)
    j = 0
    for car in lignes[i]
        j += 1 
        if poids[car] != nothing 
            lesvoisins = []
            for(di , dj) in directions
                vi , vj = i + di , j + dj
                if estLibre(vi , vj , nbcolone, lignes)
                    if poids[lignes[vi][vj]] != nothing
                        push!( lesvoisins ,((vi , vj) ,poids[lignes[vi][vj]] )) 
                    end
                end
            end
            if length(lesvoisins)> 0 # s'il a des voisins
                graphe[(i,j)] = lesvoisins # à ce point, j'associe ses voisins
            end
        end
    end
end

# Affichage du graphe

function affichage_du_graphe(graphe) 

    for (noeud , sesvoisins) in graphe 
        println("$(noeud) -> $(sesvoisins)")
    end
end
