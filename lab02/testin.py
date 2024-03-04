import numpy as np
import matplotlib.pyplot as plt

# Dane
N = 100    # liczba próbek
fs = 1000  # częstotliwość próbkowania
st = 1/fs  # krok próbkowania
T = 0.1    # czas trwania próbkowania (100 próbek dla 1000Hz = 0.1s)

sample = np.arange(st, T+st, st)  # przedział czasowy próbkowania

# Częstotliwości sinusoid
f1 = 50 
f2 = 100
f3 = 150

# Amplitudy sinusoid
A1 = 50
A2 = 100
A3 = 150

# Tworzenie sygnału z sumy sinusów
s1 = lambda t: A1 * np.sin(2*np.pi*f1*t)
s2 = lambda t: A2 * np.sin(2*np.pi*f2*t)
s3 = lambda t: A3 * np.sin(2*np.pi*f3*t)

# Sygnał x z sumy sinusów
x = s1(sample) + s2(sample) + s3(sample)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(sample, s1(sample), 'r-o', label='s1 50Hz')
plt.plot(sample, s2(sample), 'g-o', label='s2 100Hz')
plt.plot(sample, s3(sample), 'b-o', label='s3 150Hz')
plt.title('Trzy sinusy do sumowania')
plt.legend()

plt.subplot(2, 1, 2)
plt.plot(sample, x, 'r-o')
plt.title('Zsumowane sinusy')
plt.xlabel('Numer próbki')

# Budowanie macierzy A=DCT i S=IDCT dla 100 próbek
sk = np.sqrt(1/N)
A = np.zeros((N, N))

for k in range(N):
    for n in range(N):
        A[k, n] = sk * np.cos(np.pi * k / N * (n + 0.5))
    sk = np.sqrt(2/N)

S = np.linalg.inv(A)

# Analiza sygnału y=Ax
y = np.dot(A, x)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
f = np.arange(1, N+1) * fs / (2 * N)
plt.stem(f, y, 'b')
plt.title('Obserwacja współczynników')
plt.xlabel('Częstotliwość [Hz]')

plt.subplot(2, 1, 2)
plt.plot(sample, x, 'r-o')
plt.title('Sygnał sumy sinusów')
plt.xlabel('Numer próbki')

# Rekonstrukcja sygnału
rcnst = np.dot(S, y)

# Sprawdzenie czy transformata posiada
# właściwość perfekcyjnej rekonstrukcji
tol = np.max(np.abs(x - rcnst))
print(f'Rekonstrukcja sygnału z błędem: {tol}')

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(sample, x, 'b')
plt.title('Sygnał sumy sinusów')

plt.subplot(2, 1, 2)
plt.plot(sample, rcnst, 'r')
plt.title('Rekonstrukcja sygnału sumy sinusów')

plt.show()

# Zmiana f2 na 105 Hz
f2 = 105
s2 = lambda t: A2 * np.sin(2*np.pi*f2*t)
x = s1(sample) + s2(sample) + s3(sample)

# Analiza sygnału y=Ax
y = np.dot(A, x)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
f = np.arange(1, N+1) * fs / (2 * N)
plt.stem(f, y, 'b')
plt.title('Obserwacja współczynników, f2 + 5Hz')
plt.xlabel('Częstotliwość [Hz]')

plt.subplot(2, 1, 2)
plt.plot(sample, x, 'r-o')
plt.title('Sygnał sumy sinusów, f2 + 5Hz')
plt.xlabel('Numer próbki')

# Rekonstrukcja sygnału
rcnst = np.dot(S, y)

# Sprawdzenie czy transformata posiada
# właściwość perfekcyjnej rekonstrukcji
tol = np.max(np.abs(x - rcnst))
print(f'Rekonstrukcja sygnału z błędem: {tol}')

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(sample, x, 'b')
plt.title('Sygnał sumy sinusów')

plt.subplot(2, 1, 2)
plt.plot(sample, rcnst, 'r-')
plt.title('Rekonstrukcja sygnału sumy sinusów')

plt.show()

# Zmiana częstotliwości o 2.5 Hz
f1 = 52.5 
f2 = 102.5
f3 = 152.5

# Tworzenie sygnału z sumy sinusów
s1 = lambda t: A1 * np.sin(2*np.pi*f1*t)
s2 = lambda t: A2 * np.sin(2*np.pi*f2*t)
s3 = lambda t: A3 * np.sin(2*np.pi*f3*t)

# Sygnał x z sumy sinusów
x = s1(sample) + s2(sample) + s3(sample)

# Analiza sygnału y=Ax
y = np.dot(A, x)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
f = np.arange(1, N+1) * fs / (2 * N)
plt.stem(f, y, 'b')
plt.title('Obserwacja współczynników, f1, f2, f3 + 2.5 Hz')
plt.xlabel('Częstotliwość [Hz]')

plt.subplot(2, 1, 2)
plt.plot(sample, x, 'r-o')
plt.title('Sygnał sumy sinusów, f1, f2, f3 + 2.5 Hz')
plt.xlabel('Numer próbki')

# Rekonstrukcja sygnału
rcnst = np.dot(S, y)

# Sprawdzenie czy transformata posiada
# właściwość perfekcyjnej rekonstrukcji
tol = np.max(np.abs(x - rcnst))
print(f'Rekonstrukcja sygnału z błędem: {tol}')

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(sample, x, 'b')
plt.title('Sygnał sumy sinusów')

plt.subplot(2, 1, 2)
plt.plot(sample, rcnst, 'r')
plt.title('Rekonstrukcja sygnału sumy sinusów')

plt.show()