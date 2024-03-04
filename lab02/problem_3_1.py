import numpy as np
import matplotlib.pyplot as plt

plt.ion()  
fig, axs = plt.subplots(2, 1, figsize=(10, 8))  
ax1, ax2 = axs[0], axs[1] 
ax1.set_title('Wartości wierszy macierzy A (DCT)')
ax1.set_xlabel('Indeks')
ax1.set_ylabel('Wartość')
ax2.set_title('Wartości kolumn macierzy S (IDCT)')
ax2.set_xlabel('Indeks')
ax2.set_ylabel('Wartość')


N = 100  # rozmiar macierzy
fs = 1000  

def generate_DCT(N):
    s = np.sqrt(1/N)
    A = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                A[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))
            else:
                A[k, n] = np.sqrt(2/N) * np.cos(np.pi * k / N * (n + 0.5))
    return A

def generate_IDCT(N):
    s = np.sqrt(1/N)
    A = generate_DCT(N)
    S = A.T  # transpozycja
    return S

A = generate_DCT(N)
S = generate_IDCT(N)

print(A)
print(S)


for i in range(N):
    # wartości wiersza macierzy DCT
    ax1.plot(A[i], label=f'Wiersz {i+1}', color='blue')
    ax1.legend(loc='upper right')
    
    # wartości kolumny macierzy IDCT
    ax2.plot(S[:, i], label=f'Kolumna {i+1}', color='orange')
    ax2.legend(loc='upper right')

    plt.draw()  
    plt.waitforbuttonpress()  


plt.ioff() 
plt.show()  
