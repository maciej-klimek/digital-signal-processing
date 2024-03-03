import numpy as np
import matplotlib.pyplot as plt

# Ustawienia wykresu
plt.ion()  # Włączenie interaktywnego trybu wykresu
fig, axs = plt.subplots(2, 1, figsize=(10, 8))  # Tworzenie subplotów
ax1, ax2 = axs[0], axs[1]  # Podział subplotów
ax1.set_title('Wartości wierszy macierzy A (DCT)')
ax1.set_xlabel('Indeks')
ax1.set_ylabel('Wartość')
ax2.set_title('Wartości kolumn macierzy S (IDCT)')
ax2.set_xlabel('Indeks')
ax2.set_ylabel('Wartość')

# Parametry sygnału
N = 100  # Liczba próbek sygnału
fs = 1000  # Częstotliwość próbkowania (Hz)
t = np.arange(N) / fs  # Wektor czasu

# Generowanie macierzy A (DCT) i S (IDCT)
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
    S = A.T  # Transpozycja macierzy DCT
    return S

A = generate_DCT(N)
S = generate_IDCT(N)
print(A[0])
print(S[0])

print(A[1])
print(S[1])

# Wyświetlanie wartości wierszy macierzy A i kolumn macierzy S w pętli
for i in range(N):
    # Wartości wiersza macierzy A (DCT)
    ax1.plot(A[i], label=f'Wiersz {i+1}', color='blue')
    ax1.legend(loc='upper right')
    
    # Wartości kolumny macierzy S (IDCT)
    ax2.plot(S[:, i], label=f'Kolumna {i+1}', color='orange')
    ax2.legend(loc='upper right')

    plt.draw()  # Rysowanie wykresu
    plt.waitforbuttonpress()  # Oczekiwanie na naciśnięcie przycisku myszy lub klawisza klawiatury


plt.ioff()  # Wyłączenie interaktywnego trybu wykresu
plt.show()  # Wyświetlenie wykresu
