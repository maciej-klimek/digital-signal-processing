import scipy.io as sio
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

# Wczytanie danych z pliku .mat
data = sio.loadmat('lab08_am.mat')

# Wybierz numer realizacji sygnału zależny od przedostatniej cyfry w twojej legitymacji studenckiej
data_number = 3  # Przykładowy numer realizacji sygnału

# Pobranie sygnału z wybranej realizacji
x = data["s{}".format(data_number)][0]

sampling_frequency = 1000
carrier_frequency = 200
filter_lenght = 64
N = 2 * filter_lenght + 1
coeffs_index = np.arange(1, filter_lenght + 1)
coeffs = (2 / np.pi) * (np.sin(np.pi * coeffs_index / 2) ** 2 / coeffs_index)
coeffs = np.concatenate((-coeffs[::-1], [0], coeffs))

# Wymnożenie przez okno Blackmana
blackman_window = signal.windows.blackman(N)
windowed_coeffs = coeffs * blackman_window

# Filtracja
y = np.convolve(x, windowed_coeffs, mode='valid')
f_x = x[filter_lenght: -filter_lenght]
envelope = np.sqrt(f_x ** 2 + y ** 2)

fft_envelope = np.fft.fft(envelope)

# Znormalizowanie amplitud w widmie
fft_envelope_norm = np.abs(fft_envelope) * 2 / np.max(np.abs(fft_envelope))


# Wyświetlenie FFT sygnału obwiedni
plt.figure()
plt.plot(np.abs(fft_envelope_norm))
plt.title('FFT obwiedni')
plt.xlabel('Indeks częstotliwości')
plt.ylabel('Znormalizowana amplituda')
plt.grid()

# Parametry sygnału modulującego
f1 = 3
f2 = 10
f3 = 60
A1 = 0.6
A2 = 0.1
A3 = 0.20

# Sygnał modulujący
t = np.linspace(0, 1, sampling_frequency, endpoint=False)
x_reconstructed = 1 + A1 * np.cos(2 * np.pi * f1 * t) + A2 * np.cos(2 * np.pi * f2 * t) + A3 * np.cos(2 * np.pi * f3 * t)
x_reconstructed = x_reconstructed[filter_lenght: -filter_lenght]



# Wyświetlenie porównania sygnałów
plt.figure()
plt.plot(envelope, 'c', linewidth=2)  # Zmiana grubości linii na 1.5
plt.plot(x_reconstructed, 'k', linewidth=1)  # Zmiana grubości linii na 1.5
plt.title('Porównanie sygnałów')
plt.legend(['FIR - hilbert', 'odtworzone suma cos'])

# Sygnał z pliku zmodulowany vs. sygnał skonstruowany zmodulowany
x_modulated = np.sin(2 * np.pi * carrier_frequency * t)
x_modulated = x_modulated[filter_lenght: -filter_lenght]
y_reconstructed = x_modulated * x_reconstructed

plt.figure()
plt.plot(y, 'b', linewidth=5)  # Zmiana grubości linii na 1.5
plt.plot(y_reconstructed, 'r', linewidth=2)  # Zmiana grubości linii na 1.5
plt.legend(['Sygnał skonstruowany i zmod.', 'Sygnał zmod. z pliku'])
plt.show()