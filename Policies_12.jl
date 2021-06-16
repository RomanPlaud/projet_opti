module Policies_12 #Replace 42 by your groupe number
using ..CantStop # to access function exported from CantStop

"""
You have to define a policy for each question
    (you can reuse code, or even use the same policy for multiple questions
    by copy-pasting)

A policy is a set of two functions with the same name (arguments described later) :

- The first function is called once the dices are thrown.
It take as argument a game_state called gs and an admissible movements set.
It return the index of the admissible movements chosen as an integer.

- The second function is called to choose to stop the turn or continue with a new throw.
It take as argument a game_state and return a boolean: true if you stop, false if you continue.

A admissible movement sets is given as a vector of tuple. Each of the tuple being
an admissible movement offered by the throw.
Eg : adm_movement = [(4),(6,6),(5,7)]. In this case
returning 1 mean that you move your tentative marker on column 4 by 1;
returning 2 mean that you move twice on column 6;
returning 3 mean that you move on 5 and 7.

A game_state is an "object" defined in the module CantStop.
It has the following useful fields
    players_position :: Array{Int,2} # definitive position at start of turn
    tentitative_movement:: Array{Int,1} # tentitative position for active player
    non_terminated_columns :: Array{Int,1} #columns that have not been claimed yet
    nb_player :: Int #number of players in the game
    open_columns :: Array{Int,1} #columns open during this turn (up to 3)
    active_player :: Int #index of active player


For example:
gs.tentitative_movement is a vector of 12 integer.
gs.tentitative[4] is the number of tentitative move done during this turn in column 4.
gs.players_position[i,j] is the position of the definitive marker of player i in column j
gs.open_column = [2,5] means that, during this turn, there is non-null tentitative
movement in column 2 and 5.

Finally you can access the length of column j by column_length[j].
"""

include("functions_12.jl")

function policy_q1(gs::game_state, adm_movement)
    best_mov = -1
    best_score = 0
    double=-1
    for j in 1:length(adm_movement)
        mov = adm_movement[j]
        score = 0
        if mov[1]==mov[2]
            double = j
        end
        for m in mov
            pos = (gs.tentitative_movement[m]+gs.players_position[gs.active_player, m])
            score +=pos/column_length[m]
            if score>best_score #prend le mouvement avec le meilleur score
                best_score = score
                best_mov = j
            end
        end
    end
    if best_score==0
        if double!=-1 #s'il y a un double et qu'aucune colonne n'est commencé on joue le double
            return double
        else
            return 1
        end
    else
        return best_mov
    end
end

function policy_q1(gs::game_state)
    if length(gs.open_columns)<3
        return false
    else
        i = gs.open_columns[1]
        j = gs.open_columns[2]
        k = gs.open_columns[3]
        for col in gs.open_columns
            d = column_length[col]-(gs.tentitative_movement[col]+gs.players_position[gs.active_player,col]) #si on peut fermer on ferme
            if d ==0
                return true
            end
        end
        p = proba(i,j,k)
        return (sum(gs.tentitative_movement) > -floor(1/log(p))*1.75)
    end
end

#Question 2

function policy_q2(gs::game_state, adm_movement)
    return policy_q1(gs,adm_movement) #policy_q3(gs,adm_movement)
end

function policy_q2(gs::game_state)
    if length(gs.open_columns)<3
        return false
    else
        i = gs.open_columns[1]
        j = gs.open_columns[2]
        k = gs.open_columns[3]
        for col in gs.open_columns
            d = column_length[col]-(gs.tentitative_movement[col]+gs.players_position[gs.active_player,col]) #si on peut fermer on ferme
            if d ==0
                return true
            end
        end
        p = proba(i,j,k)
        d_i = column_length[i]-(gs.tentitative_movement[i]+gs.players_position[gs.active_player][i])
        d_j = column_length[j]-(gs.tentitative_movement[j]+gs.players_position[gs.active_player][j])
        d_k = column_length[k]-(gs.tentitative_movement[k]+gs.players_position[gs.active_player][k])
        G_max = maximum([d_i,d_j,d_k])
        g = 0
        pi = poli_opti_q2(G_max,p)
        nb_opti = pi[gs.n_turn,g+1]

        return (sum(gs.tentitative_movement) > nb_opti*1.75)
    end
end


#Question 3
function policy_q3(gs::game_state, adm_movement)
    best_mov = -1
    best_score = 0
    double=-1
    best_col = -1
    best_score_col = 0
    for j in 1:length(adm_movement)
        mov = adm_movement[j]
        score = 0
        score_col = 0
        if mov[1]==mov[2]
            double = j
        end
        for m in mov
            pos = (gs.tentitative_movement[m]+gs.players_position[gs.active_player, m])
            score +=pos/column_length[m]
            score_col = pos/column_length[m]
            if score>best_score #prend le mouvement avec le meilleur score
                best_score = score
                best_mov = j
            end
            if score_col >best_score_col #mouvement avec la meilleure colonne
                best_col = j
                best_score_col = score_col
            end
        end
    end
    if best_score == 0
        if double!=-1 #s'il y a un double et qu'aucune colonne n'est commencée on joue le double
            return double
        else
            return 1
        end
    elseif (11-length(gs.non_terminated_columns ))==2 #il ne reste plus que 1 colonne a fermer
        return best_col
    else
        return best_mov
    end
end

function policy_q3(gs::game_state)
    return policy_q1(gs)
end

#Question 4

function policy_q4(gs::game_state, adm_movement)
    policy_q3(gs,adm_movement)
end

function policy_q4(gs::game_state)
    if length(gs.open_columns)<3
        return false
    else
        a = gs.active_player
        for col in gs.open_columns
            d = column_length[col]-(gs.tentitative_movement[col]+gs.players_position[a,col]) #si on peut fermer on ferme
            if d ==0
                return true
            end
        end
        win = zeros(gs.nb_player)
        for i in 1:gs.nb_player
            if i!=a
                for c in 2:12
                    if gs.players_position[i, c]/column_length[c] >0.75
                        # on considère qu'un joueur a presque fini lorsqu'il est a plus de 75% de la hauteur de la colonne
                        win[i]+=1
                    end
                end
            end
        end
        i = gs.open_columns[1]
        j = gs.open_columns[2]
        k = gs.open_columns[3]
        p = proba(i,j,k)
        if maximum(win)==3 #politique aggressive si un adversaire presque fini
            return false #joue tant qu'on a pas fermé une colonne
        else
            return (sum(gs.tentitative_movement) > -floor(1/log(p))*2.) #joue légérement plus agressif
        end
    end
end

#Question 5
function policy_q5(gs::game_state, adm_movement)
    best_mov = -1
    best_score = 0
    double=-1
    best_col = -1
    best_score_col = 0
    best_start = -1
    best_score_start = 0
    for j in 1:length(adm_movement)
        mov = adm_movement[j]
        score = 0
        score_col = 0
        score_start = 2. *gs.nb_player #vaut 2*gs.nb_player si la colonne n'est pas encore entamée'
        if mov[1]==mov[2]
            double = j
        end
        for m in mov
            for player in 1:gs.nb_player
                if j!=gs.active_player #pénalise les colonnes ou il y a d'autre joueur (d'autant plus que les joueurs sont avancés sur la colonne)''
                    pen = gs.players_position[player, m]/column_length[m]
                    score_start-=pen
                end
            end
            pos = (gs.tentitative_movement[m]+gs.players_position[gs.active_player, m])
            score +=pos/column_length[m]
            score_col = pos/column_length[m]
            if score>best_score #prend le mouvement avec le meilleur score
                best_score = score
                best_mov = j
            end
            if score_col >best_score_col #mouvement avec la meilleure colonne
                best_col = j
                best_score_col = score_col
            end
            if score_start>best_score_start
                best_start = j
                best_score_start = score_start
            end
        end
    end
    if best_score == 0
        if double!=-1 #s'il y a un double et qu'aucune colonne n'est commencée on joue le double
            return double
        else
            return best_start #commence sur colonne la moins entammée possible
        end
    elseif (11-length(gs.non_terminated_columns ))==2 #il ne reste plus que 1 colonne a fermer
        return best_col
    else
        return best_mov
    end
end

function policy_q5(gs::game_state)
    return policy_q4(gs)
end

#Question 6
function policy_q6(gs::game_state, adm_movement)
    return policy_q5(gs,adm_movement)
end

function policy_q6(gs::game_state) #max agressivité (joue tant que pas fini)
    return policy_q1(gs)
end

#Question 7
function policy_q7(gs::game_state, adm_movement)
    return 1
end
function policy_q7(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 8
function policy_q8(gs::game_state, adm_movement)
    return 1
end
function policy_q8(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

end #end of module