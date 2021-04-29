#=
Projet:
- Julia version: 
- Author: cgris
- Date: 2021-04-29
=#

using StatsBase

function simul(pi,p,G_max)
    gain = 0
    n = length(pi)
    for i in 1:n
        if gain>= G_max
            println("min(n)",i)
        end
        l=pi[i]
        tirage=[1.0-rand() for i in 1:l]
        if length(tirage[tirage<p])==l
            gain=gain+l
        end
    end
    return gain
end

