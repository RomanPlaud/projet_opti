#=
main:
- Julia version:
- Author: cgris
- Date: 2021-04-29
=#

#QUESTION

include("Projet.jl")



function questions()

    G_max = 200
    T = 10
    K = 0
    p = 0.9

    #V=[[0 for i in 0:T+1] for j in 0:G_max+1]
    V = zeros(Float64,(T+1,G_max+1)::Tuple)
    V[end,:]=K*ones(Int,G_max+1)
    Q = zeros(Float64,(G_max+1,G_max)::Tuple)
    pi = -1*ones(Float64,T)

    for t in  T:-1:1
        for g in 1:G_max+1
            V[t,g]=10^(5)
            for a in 1:(G_max-g+1)
                Q[g,a]=1+(p^a)*V[t+1,g+a]+(1-p^a)*V[t+1,g]
                if Q[g,a]<V[t,g]
                    V[t,g]= Q[g,a]
                    pi[t]=a
                end
            end
        end
    end

    print("politique optimale pour atteindre ")
    print(G_max)
    print("en maximum ")
    print(T)
    print(" tours : ")
    println(pi)

    println(simul(pi,p,G_max))
end

questions()

function test()
    L= [i for i in 1:10]
    print(L[1])
end

#test()