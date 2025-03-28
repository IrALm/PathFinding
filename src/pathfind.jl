

include("graphe.jl")
include("BFS.jl")
include("Djisktra.jl")
include("Aetoile.jl")
include("WAetoile.jl")
include("WStatique.jl")
include("WAstarversion1.jl")
include("Glouton.jl")
#=
    PATHFINDING 
    fait par AGANZE LWABOSHI Moïse en février 2025
    ce fichier contient les appels des différents algorithmes implémentés
    tout au long de ce projets
    pour les complexités temporelles , se réferer aux algorithmes précedents càd  les fonctions qui y
    sont appelées  

=#
#=
    Rôle : appel BFS
    Complexité : complexité Création du graphe + complexité de BFS + reconstitution du chemin
    Entrée : nom du fichier  , D , A
=#

function algoBFS(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    graphe , nbcolone , nbligne = creation_du_graphe(fname)
    if !haskey(graphe , D) || !haskey(graphe , A)
        println("l'un des deux points est impratiquables")
    else
        t = time()
            chemin , nombre_de_sommet , distance , visites= BFS(graphe , D , A)
        dt = round(time() - t , digits=6)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Temps : " , dt , " sec")
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle : appel BFS
    Complexité : complexité Création du graphe + complexité de Djisktra + reconstitution du chemin
    Entrée : nom du fichier  , D , A
=#

function algoDijkstra(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})
    
    graphe, nbcolone , nbligne = creation_du_graphe(fname)
    if !haskey(graphe , D) || !haskey(graphe , A)
        println("l'un des deux points est impratiquables")
    else
        t = time()
            precedent , nombre_de_sommet , visites = Djisktra(graphe , D , A)
        dt = round(time() - t , digits=6)
        chemin , distance = reconstitution_du_chemin(precedent , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Temps : " , dt , " sec")
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle : appel BFS
    Complexité : complexité Création du graphe + complexité de glouton + reconstitution du chemin
    Entrée : nom du fichier  , D , A
=#

function algoGlouton(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    graphe, nbcolone , nbligne = creation_du_graphe(fname)
    if !haskey(graphe , D) || !haskey(graphe , A)
        println("l'un des deux points est impratiquables")
    else
        t = time()
        chemin , nombre_de_sommet , distance, visites = glouton(graphe , D , A)
        dt = round(time() - t , digits=6)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Temps : " , dt , " sec")
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle : appel BFS
    Complexité : complexité Création du graphe + complexité de Aetoile + reconstitution du chemin
    Entrée : nom du fichier  , D , A
=#
function algoAstar(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    graphe, nbcolone , nbligne = creation_du_graphe(fname)
    if !haskey(graphe , D) || !haskey(graphe , A)
        println("l'un des deux points est impratiquables")
    else
        t = time()
            precedent , nombre_de_sommet , visites = Aetoile(graphe , D , A)
        dt = round(time() - t , digits=6)
        chemin , distance = reconstitution_du_chemin(precedent , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Temps : " , dt , " sec")
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle : appel BFS
    Complexité : complexité Création du graphe + complexité de WAetoile + reconstitution du chemin
    Entrée : nom du fichier  , D , A
=#
function algoWAstar(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int} , w::Float64)

    graphe, nbcolone , nbligne = creation_du_graphe(fname)
    if !haskey(graphe , D) || !haskey(graphe , A)
        println("l'un des deux points est impratiquables")
    else
        t = time()
            precedent , nombre_de_sommet , visites  = WAetoile(graphe , D , A , w)
        dt = round(time() - t , digits=6)
        chemin , distance = reconstitution_du_chemin(precedent , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Temps : " , dt , " sec")
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle : appel BFS
    Complexité : complexité Création du graphe + complexité de WStatique+ reconstitution du chemin
    Entrée : nom du fichier  , D , A
=#
function algoWStatique(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int} , w::Float64)

    graphe, nbcolone , nbligne = creation_du_graphe(fname)
    if !haskey(graphe , D) || !haskey(graphe , A)
        println("l'un des deux points est impratiquables")
    else
        t = time()
            precedent , nombre_de_sommet , visites  = WStatique(graphe , D , A , w)
        dt = round(time() - t , digits=6)
        chemin , distance = reconstitution_du_chemin(precedent , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Temps : " , dt , " sec")
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

#=
    Rôle : appel BFS
    Complexité : complexité Création du graphe + complexité de WAversion1 + reconstitution du chemin
    Entrée : nom du fichier  , D , A
=#
function algoWAstarVersion1(fname::String, D::Tuple{Int,Int}, A::Tuple{Int,Int} , w::Float64)

    graphe, nbcolone , nbligne = creation_du_graphe(fname)
    if !haskey(graphe , D) || !haskey(graphe , A)
        println("l'un des deux points est impratiquables")
    else
        t = time()
            precedent , nombre_de_sommet , visites  = WAversion1(graphe , D , A , w)
        dt = round(time() - t , digits=6)
        chemin , distance = reconstitution_du_chemin(precedent , D , A)
        if chemin != nothing
            println(" \n\n Distance  D -> A           : " , distance )
            println(" Number of states evaluated : " , nombre_de_sommet)
            println(" Temps : " , dt , " sec")
            println(" Path D -> A " )
            for element in chemin
                print(element)
                if element != chemin[end] print("->") end 
            end
        else
            println(" Il n'existe aucun chemin")
        end
    end
    println("\n\n")
end

