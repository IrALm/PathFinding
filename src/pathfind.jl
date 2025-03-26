

include("graphe.jl")
include("BFS.jl")
include("Djisktra.jl")
include("Aetoile.jl")
include("WAetoile.jl")
include("Glouton.jl")
#=
    PATHFINDING 
    fait par AGANZE LWABOSHI Moïse en février 2025

=#
#=
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
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
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
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
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
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
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
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
    Rôle :
    Complexité :
    Entrée :
    Sortie : 
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
