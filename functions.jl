#=
functions:
- Julia version: 
- Author: cgris
- Date: 2021-04-30
=#

include("CantStop.jl'")

#QUESTION 2:

function poli_opti_q2(G_max::Int,p::Float64,T::Int)
    K = 0

    #V=[[0 for i in 0:T+1] for j in 0:G_max+1]
    V = zeros(Float64,(T+1,G_max+1)::Tuple)
    V[end,:]=K*ones(Int,G_max+1)
    Q = zeros(Float64,(G_max+1,G_max)::Tuple)
    pi = -1*ones(Float64,(T,G_max)::Tuple)

    for t in  T:-1:1
        for g in 1:G_max+1
            V[t,g]=10^(5)
            for a in 1:(G_max-g+1)
                Q[g,a]=1+(p^a)*V[t+1,g+a]+(1-p^a)*V[t+1,g]
                if Q[g,a]<V[t,g]
                    V[t,g]= Q[g,a]
                    pi[t,g]=a
                end
            end
        end
    end

    return pi

end

#QUESTION 3:

function legal_move(dices,i)
    n = length(dices)
    for k in 1:n
        for j in 1:n
            if dices[k]+dices[j]==i
                return true
            end
        end
    end
    return false
end

function proba(i,j,k)
    occ=0
    for i in 1:10^5
        dices = rand(1:6,4)
        #print(dices)
        if legal_move(dices,i) || legal_move(dices,j) || legal_move(dices,k)
            occ+=1
        end
    end
    return occ/10^5
end

function check(adm_move,i::Int,j::Int,k::Int)
    for paire in adm_move
        if paire[1]==i || paire[1]==j
        end
    end
end

function proba_b(i,j,k):
    occ=0
    for i in I:10^5
        adm_mov = throw()
        if
    end
end
print(proba(2,7,12))

function test()
    L= [i for i in 1:10]
    print(L[1])
end