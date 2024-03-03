import numpy as np
import matplotlib.pyplot as plt

sin_frequency = 1
sampling_frequency = 10
T1 = 1 / sampling_frequency

rec_signal_frequency = sampling_frequency * 50
T2 = 1 / rec_signal_frequency

duration = 1
sampling_time = np.arange(0, duration, 1/sampling_frequency)
sampled_signal = np.sin(2 * np.pi * sin_frequency * sampling_time)

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6))

ax1.plot(sampling_time, sampled_signal, marker="o", label="Sygnał próbkowany")
ax1.set_title(f"Sygnał próbkowany z częstotliwością {sampling_frequency} Hz")
ax1.set_xlabel("Czas [s]")
ax1.set_ylabel("Amplituda [V]")
ax1.legend()
ax1.grid(True)

rec_time = np.arange(0, duration, 1/rec_signal_frequency)
rec_signal = np.zeros(len(rec_time))

for x2 in range(len(rec_time)):
    rec_value = 0
    for x1 in range(len(sampling_time)):
        rec_point_value = np.pi / T1 * ((x2 * T2) - (x1 * T1))
        sampling_value = 1
        if rec_point_value != 0:
            sampling_value = np.sin(rec_point_value) / rec_point_value
        rec_value += sampled_signal[x1] * sampling_value
    rec_signal[x2] = rec_value

ax2.plot(rec_time, rec_signal, color="red", marker="x", label="Sygnał odtworzony")
ax2.set_title("Sygnał odtworzony")
ax2.set_xlabel("Czas [s]")
ax2.set_ylabel("Amplituda [V]")
ax2.legend()
ax2.grid(True)

plt.tight_layout()
plt.show()
