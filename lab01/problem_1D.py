import numpy as np
import matplotlib.pyplot as plt

duration = 1
base_sampling_frequency = 10000
carrier_frequency = 50
modulating_frequency = 1
modulation_depth = 5

time = np.arange(0, duration, 1/base_sampling_frequency)

carrier_signal = np.sin(2 * np.pi * carrier_frequency * time)
modulating_signal = np.sin(2 * np.pi * modulating_frequency * time)

modulated_signal = np.sin(2 * np.pi * (carrier_frequency + modulation_depth * modulating_signal) * time)

plt.figure(figsize=(10, 6))
plt.plot(time, modulated_signal, label='Sygnał zmodulowany')
plt.plot(time, modulating_signal, label='Sygnał modulujący')
plt.title('Sygnał zmodulowany FM wraz z sygnałem modulującym')
plt.xlabel('Czas [s]'),
plt.ylabel('Amplituda')
plt.legend()
plt.grid(True)
plt.show()

sampling_frequency = 25
time_sampling = np.arange(0, duration, 1/sampling_frequency)
modulated_singal_sampled = np.sin(2 * np.pi * (carrier_frequency + modulation_depth * np.sin(2 * np.pi * modulating_frequency * time_sampling)) * time_sampling)

plt.figure(figsize=(10, 6))
plt.plot(time, modulated_signal, label='Sygnał zmodulowany (Analog)')
plt.stem(time_sampling, modulated_singal_sampled, label='Sygnał zmodulowany (Spróbkowany)', linefmt='r--', markerfmt='ro', basefmt='r')
plt.title('Porównanie analogowego i spróbkowanego sygnału zmodulowanego FM')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.legend()
plt.grid(True)
plt.show()

sampling_errors = np.abs(np.interp(time, time_sampling, modulated_singal_sampled) - modulated_signal)
plt.figure(figsize=(10, 6))
plt.plot(time, sampling_errors, "r-")
plt.title('Błędy próbkowania')
plt.xlabel('Czas [s]')
plt.ylabel('Błąd')
plt.grid(True)
plt.show()

plt.figure(figsize=(10, 6))
plt.magnitude_spectrum(modulated_signal, color='blue', marker="o", label='Przed próbkowaniem', )
plt.magnitude_spectrum(modulated_singal_sampled, Fs=sampling_frequency, color='red', marker="o", label='Po próbkowaniu')
plt.title('Gęstość widmowa mocy')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Magnituda')
plt.legend()
plt.grid(True)
plt.show()
