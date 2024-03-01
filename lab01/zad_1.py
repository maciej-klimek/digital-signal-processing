import numpy as np
import matplotlib.pyplot as plt

sin_frequency = 50
sin_amplitude = 230
sampling_frequencies = [10000, 500, 200]

duration = 0.1
time = np.arange(0, duration, 1/sampling_frequencies[0])

sine_waves = []
for fs in sampling_frequencies:
    time_domain = np.arange(0, duration, 1/fs)
    sin_values = sin_amplitude * \
        np.sin(2 * np.pi * sin_frequency * time_domain)
    sine_waves.append((time_domain, sin_values))

plt.figure(figsize=(10, 6))
for i, (time_domain, sin_values) in enumerate(sine_waves):
    plt.plot(time_domain, sin_values,
             label=f"Sampling Frequency: {sampling_frequencies[i]} Hz", linestyle="-", marker="o")

plt.title("Sine Waves with Different Sampling Frequencies")
plt.xlabel("Time (s)")
plt.ylabel("Amplitude")
plt.legend()
plt.grid(True)
plt.show()
