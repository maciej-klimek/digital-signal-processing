import numpy as np
import matplotlib.pyplot as plt

duration = 1
base_sampling_frequency = 10000
sampling_frequency = 25

carrier_frequency = 50

modulation_frequency = 1
modulation_depth = 5

# modulation_frequency = 10             # żeby pokazać lepiej samplowanie
# modulation_depth = 20

time_domain = np.arange(0, duration, 1/base_sampling_frequency)
dt = time_domain[1] - time_domain[0]      # potrzebne do całki w FM

modulating_signal = np.sin(2 * np.pi * modulation_frequency * time_domain)


# wzór na modulacje FM
modulated_signal = np.sin(2 * np.pi * (carrier_frequency * time_domain + modulation_depth * np.cumsum(modulating_signal*dt)))

fig, ax = plt.subplots(2, 1, figsize=(12, 8))

ax[0].plot(time_domain, modulated_signal, label='Sygnał zmodulowany')
ax[0].plot(time_domain, modulating_signal, label='Sygnał modulujący')
ax[0].set_title('Sygnał zmodulowany FM wraz z sygnałem modulującym')
ax[0].set_xlabel('Czas [s]')
ax[0].set_ylabel('Amplituda [V]')
ax[0].legend()
ax[0].grid(True)

time_domain_sampling = np.arange(0, duration, 1/sampling_frequency)
samples = np.interp(time_domain_sampling, time_domain, modulated_signal)        # próbkowanie sygnału przez interpolacje arrayem z czasami próbek


ax[1].plot(time_domain, modulated_signal, label='Sygnał zmodulowany')
ax[1].stem(time_domain_sampling, samples, label='Sygnał spróbkowany', linefmt='r--', markerfmt='ro', basefmt='r')
ax[1].set_title('Porównanie zmodulowanego i spróbkowanego sygnału FM')
ax[1].set_xlabel('Czas [s]')
ax[1].set_ylabel('Amplituda [V]')
ax[1].legend()
ax[1].grid(True)

plt.tight_layout()
plt.show()


# plt.figure(figsize=(10, 6))

# plt.plot(time, modulated_signal, label='Sygnał zmodulowany (Analog)')
# plt.plot(time_sampling, modulated_signal_sampled, "r-", label='Sygnał zmodulowany (Spróbkowany)')
# plt.title('Porównanie analogowego i spróbkowanego sygnału zmodulowanego FM')
# plt.xlabel('Czas [s]')
# plt.ylabel('Amplituda')
# plt.legend()
# plt.grid(True)
# plt.show()

fig, axs = plt.subplots(1, 2, figsize=(12, 6))

axs[0].magnitude_spectrum(modulated_signal, Fs=base_sampling_frequency, scale='dB', color='blue', marker="o", label='Przed próbkowaniem', )
axs[0].set_title('Gęstość widmowa mocy przed próbkowaniem')
axs[0].set_xlabel('Częstotliwość [Hz]')
axs[0].legend()
axs[0].grid(True)

axs[1].magnitude_spectrum(samples, Fs=sampling_frequency, scale='dB', color='red', marker="o", label='Po próbkowaniu')
axs[1].set_title('Gęstość widmowa mocy po próbkowaniu')
axs[1].set_xlabel('Częstotliwość [Hz]')
axs[1].legend()
axs[1].grid(True)

plt.tight_layout()
plt.show()
