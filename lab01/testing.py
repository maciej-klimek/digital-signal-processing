### Podpunkt C1 - sinus
import numpy as np
import matplotlib.pyplot as plt

def plot_sinusoids(frequencies, title, legend=True):
    fs = 100  # częstotliwość próbkowania
    t = np.arange(0, 1, 1/fs)  # os czasu dla 1 sekundy sygnału

    # Pętla generująca wykresy dla podanych częstotliwości
    for f in frequencies:
        x = np.sin(2 * np.pi * f * t)  # generowanie sinusoidy o zadanej częstotliwości
        plt.plot(t, x)  # wyświetlanie sinusoidy
        # plt.pause(1)

    plt.xlabel('Czas [s]')
    plt.ylabel('Amplituda')
    plt.title(title)
    if legend:
      plt.legend([f'{f} Hz' for f in frequencies])
    plt.show()

# Wygenerowanie wykresów dla różnych częstotliwości
frequencies = range(0, 301, 5)
plot_sinusoids(frequencies, 'Wykresy sinusoid', False)

# Wykres porównujący sinusoidy o różnych częstotliwościach
frequencies = [5, 105, 205]
plot_sinusoids(frequencies, 'Porównanie sinusoid o różnych częstotliwościach')

# Wykres porównujący sinusoidy o różnych częstotliwościach
frequencies = [95, 195, 295]
plot_sinusoids(frequencies, 'Porównanie sinusoid o różnych częstotliwościach')

# Wykres porównujący sinusoidy o bliskich częstotliwościach
frequencies = [95, 105]
plot_sinusoids(frequencies, 'Porównanie sinusoid o bliskich częstotliwościach')