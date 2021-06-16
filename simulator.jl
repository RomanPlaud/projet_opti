include("CantStop.jl")
using .CantStop

include("Policies_12.jl") #replace 42 by your group number
include("Policies_666.jl") #replace 666 by your adversary number
using .Policies_12 , .Policies_666

policy1 = Policies_12.policy_q1
policy2 = Policies_12.policy_q2
policy3 = Policies_12.policy_q6

#Simulating a game with player1 policy

#gs = CantStop.game_state(1) #Initialising a one player game
#CantStop.simulate_game!(gs,[policy1], 5) # the third argument is a verbosity level

#Simulating 1000 games with policy1

N=20000

nb_turns, winner = test_policy([policy1],N)
println("stratégie pour 1 joueur termine en ",sum(nb_turns)/N," tours")

#2 players
"""
gs = game_state(2)
simulate_game!(gs,[policy1,policy2], 5)

N=1000
nb_turns, winner1 = test_policy([policy1,policy2],N) #la stratégie 1 commence
println("winner 1", winner1)

nb_turns, winner2 = test_policy([policy2,policy1],N) #la stratégie 2 commence
println("winner 2", winner2)
winner=zeros(2)
winner[1]=(winner1[1]+winner2[2])/(2. *N)
winner[2]=(winner1[2]+winner2[1])/(2. *N)

println("winners ", winner)


#Simulating a game with player1 and player 2 policy
#gs = game_state(2)
#simulate_game!(gs,[policy1,policy2], 5)

gs = game_state(2)
simulate_game!(gs,[policy1,policy2], 5)
"""