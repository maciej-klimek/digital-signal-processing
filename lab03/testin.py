import numpy as np
import matplotlib.pyplot as plt

# Parametry sygnału
A1 = 100
f1 = 100
phi1 = np.pi / 7
A2 = 200
f2 = 200
phi2 = np.pi / 11
fs = 1000  # częstotliwość próbkowania
N = 100    # liczba próbek

def DFT_matrix(N):
    i, j = np.meshgrid(np.arange(N), np.arange(N))
    omega = np.exp( - 2 * np.pi * 1J / N )
    W = np.power( omega, i * j ) / np.sqrt(N)
    return W
A=DFT_matrix(N)

# Tworzenie wektora czasu
t = np.arange(N) / fs

# Obliczanie sygnału x(t)
x_t = x_t = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

# Obliczanie DFT sygnału x(t)
X = np.dot(A, x_t)
# Wyliczanie widma
freq= np.arange(N)* fs/N
real_part = np.real(X)
imaginary_part = np.imag(X)
magnitude = np.abs(X)
phase = np.angle(X)

# Narysowanie widma
plt.figure(figsize=(12, 10))

plt.subplot(2, 2, 1)
plt.plot(freq, real_part, color='blue')
plt.title('Część rzeczywista')
plt.xlabel('Częstotliwość [Hz]')
plt.grid()

plt.subplot(2, 2, 2)
plt.plot(freq, imaginary_part, color='red')
plt.title('Część urojona')
plt.xlabel('Częstotliwość [Hz]')
plt.grid()

plt.subplot(2, 2, 3)
plt.plot(freq, magnitude, color='purple')
plt.title('Moduł')
plt.xlabel('Częstotliwość [Hz]')
plt.grid()

plt.subplot(2, 2, 4)
plt.phase_spectrum(t, X, color='green')
plt.title('Faza')
plt.xlabel('Częstotliwość [Hz]')
plt.grid()

plt.tight_layout()


# Wyznaczanie macierzy rekonstrukcji B
B = np.conj(A).T
xr=np.dot(B, X)
# Rekonstrukcja sygnału na podstawie X
# Wizualizacja porównania sygnałów
plt.figure(figsize=(10, 6))
plt.plot(t, x_t, label='Oryginalny sygnał x(t)', linestyle='-', color='blue')
plt.plot(t, xr, label='Zrekonstruowany sygnał xr(t)', linestyle='--', color='red')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.title('Porównanie oryginalnego sygnału z zrekonstruowanym używając macierzy rekonstukcji')
plt.legend()
plt.grid()



X=np.fft.fft(x_t)
xr=np.fft.ifft(X)
# Rekonstrukcja sygnału na podstawie X
# Wizualizacja porównania sygnałów
plt.figure(figsize=(10, 6))
plt.plot(t, x_t, label='Oryginalny sygnał x(t)', linestyle='-', color='blue')
plt.plot(t, xr, label='Zrekonstruowany sygnał xr(t)', linestyle='--', color='red')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.title('Porównanie oryginalnego sygnału z zrekonstruowanym używając FFT')
plt.legend()
plt.grid()


plt.show()