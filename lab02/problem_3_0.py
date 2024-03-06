import numpy as np
import matplotlib.pyplot as plt

N = 100  
sampling_frequency = 1000  
time_domain = np.arange(N) / sampling_frequency  

sin_frequencies = [50, 100, 150]  
sin_amplitudes = [50, 100, 150]  

signal = np.sum([amplitude * np.sin(2 * np.pi * frequency * time_domain) for frequency, amplitude in zip(sin_frequencies, sin_amplitudes)], axis=0)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
for frequency, amplitude in zip(sin_frequencies, sin_amplitudes):
    plt.plot(time_domain, amplitude * np.sin(2 * np.pi * frequency * time_domain), label=f'Częstotliwość: {frequency} Hz, Amplituda: {amplitude}')
plt.title('Trzy sinusoidy nakładające się na siebie')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda [V]')
plt.grid(True)
plt.legend()

plt.subplot(2, 1, 2)
plt.plot(time_domain, signal)
plt.title('Sygnał x - suma trzech sinusoid')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda [V]')
plt.grid(True)

plt.tight_layout()
plt.show()
