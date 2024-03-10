import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

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

def get_DFT(size):
    k = np.arange(size)
    n = np.arange(size)
    W_N = np.exp(1j * 2 * np.pi / size)  # W_N = e^(-j*2*pi/N)
    result = (1 / np.sqrt(size)) * np.power(W_N, np.outer(-k, n))
    return result

A = get_DFT(N)
X = np.dot(A, x)
print(X)

# Wyświetlenie wyników
freq = np.fft.fftfreq(N, 1/fs)  # osie częstotliwości
plt.figure(figsize=(10, 8))

# Część rzeczywista
plt.subplot(2, 2, 1)
plt.plot(freq, np.real(X))
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Część rzeczywista')
plt.title('Część rzeczywista widma')

# Część urojona
plt.subplot(2, 2, 2)
plt.plot(freq, np.imag(X))
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Część urojona')
plt.title('Część urojona widma')

# Moduł
plt.subplot(2, 2, 3)
plt.plot(freq, np.abs(X))
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Moduł widma')

# Faza
plt.subplot(2, 2, 4)
plt.plot(freq, np.unwrap(np.angle(X)))  # dodanie unwrapplt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Faza')
plt.title('Faza widma')

plt.tight_layout()
plt.show()

fig = plt.figure(figsize=(10, 6))
ax = fig.add_subplot(111, projection='3d')

ax.plot(freq, np.real(X), np.imag(X))
ax.set_xlabel('Częstotliwość [Hz]')
ax.set_ylabel('Część rzeczywista')
ax.set_zlabel('Część urojona')
ax.set_title('Widmo w przestrzeni 3D')

plt.show()

# Rekonstrukcja sygnału
B = np.conj(A.T)  # macierz rekonstrukcji
xr = np.dot(B, X)  # rekonstrukcja sygnału

# Porównanie oryginału z zrekonstruowanym sygnałem
print("Czy sygnał x i zrekonstruowany sygnał xr są takie same?")
print(np.allclose(x, xr))

# Zmiana częstotliwości f1 na 125 Hz
f1 = 125  # nowa częstotliwość pierwszej składowej [Hz]
x = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

# Obliczenie DFT dla zmienionego sygnału
X = np.fft.fft(x)

# Wyświetlenie widma
freq = np.fft.fftfreq(N, 1/fs)  # osie częstotliwości
plt.figure(figsize=(10, 4))
plt.plot(freq, np.abs(X))
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Moduł')
plt.title('Moduł widma dla zmienionej częstotliwości f1=125 Hz')
plt.grid(True)
plt.show()