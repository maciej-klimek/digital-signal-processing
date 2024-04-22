import numpy as np
import scipy.io as sio
import scipy.signal as signal
import matplotlib.pyplot as plt

# Wczytanie danych z pliku .mat
data = sio.loadmat('lab08_am.mat')

# Wybierz numer realizacji sygnału zależny od przedostatniej cyfry w twojej legitymacji studenckiej
realizacja = 3  # Przykładowy numer realizacji sygnału

# Pobranie sygnału z wybranej realizacji
x = data["s{}".format(realizacja)][0]

# Długość sygnału
N = len(x)

# Założenie domyślnej częstotliwości próbkowania
fs = 1000  # Hz

# Czas trwania
t = np.arange(N) / fs

# Parametry filtru Hilberta
fc = 10  # Częstotliwość odcięcia filtru Hilberta

# Projektowanie filtru FIR jako przybliżenia filtru Hilberta
nyquist = 0.5 * fs
taps = 1001  # Długość odpowiedzi impulsowej filtra FIR
taps_half = taps // 2
taps_odd = taps % 2 == 1
h = signal.firwin(taps, fc / nyquist, window=('kaiser', 14), pass_zero=False)

# Filtracja sygnału x filtrem Hilberta
x_hilbert = signal.convolve(x, h, mode='same')

# Przesunięcie fazowe o -π/2 radianów
if taps_odd:
    x_hilbert = np.roll(x_hilbert, -taps_half)
else:
    x_hilbert = np.roll(x_hilbert, -taps_half - 1)

# Obliczenie obwiedni
envelope = np.abs(x + 1j * x_hilbert)

# Analiza częstotliwościowa obwiedni
fft_envelope = np.abs(np.fft.fft(envelope))
frequencies = np.fft.fftfreq(N, 1 / fs)

# Znalezienie indeksów dodatnich częstotliwości w widmie obwiedni
positive_freq_indices = np.where(frequencies > 0)[0]

# Znalezienie maksymalnej dodatniej częstotliwości w widmie obwiedni
max_positive_freq_index = np.argmax(fft_envelope[positive_freq_indices])
max_positive_freq = frequencies[positive_freq_indices][max_positive_freq_index]

# Określenie parametrów m(t) na podstawie maksymalnej częstotliwości
A1 = np.max(envelope)  # Amplituda stałej składowej
A2 = np.max(envelope) / 2  # Amplituda składowej o częstotliwości max_positive_freq / 2
A3 = np.max(envelope) / 2  # Amplituda składowej o częstotliwości max_positive_freq / 3
f1 = max_positive_freq / 2  # Częstotliwość składowej o częstotliwości max_positive_freq / 2
f2 = max_positive_freq / 3  # Częstotliwość składowej o częstotliwości max_positive_freq / 3
f3 = max_positive_freq / 4  # Częstotliwość składowej o częstotliwości max_positive_freq / 4

# Wyświetlenie wyników
print("A1:", A1)
print("A2:", A2)
print("A3:", A3)
print("f1:", f1)
print("f2:", f2)
print("f3:", f3)

# Wyświetlenie sygnału oraz jego obwiedni
plt.figure(figsize=(10, 6))
plt.plot(t, x, label='Sygnał x')
plt.plot(t, envelope, 'ro', label='Obwiednia')
plt.title('Obwiednia sygnału x')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.legend()
plt.grid(True)
plt.show()

# Wykres widma częstotliwościowego obwiedni
plt.figure(figsize=(10, 6))
plt.plot(frequencies[:N // 2], fft_envelope[:N // 2])
plt.title('Widmo częstotliwościowe obwiedni')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda')
plt.grid(True)
plt.show()
