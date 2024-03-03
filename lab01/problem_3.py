import numpy as np
import matplotlib.pyplot as plt
import scipy.io

data = scipy.io.loadmat('adsl_x.mat')
x = np.array(data['x'])

prefix_len = 32  
frame_len = 512 
package_len = prefix_len + frame_len 

x = np.squeeze(x)
corr_of_x = []
for i in range(0, len(x) - package_len):
    corr = np.correlate(x[i:i+prefix_len], x)
    corr_of_x.append(corr.mean())

    

plt.plot(corr_of_x)
plt.xlabel('Numer bloku')
plt.ylabel('Wartość korelacji')
plt.grid(True)
plt.show()

