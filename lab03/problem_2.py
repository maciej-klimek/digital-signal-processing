import numpy as np
import matplotlib.pyplot as plt

N = 100  # liczba próbek
fs = 1000  # częstotliwość próbkowania [Hz]

f1 = 125  # częstotliwość pierwszej składowej [Hz]
A1 = 100  # amplituda pierwszej składowej
phi1 = np.pi / 7  # kąt fazowy pierwszej składowej

f2 = 200  # częstotliwość drugiej składowej [Hz]
A2 = 200  # amplituda drugiej składowej
phi2 = np.pi / 11  # kąt fazowy drugiej składowej

# Generowanie sygnału x(t)
t = np.arange(N) / fs  # wektor czasu
x = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

# Dodanie M zer na końcu sygnału
M = 100
xz = np.concatenate((x, np.zeros(M)))

# Obliczenie X1
X1 = np.fft.fft(x) / N

# Obliczenie X2
X2 = np.fft.fft(xz) / (N + M)

# Obliczenie X3
f = np.arange(0, 1001, 0.25)  # wektor częstotliwości
X3 = np.zeros(len(f), dtype=np.complex128)
for i, freq in enumerate(f):
    X3[i] = 1/N * np.sum(x * np.exp(-1j * 2 * np.pi * freq / fs * np.arange(N)))

# Przeskalowanie widm
X1 = np.abs(X1)
X2 = np.abs(X2)
X3 = np.abs(X3)

# Wektory częstotliwości
fx1 = fs * np.arange(N) / N
fx2 = fs * np.arange(N + M) / (N + M)
fx3 = f

# Rysowanie widm
plt.figure(figsize=(10, 6))
plt.plot(fx1, X1, 'o-', label='$X_1$ (DFT o długości N)')
plt.plot(fx2, X2, 'r-x', label='$X_2$ (DFT z dodaniem zer)')
plt.plot(fx3, X3, 'k-', label='$X_3$ (DtFT)')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda')
plt.title('Porównanie trzech widm')
plt.legend()
plt.grid(True)
plt.show()


# Rysowanie widm
X2 = np.fft.fft(xz) / N
X2 = np.abs(X2)

plt.figure(figsize=(10, 6))
plt.plot(fx2, X2, 'r-x', label='$X_2$ (DFT z dodaniem zer)')
plt.plot(fx1, X1, 'o-', label='$X_1$ (DFT o długości N)')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda')
plt.title('Porównanie trzech widm')
plt.legend()
plt.grid(True)
plt.show()

# Obliczenie X3 dla szerszego zakresu częstotliwości
f_extended = np.arange(-2000, 2000.25, 0.25)
X3_extended = np.zeros(len(f_extended), dtype=np.complex128)
for i, freq in enumerate(f_extended):
    X3_extended[i] = 1/N * np.sum(x * np.exp(-1j * 2 * np.pi * freq / fs * np.arange(N)))

# Przeskalowanie X3 dla szerszego zakresu
X3_extended = np.abs(X3_extended)

# Wektory częstotliwości dla szerszego zakresu
fx3_extended = f_extended

# Rysowanie widm dla szerszego zakresu
plt.figure(figsize=(10, 6))
plt.plot(fx1, X1, 'o', label='$X_1$ (DFT o długości N)')
plt.plot(fx2, X2, 'r-x', label='$X_2$ (DFT z dodaniem zer)')
plt.plot(fx3_extended, X3_extended, 'k-', label='$X_3$ (DtFT) dla szerszego zakresu')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda')
plt.title('Porównanie trzech widm (szerszy zakres częstotliwości)')
plt.legend()
plt.grid(True)
plt.show()
