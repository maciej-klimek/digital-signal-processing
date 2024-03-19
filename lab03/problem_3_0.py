import numpy as np
import matplotlib.pyplot as plt
from scipy.signal.windows import chebwin

# Definicja stałych
N = 100  # liczba próbek
fs = 1000  # częstotliwość próbkowania [Hz]

f = np.arange(0, 500.1, 0.1)  # osie częstotliwości dla DtFT
f1 = 100  # częstotliwość pierwszej składowej [Hz]
f2 = 125  # częstotliwość drugiej składowej [Hz]
# f2 = 250  # częstotliwość drugiej składowej [Hz]
A1 = 1  # amplituda pierwszej składowej
A2 = 0.0001  # amplituda drugiej składowej
# A2 = 0.5  # zwiększona amplituda drugiej składowej

# Generowanie sygnału x(t)
t = np.arange(N) / fs  # wektor czasu
x = A1 * np.cos(2 * np.pi * f1 * t) + A2 * np.cos(2 * np.pi * f2 * t)

# Obliczenie DtFT
X = np.zeros_like(f, dtype=complex)
for i, freq in enumerate(f):
    X[i] = np.sum(x * np.exp(-1j * 2 * np.pi * freq * t))

# Wyświetlenie widma przed zastosowaniem okien
plt.figure(figsize=(10, 6))
plt.plot(f, np.abs(X))
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Widmo sygnału przed zastosowaniem okien')
plt.grid(True)

# Okno czasowe – funkcja opisująca sposób pobierania próbek z sygnału. -> https://pl.wikipedia.org/wiki/Okno_czasowe
windows = ['Prostokątne', 'Hamminga', 'Blackmana', 'Czebyszewa (100 dB)', 'Czebyszewa (120 dB)']
ripple_values = [None, None, None, 100, 120]  # Wartości tłumienia dla okna Czebyszewa

plt.figure(figsize=(10, 6))

for window, ripple in zip(windows, ripple_values):
    if window == 'Prostokątne':
        window_func = np.ones(N)
    elif window == 'Hamminga':
        window_func = np.hamming(N)
    elif window == 'Blackmana':
        window_func = np.blackman(N)
    else:
        window_func = chebwin(N, at=ripple)
    x_windowed = x * window_func
    X_windowed = np.zeros_like(f, dtype=complex)
    for i, freq in enumerate(f):
        X_windowed[i] = np.sum(x_windowed * np.exp(-1j * 2 * np.pi * freq * t))
    plt.plot(f, np.abs(X_windowed), label=window)

plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Widma sygnału po zastosowaniu różnych okien')
plt.legend()
plt.grid(True)
plt.show()
