import numpy as np
import matplotlib.pyplot as plt

# Zadanie 1

# Definicja stałych
N = 100  # liczba próbek
fs = 1000  # częstotliwość próbkowania [Hz]

f1 = 100  # częstotliwość pierwszej składowej [Hz]
A1 = 100  # amplituda pierwszej składowej
phi1 = np.pi / 7  # kąt fazowy pierwszej składowej

f2 = 200  # częstotliwość drugiej składowej [Hz]
A2 = 200  # amplituda drugiej składowej
phi2 = np.pi / 11  # kąt fazowy drugiej składowej

# Generowanie sygnału x(t)
t = np.arange(N) / fs  # wektor czasu
x = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

# Obliczenie DFT
X = np.fft.fft(x)

# Zadanie 2

def calculate_extended_DtFT(x, t, f_extended):
    X3_extended = np.zeros_like(f_extended, dtype=complex)
    for i, freq in enumerate(f_extended):
        X3_extended[i] = np.sum(x * np.exp(-1j * 2 * np.pi * freq * t))
    return X3_extended

# Parametry
M = 100  # liczba zer do dołączenia na końcu sygnału
fz = np.fft.fftfreq(N + M, 1 / fs)  # osie częstotliwości dla sygnału z dodanymi zerami
xz = np.concatenate((x, np.zeros(M)))  # sygnał z dodanymi zerami
X2 = np.fft.fft(xz) / (N + M)  # FFT dla sygnału z dodanymi zerami
fx2 = fs * np.arange(N + M) / (N + M)  # wektor częstotliwości dla X2

# Obliczenie DtFT
f = np.arange(0, 1000.25, 0.25)  # osie częstotliwości dla DtFT
X3 = calculate_extended_DtFT(x, t, f)


# Rysowanie wykresów
plt.figure(figsize=(10, 6))
plt.plot(fs * np.arange(N) / N, np.abs(X), '-o', label='$X_1$ (DFT)')
plt.plot(fx2, np.abs(X2), 'b-x', label='$X_2$ (FFT z dodanymi zerami)')
plt.plot(f, np.abs(X3), 'k-', label='$X_3$ (DtFT)')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Porównanie widm')
plt.legend()
plt.grid(True)
plt.show()

# Obliczenie i rysowanie wykresów dla szerszego zakresu częstotliwości
f_extended = np.arange(-2000, 2000.25, 0.25)  # rozszerzony zakres częstotliwości
X3_extended = calculate_extended_DtFT(x, t, f_extended)

plt.figure(figsize=(10, 6))
plt.plot(fs * np.arange(N) / N, np.abs(X), '-o', label='$X_1$ (DFT)')
plt.plot(fx2, np.abs(X2), 'b-x', label='$X_2$ (FFT z dodanymi zerami)')
plt.plot(f_extended, np.abs(X3_extended), 'k-', label='$X_3$ (DtFT)')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Porównanie widm (rozszerzony zakres)')
plt.legend()
plt.grid(True)
plt.xlim(0, fs / 2)
plt.show()
