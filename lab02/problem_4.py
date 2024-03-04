import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile

fs, x = wavfile.read('mowa.wav')

# Wyświetlenie całego pliku
plt.figure(figsize=(12, 6))
plt.plot(np.arange(len(x)) / fs, x)
plt.title('Cały plik dźwiękowy')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.grid(True)
plt.show()

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

# Wczytanie sygnału dźwiękowego
fs, x = wavfile.read('mowa.wav')

# Parametry analizy
M = 10
N = 256
A = generate_DCT(N)

# Wybór M różnych fragmentów
fragments = []
for k in range(M):
    n1 = np.random.randint(0, len(x) - N)
    n2 = n1 + N
    fragments.append(x[n1:n2])

# Analiza każdego fragmentu
results = []
for fragment in fragments:
    y_k = np.dot(A, fragment)
    results.append(y_k)

# Wyświetlenie fragmentów i wyników analizy
plt.figure(figsize=(12, 8))
for i in range(M):
    plt.subplot(M, 2, 2*i+1)
    plt.plot(fragments[i])
    plt.title(f'Fragment {i+1}')
    plt.xlabel('Numer próbki')
    plt.ylabel('Amplituda')

    plt.subplot(M, 2, 2*i+2)
    freqs = np.fft.fftfreq(N, 1/fs)
    plt.plot(freqs, np.abs(np.fft.fft(results[i])))
    plt.title(f'Analiza {i+1}')
    plt.xlabel('Częstotliwość [Hz]')
    plt.ylabel('Amplituda')
plt.tight_layout()
plt.show()
