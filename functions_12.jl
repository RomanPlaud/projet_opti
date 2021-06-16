#=
functions:
- Julia version: 
- Author: cgris
- Date: 2021-04-30
=#
using DataStructures
include("CantStop.jl")

#QUESTION 2:

function poli_opti_q2(G_max,p,T::Int=100)
    K = 0

    #V=[[0 for i in 0:T+1] for j in 0:G_max+1]
    V = zeros(Float64,(T+1,G_max+1)::Tuple)
    V[end,:]=K*ones(Int,G_max+1)
    Q = zeros(Float64,(G_max+1,G_max)::Tuple)
    pi = -1*ones(Int,(T,G_max)::Tuple)

    for t in  T:-1:1
        for g in 1:G_max
            V[t,g]=Inf
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

function legal_move(dices::Vector{Int},i::Int)::Bool
    n = length(dices)
    for k in 1:n
        for j in 1:n
            if j!=k
                if dices[k]+dices[j]==i
                    return true
                end
            end
        end
    end
    return false
end

function proba(i::Int,j::Int,k::Int)
    p = 0
    for d1 in 1:6
        for d2 in 1:6
            for d3 in 1:6
                for d4 in 1:6
                    dices = [d1,d2,d3,d4]
                    if legal_move(dices,i) || legal_move(dices,j) || legal_move(dices,k)
                        p = p+1
                    end
                end
            end
        end
    end
    return p/(6^4)
end

#println(proba(2,3,12))
#Question 4:

function legal_move_ijk(l,i,j,k)
  a_1 = [l[4]+l[1],l[2]+l[3]]
  a_2 = [l[4]+l[2],l[1]+l[3]]
  a_3 = [l[4]+l[3],l[1]+l[2]]
  a_1 = [a for a in a_1 if (a==i || a==j || a==k)]
  a_2 = [a for a in a_2 if (a==i || a==j || a==k)]
  a_3 = [a for a in a_3 if (a==i || a==j || a==k)]
  moves = [a_1, a_2, a_3]
  return [move for move in moves if ( length(move)!=0)]
end

#println(legal_move_ijk([1,1,1,1],2,3,12))

function poli_opti_q4(i::Int,j::Int,k::Int,T::Int=30)
    p_lanc = 1/(6^4)
    g_i = 2*(7-abs(i-7))-1
    g_j = 2*(7-abs(j-7))-1
    g_k = 2*(7-abs(k-7))-1

    V = zeros((T+1,g_i+1,g_j+1,g_k+1,g_i+1,g_j+1,g_k+1))

    Q = zeros((g_i+1,g_j+1,g_k+1,g_i+1,g_j+1, g_k+1,2))
    pi = -1*ones((T,g_i+1,g_j+1,g_k+1,g_i+1, g_j+1, g_k+1))

    for t in T:-1:1
      println("t ", t)
      for i in g_i+1:-1:1
        println("i ", i)
        for j in g_j+1:-1:1
          for k in g_k+1:-1:1
            for d_i in g_i-i+1:-1:1
              for d_j in g_j-j+1:-1:1
                for d_k in g_k-k+1:-1:1
                  V[t,i,j,k,d_i,d_j,d_k]::Float64=Inf
                  for a in 1:2
                    Q[i,j,k,d_i,d_j,d_k,a]=0
                    if a==0
                      Q[i,j,k,d_i,d_j,d_k,a] = Q[i,j,k,d_i,d_j,d_k,a] + 1 + V[t+1, i+d_i, j+d_j, k+d_k, 1, 1, 1]
                    else
                      for dice1 in 1:6
                        for dice2 in 1:6
                          for dice3 in 1:6
                            for dice4 in 1:6
                              l = [dice1, dice2, dice3, dice4]
                              moves = legal_move_ijk(l, i, j, k)
                              if length(moves)==0
                                Q[i,j,k,d_i,d_j,d_k,a] = Q[i,j,k,d_i,d_j,d_k,a] + p_lanc*(1 + V[t+1, i, j, k, 1, 1, 1])
                              else
                                mini = Inf
                                best_move = []
                                for move in moves
                                  if length(move)==1
                                    v = V[t, i, j, k, minimum([g_i,d_i + (i==move[1])]) , minimum([g_j, d_j + (j==move[1])]),minimum([g_k, d_k + (k==move[1])])]
                                    if v<=mini
                                      mini = v
                                      best_move = move
                                    end
                                  else
                                    v = V[t, i, j, k, minimum([g_i, d_i + (i==move[1])+(i==move[2])]), minimum([g_j, d_j + (j==move[1])+(j==move[2])]), minimum([g_k, d_k + (k==move[1]) + (k==move[2])])]
                                    if v<=mini
                                      mini = v
                                      best_move = move
                                    end
                                  end
                                end
                                if length(best_move)==1
                                  Q[i,j,k,d_i,d_j,d_k,a] = Q[i,j,k,d_i,d_j,d_k,a] + p_lanc*(V[t, i, j, k, minimum([g_i, d_i + (i==best_move[1])]), minimum([g_j, d_j + (j==best_move[1])]), minimum([g_k, d_k + (k==best_move[1])])])
                                else
                                  Q[i,j,k,d_i,d_j,d_k,a] = Q[i, j, k, d_i, d_j, d_k, a] + p_lanc*(V[t, i, j, k, minimum([g_i, d_i + (i==best_move[1]) + (i==best_move[2])]), minimum([g_j, d_j + (j==best_move[1])+(j==best_move[2])]), minimum([g_k, d_k + (k==best_move[1])+(k==best_move[2])])])
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                    if Q[i, j, k, d_i, d_j, d_k, a]<V[t, i, j, k, d_i, d_j, d_k]
                      V[t, i, j, k, d_i, d_j, d_k]=Q[i, j, k, d_i, d_j, d_k, a]
                      pi[t, i, j, k, d_i, d_j, d_k] = a
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    return pi
end

function coeff(counter)::Float64
    if maximum(counter) == 4
      return 1
    elseif maximum(counter) == 3
      return 4
    elseif maximum(counter) == 2
      if minimum(counter)== 2
        return 6
      else
        return 12
      end
    else
        return 24
    end
end

function poli_opti_q4_opt(i::Int,j::Int,k::Int,x::Int,y::Int,z::Int,T::Int=30)
    println("entrer")
    p_lanc = 1/(6^4)
    g_i = 2*(7-abs(i-7))-1
    g_j = 2*(7-abs(j-7))-1
    g_k = 2*(7-abs(k-7))-1
    println("creation")
    V = zeros((T+1,g_i+1,g_j+1,g_k+1,g_i+1,g_j+1,g_k+1))
    print("... ")
    Q = zeros((g_i+1,g_j+1,g_k+1,g_i+1,g_j+1, g_k+1,2))
    print("... ")
    pi = -1*ones((T,g_i+1,g_j+1,g_k+1,g_i+1, g_j+1, g_k+1))
    println("end ")
    for t in T:-1:1
      println("t ", t)
      for i in g_i+1:-1:(x+1)
        println("i ", i)
        for j in g_j+1:-1:(y+1)
          for k in g_k+1:-1:(z+1)
            for d_i in g_i-i+1:-1:1
              for d_j in g_j-j+1:-1:1
                for d_k in g_k-k+1:-1:1
                  V[t,i,j,k,d_i,d_j,d_k]::Float64=Inf
                  for a in 1:2
                    Q[i,j,k,d_i,d_j,d_k,a]=0
                    if a==0
                      Q[i,j,k,d_i,d_j,d_k,a] = Q[i,j,k,d_i,d_j,d_k,a] + 1 + V[t+1, i+d_i, j+d_j, k+d_k, 1, 1, 1]
                    else
                      for dice1 in 1:6
                        for dice2 in dice1:6
                          for dice3 in dice2:6
                            for dice4 in dice3:6
                              l = [dice1, dice2, dice3, dice4]
                              c = counter(l)
                              A = [c[i] for i in 1:6 if c[i]>0]
                              p_lanc = coeff(A)*1/6^4
                              moves = legal_move_ijk(l, i, j, k)
                              if length(moves)==0
                                Q[i,j,k,d_i,d_j,d_k,a] = Q[i,j,k,d_i,d_j,d_k,a] + p_lanc*(1 + V[t+1, i, j, k, 1, 1, 1])
                              else
                                mini = Inf
                                best_move = []
                                for move in moves
                                  if length(move)==1
                                    v = V[t, i, j, k, minimum([g_i,d_i + (i==move[1])]) , minimum([g_j, d_j + (j==move[1])]),minimum([g_k, d_k + (k==move[1])])]
                                    if v<=mini
                                      mini = v
                                      best_move = move
                                    end
                                  else
                                    v = V[t, i, j, k, minimum([g_i, d_i + (i==move[1])+(i==move[2])]), minimum([g_j, d_j + (j==move[1])+(j==move[2])]), minimum([g_k, d_k + (k==move[1]) + (k==move[2])])]
                                    if v<=mini
                                      mini = v
                                      best_move = move
                                    end
                                  end
                                end
                                if length(best_move)==1
                                  Q[i,j,k,d_i,d_j,d_k,a] = Q[i,j,k,d_i,d_j,d_k,a] + p_lanc*(V[t, i, j, k, minimum([g_i, d_i + (i==best_move[1])]), minimum([g_j, d_j + (j==best_move[1])]), minimum([g_k, d_k + (k==best_move[1])])])
                                else
                                  Q[i,j,k,d_i,d_j,d_k,a] = Q[i, j, k, d_i, d_j, d_k, a] + p_lanc*(V[t, i, j, k, minimum([g_i, d_i + (i==best_move[1]) + (i==best_move[2])]), minimum([g_j, d_j + (j==best_move[1])+(j==best_move[2])]), minimum([g_k, d_k + (k==best_move[1])+(k==best_move[2])])])
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                    if Q[i, j, k, d_i, d_j, d_k, a]<V[t, i, j, k, d_i, d_j, d_k]
                      V[t, i, j, k, d_i, d_j, d_k]=Q[i, j, k, d_i, d_j, d_k, a]
                      pi[t, i, j, k, d_i, d_j, d_k] = a
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    return pi
end
#println("hello")
@time pi = poli_opti_q4_opt(3,4,5,1,1,2,20)


#print(test())