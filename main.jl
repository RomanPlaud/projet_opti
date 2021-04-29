#=
main:
- Julia version:
- Author: cgris
- Date: 2021-04-29
=#

#QUESTION

function main3()
    G_max = 200
    T = 10
    K = 1
    p = 0.9
    #V=[[0 for i in 0:T+1] for j in 0:G_max+1]
    V = zeros(Int8,(T+1,G_max+1)::Tuple)
    V[end,:]=K*ones(Int,G_max+1)
    Q = zeros(Int,(G_max+1,G_max+1)::Tuple)
    pi = -1*ones(Int,T)

    print([i for i in (T-1):-1])

    for t in (T-1):-1
        for g in 0:(G_max+1)
            V[t,g]=10^(5)
            for a in 1:(G_max-g+1)
                Q[g,a]=1+(p^a)*V[t+1,g+1]+(1-p^a)*V[t+1,g]
                if Q[g,a]<V[t,g]
                    V[t,g]= Q[g,a]
                    pi[t]=a

            end
        end
    end

end

main3()