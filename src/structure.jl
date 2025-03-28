
#=
  Fait par AGANZE LWABOSHI MOISE : mars 2025
  Dans ce fichier , j'implémente toutes les structures nécessaire 
  pour l'élaboration de mes algorithmes
  les opérations sur la file sont toutes en o(1)
  les opérations sur la file de priorité ont un coût logarithmique pour 
  l'insertion et la suppression , reorganisation,.. pour le reste en coût constant
=#

# implémentation d'une file avec une liste chainée double

mutable struct Noeud 
    valeur :: Tuple{Int64 , Int64}
    suivant :: Union{ Noeud , Nothing}
    precedent :: Union{ Noeud , Nothing}
end 

mutable struct File 
    tete :: Union{ Noeud , Nothing }
    queue :: Union{ Noeud , Nothing }
end

#= Rôle : Son Constructeur
   Complexité : o(1)
=#

function File() 
    return File(nothing , nothing)
end

#= Rôle : Fonction pour enfiler
   complexité : o(1)
=#

function enfiler( file:: File , val::Tuple{Int64 , Int64}) 
    noeud = Noeud( val , nothing , nothing)
    if isnothing(file.queue) # verifie si vide
        file.tete = file.queue = noeud
    else
        file.queue.suivant = noeud
        noeud.precedent = file.queue
        file.queue = noeud
    end
end

#= Rôle : defiler la tête
   complexité : o(1)
=#

function defiler( file:: File) 
    if isnothing(file.tete)
        throw(ArgumentError("File vide")) 
    end
    val = file.tete.valeur
    file.tete = file.tete.suivant
    if isnothing(file.tete)
        file.queue = nothing
    else
        file.tete.precedent = nothing
    end
    return val
end

#=
    Rôle : verifier si la file est vide
    complexité : o(1)
=#

function estvide(file::File)
    return isnothing(file.tete) 
end

# implémentation d'une file avec priorité sur les poids

mutable struct FileAvecPriorite 
    tas :: Vector{Tuple{Tuple{Int64 , Int64} , Float64}} # stocke les coordonées et le poids

    # Constructeur pour une file vide

    function FileAvecPriorite() 
        return new(Vector{Tuple{Tuple{Int64 , Int64} , Float64}}()) 
    end
end

#=
    Rôle : trouver l'indexe du parent d'un élément
           Dans un tas binaire min la valeur du noeud parent
           est toujours inférieur à celle des enfants et 
           dans un tas max c'est le contraire
           Dans mon cas, vu que je fais une file de priorité
           sur les poids avec priorité sur le plus petit,
           j'utiliserai la convention pour un tas binaire minimale
=#

function indexParent(i::Int64)::Int64 
    return div( i , 2) #division entière
end

#= 
    Rôle : Fonction qui retourne l'indexe du fils gauche 
=#

function indexFilsgauche(i::Int64)::Int64 
    return 2 * i
end

#=
    Rôle : Fonction qui retourne l'indexe du fils droit
=#

function indexFilsdroit(i::Int64)::Int64 
    return 2 * i + 1
end

#=
    Rôle : Fonction qui verifie si la File de priorité est vide
=#

function estVide( file::FileAvecPriorite)::Bool
    return isempty(file.tas) 
end

#=
    Rôle : Fonction pour inserer un élement dans la file de priorité
=#

function inserer( file::FileAvecPriorite , val::Tuple{Int64 , Int64} , poids::Float64)

    push!(file.tas,(val , poids)) # Ajout de l'élement à la function
    reorganiser(file , length(file.tas))#réorganiser le tas si necessaire
end

#= 
    Rôle : Fonction pour réorganiser le tas après insertion
    complexité : o(log n) dans le pire des cas avec n la taille du tas
=#

function reorganiser(file::FileAvecPriorite , i::Int64)
    while i > 1 && file.tas[i][2] < file.tas[indexParent(i)][2] # comparaison en fonction des poids
        file.tas[i] , file.tas[indexParent(i)] = file.tas[indexParent(i)] ,  file.tas[i] # J'echange avec le parent
        i = indexParent(i) # pour continuer à remonter
    end 
end

#= 
    Rôle : Fonction pour extraire avec le plus faible poids
=#

function extraire( file::FileAvecPriorite )::Tuple{Tuple{Int64 , Int64} , Float64} 
    if estVide(file)
        error(" la file de priorité est vide")
    end
    racine = file.tas[1] #Stocke l'élément avec la plus petite priorité
    if length(file.tas) == 1 
        pop!(file.tas) # Si je n'ai qu'un seul élement, je le supprime directement
    else
        file.tas[1] = file.tas[end] # remplacer la racine par le dernier élement
        pop!(file.tas) #supprimer le dernier élement
        reorganisation_apres_descente(file , 1) #Réorganiser le tas si necessaire
    end
    return racine
end

#= 
    Rôle : reorganiser le tas après l'extraction
    complexité : o(log n) dans le pire des cas avec n la taille du tas
=#

function reorganisation_apres_descente( file::FileAvecPriorite , i::Int64)
    taille = length(file.tas)
    while true
        gauche = indexFilsgauche(i)
        droite = indexFilsdroit(i)
        pluspetit = i
        #verifier si gauche est plus petit
        if gauche <= taille && file.tas[gauche][2] < file.tas[pluspetit][2] 
            pluspetit = gauche
        end
        # verifier si c'est droite
        if droite <= taille && file.tas[droite][2] < file.tas[pluspetit][2] 
            pluspetit = droite
        end
        #si l'élément est dejà bien placé, on arrête
        if pluspetit == i 
            break 
        end
        #Echanger l'élement avec le plus petit de ses fils
        file.tas[i] , file.tas[pluspetit] = file.tas[pluspetit] , file.tas[i]
        i = pluspetit # continuer la descente
    end 
end