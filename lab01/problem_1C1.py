import numpy as np
import matplotlib.pyplot as plt

sin_frequencies = [5, 105, 205]
# sin_frequencies = [95, 195, 295]
# sin_frequencies = [95, 105]
sin_amplitude = 230
sampling_frequency = 100
duration = 1

time_domain = np.arange(0, duration, 1/sampling_frequency)


signals = []
for f in sin_frequencies:
    sin_wave = sin_amplitude * np.sin(2 * np.pi * f * time_domain)
    signals.append((time_domain, sin_wave))

plt.figure(figsize=(10, 6))
plt.plot(signals[0][0], signals[0][1], "b-o", label=f"Częstotliwość sinusa: {sin_frequencies[0]} Hz")
plt.plot(signals[1][0], signals[1][1], "r-x", label=f"Częstotliwość sinusa: {sin_frequencies[1]} Hz")
plt.plot(signals[2][0], signals[2][1], "y--1", label=f"Częstotliwość sinusa: {sin_frequencies[2]} Hz")

plt.title(f"Trzy sinusy o częstotliwościach {sin_frequencies} próbkowane z częstotliwością {sampling_frequency}")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda [V]")
plt.legend()
plt.grid(True)
plt.show()

