include("CantStop.jl")
using .CantStop

include("Policies_12.jl") #replace 42 by your group number
include("Policies_666.jl") #replace 666 by your adversary number
using .Policies_12 , .Policies_666

policy1 = Policies_12.policy_q1
policy2 = Policies_12.policy_q4



#Simulating a game with player1 policy

gs = CantStop.game_state(1) #Initialising a one player game
CantStop.simulate_game!(gs,[policy1,policy2], 5) # the third argument is a verbosity level

#Simulating 1000 games with policy1
N=1000
nb_turns, winner = test_policy([policy1],N)
println("stratégie pour 1 joueur termine en ",sum(nb_turns)/N," tours")
println("winners ", winner)


#Simulating a game with player1 and player 2 policy
#gs = game_state(2)
#simulate_game!(gs,[policy1,policy2], 2)

# plotting a game
#include("plot_position.jl")
#plot_position(gs)
#plot!()
