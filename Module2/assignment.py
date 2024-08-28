import numpy as np
import matplotlib.pyplot as plt


K = 0.6
max_r = 3

initial = 0.5
target_cycles = 100
max_days = 1000 # change based on conditions

rArray = np.linspace(0.1,2.99,1000)


bounded = True
x_final = np.zeros((1000,target_cycles))  
for inc in range(0, len(rArray)):
    r = rArray[inc]
    x = np.zeros(max_days)
    x[0] = initial

    for i in range(1, max_days):
        if bounded:
            x[i] = x[i-1] + r*(1-(x[i-1]/K))*x[i-1]


    x_final[inc,:] = x[-target_cycles:]








    
# THE MODEL ^
# ------------------------------------------
# THE BEHAVIOR / THE OUTPUT ? 


plt.figure(1)
plt.plot(rArray, x_final, '.')
plt.ylabel('Population')
plt.xlabel('r')
plt.show()