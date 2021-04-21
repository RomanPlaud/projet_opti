#=
test_opti:
- Julia version: 
- Author: 33642
- Date: 2021-04-21
=#
#question 1

G_max = 200
T = 10
K=1
p=0.9
V = np.zeros((T+1,G_max+1))
V[-1,:]= K*np.ones(G_max+1)
#V[-1,:]= np.array([G_max-i for i in range(G_max+1)])
Q = np.zeros((G_max+1,G_max+1))
pi = -1*np.ones(T)

for t in range(T-1,-1,-1):
  for g in range(G_max+1):
    V[t,g]=10**5
    for a in range(1,G_max-g+1):
      Q[g,a]= 1+ (p**a)*V[t+1,g+a] +(1-p**a)*V[t+1,g]
      if Q[g,a]<V[t,g]:
        V[t,g]= Q[g,a]
        pi[t]=a
