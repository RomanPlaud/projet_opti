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

include("functions.jl")

function policy_q1(gs::game_state, adm_movement)
    return 1 #choose the first admissible movement offered
end
function policy_q1(gs::game_state)
    #println("non terminated ", gs.non_terminated_columns)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 2
function policy_q2(gs::game_state, adm_movement)
    best_mov = 1
    nb = 0
    mov = adm_movement[1]
    for j in 1:length(mov)
        if (mov[j] in gs.non_terminated_columns)
            nb+=1
        end
    end

    for i in 2:length(adm_movement)
        nb_mov =0
        for j in 1:length(mov)
            if (mov[j] in gs.non_terminated_columns)
                nb_mov+=1
            end
        end
        if nb_mov>nb
            best_mov = i
            nb = nb_mov
        end
    end
    return best_mov
end
function policy_q2(gs::game_state)
    open_colons = gs.open_columns
    if length(open_colons)<3
        return false
    else
        i = open_colons[1]
        j = open_colons[2]
        k = open_colons[3]
        p = proba(i,j,k)
        d_i = column_length[i]-(gs.tentitative_movement[i]+gs.players_position[gs.active_player][i])
        d_j = column_length[j]-(gs.tentitative_movement[j]+gs.players_position[gs.active_player][j])
        d_k = column_length[k]-(gs.tentitative_movement[k]+gs.players_position[gs.active_player][k])
        G_max = minimum([d_i,d_j,d_k])
        g = 0
        pi = poli_opti_q2(G_max,p)
        nb_opti = pi[gs.n_turn,g]

        return (sum(gs.tentitative_movement) > nb_opti)
    end
end


#Question 3
function policy_q3(gs::game_state, adm_movement)
    best_mov = -1
    best_d = Inf
    for j in 1:length(adm_movement)
        mov = adm_movement[j]
        for i in 1:length(mov)
            d = column_length[mov[i]]-(gs.tentitative_movement[mov[i]]+gs.players_position[gs.active_player][mov[i]])
             if d<best_d
                 best_d = d
                 best_mov = j
             end
        end
    end
    return best_mov
end
function policy_q3(gs::game_state)
    open_colons = gs.open_columns
    if length(open_colons)<3
        return false
    else
        i = open_colons[1]
        j = open_colons[2]
        k = open_colons[3]
        p = proba(i,j,k)
        nb_opti = - floor(1/log(pi))
    end
    return (sum(gs.tentitative_movement) > nb_opti)
end

#Question 4
function policy_q4(gs::game_state, adm_movement)
    return 1
end
function policy_q4(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 5
function policy_q5(gs::game_state, adm_movement)
    return 1
end
function policy_q5(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 6
function policy_q6(gs::game_state, adm_movement)
    return 1
end
function policy_q6(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
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