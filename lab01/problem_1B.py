import numpy as np
import matplotlib.pyplot as plt

sin_frequency = 50
sin_amplitude = 230
sampling_frequencies = [10000, 51, 50, 49]
# sampling_frequencies = [10000, 26, 25, 24]

duration = 1
time = np.arange(0, duration, 1/sampling_frequencies[0])

signals = []
for fs in sampling_frequencies:
    time_domain = np.arange(0, duration, 1/fs)
    sin_wave = sin_amplitude * \
        np.sin(2 * np.pi * sin_frequency * time_domain)
    signals.append((time_domain, sin_wave))

plt.figure(figsize=(10, 6))
plt.plot(
    signals[0][0], signals[0][1], "b-", label=f"Częstotliwość próbkowania: {sampling_frequencies[0]} Hz")
plt.plot(
    signals[1][0], signals[1][1], "g-o", label=f"Częstotliwość próbkowania: {sampling_frequencies[1]} Hz")
plt.plot(
    signals[2][0], signals[2][1], "r-o", label=f"Częstotliwość próbkowania: {sampling_frequencies[2]} Hz")
plt.plot(
    signals[3][0], signals[3][1], "k-o", label=f"Częstotliwość próbkowania: {sampling_frequencies[3]} Hz")

plt.title("Sygnał analogowy z różnymi częstotliwościami próbkowania")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda [V]")
plt.legend()
plt.grid(True)
plt.show()
