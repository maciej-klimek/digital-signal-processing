import numpy as np
import matplotlib.pyplot as plt
from scipy.signal.windows import chebwin

# Definicja stałych
N = 1000  # zmieniona liczba próbek
fs = 1000  # częstotliwość próbkowania [Hz]

f = np.arange(50.1, 150.1, 0.1)  # zmienione osie częstotliwości dla DtFT
f1 = 100  # częstotliwość pierwszej składowej [Hz]
f2 = 125  # częstotliwość drugiej składowej [Hz]
A1 = 1  # amplituda pierwszej składowej
A2 = 0.0001  # amplituda drugiej składowej

# Generowanie sygnału x(t)
t = np.arange(N) / fs  # wektor czasu
x = A1 * np.cos(2 * np.pi * f1 * t) + A2 * np.cos(2 * np.pi * f2 * t)

# Obliczenie DtFT
X = np.zeros_like(f, dtype=complex)
for i, freq in enumerate(f):
    X[i] = np.sum(x * np.exp(-1j * 2 * np.pi * freq * t))

# Wyświetlenie widma
plt.figure(figsize=(10, 6))
plt.plot(f, np.abs(X))
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Widmo sygnału przed zastosowaniem okien')
plt.grid(True)
plt.show()

# Okna
ripple_values = [100, 150, 200, 250, 300, 400, 500, 800]  # Wartości tłumienia dla okna Czebyszewa

plt.figure(figsize=(10, 6))

for ripple in ripple_values:
    window_func = chebwin(N, at=ripple)
    x_windowed = x * window_func
    X_windowed = np.zeros_like(f, dtype=complex)
    for i, freq in enumerate(f):
        X_windowed[i] = np.sum(x_windowed * np.exp(-1j * 2 * np.pi * freq * t))
    plt.plot(f, np.abs(X_windowed), label=f'Czebyszewa (tłumienie {ripple} dB)')

plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Widma sygnału po zastosowaniu różnych wartości tłumienia okna Czebyszewa')
plt.legend()
plt.grid(True)
plt.show()
