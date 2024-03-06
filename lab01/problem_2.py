import numpy as np
import matplotlib.pyplot as plt

sin_frequency = 2
# sin_frequency = 10
sampling_frequency = 50
# sampling_frequency = 200

T1 = 1 / sampling_frequency         # okres pierwotnego sygnału

rec_signal_frequency = sampling_frequency * 50
T2 = 1 / rec_signal_frequency       # okres rekonstruowanego sygnału

duration = 1
sampling_time_domain = np.arange(0, duration, 1/sampling_frequency)
samples = np.sin(2 * np.pi * sin_frequency * sampling_time_domain)

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6))

ax1.plot(sampling_time_domain, samples, marker="o", label="Sygnał próbkowany")
ax1.set_title(f"Sygnał próbkowany z częstotliwością {sampling_frequency} Hz")
ax1.set_xlabel("Czas [s]")
ax1.set_ylabel("Amplituda [V]")
ax1.legend()
ax1.grid(True)

rec_time_domain = np.arange(0, duration, 1/rec_signal_frequency)
rec_signal = np.zeros(len(rec_time_domain))

for x2 in range(len(rec_time_domain)):
    rec_sample_value = 0

    for x1 in range(len(sampling_time_domain)):
        t = x2 * T2
        nT = x1 * T1
        rec_point_value = np.pi / T1 * (t - nT)
        sampling_value = 1

# ten warunek stąd, że jesli bierzemy punkt centralnie nad próbką to wyjdzie nam 0, wtedy bierzemy do odtworzonej próbki po prostu wartość pierwotnego sygnału
        
        if rec_point_value != 0:   
            sampling_value = np.sin(rec_point_value) / rec_point_value

        rec_sample_value += samples[x1] * sampling_value

    rec_signal[x2] = rec_sample_value


ax2.plot(rec_time_domain, rec_signal, color="red", marker="x", label="Sygnał odtworzony")
ax2.set_title("Sygnał odtworzony")
ax2.set_xlabel("Czas [s]")
ax2.set_ylabel("Amplituda [V]")
ax2.legend()
ax2.grid(True)

plt.tight_layout()



perfect_signal = np.sin(2 * np.pi * sin_frequency * np.arange(0, duration, 1/rec_signal_frequency))


# error_values = abs(samples - np.interp(sampling_time_domain, rec_time_domain, rec_signal))
error_values = abs(perfect_signal - rec_signal)


plt.figure(figsize=(12, 6))

plt.subplot(1, 2, 1)
plt.plot(sampling_time_domain, samples, "b-o", rec_time_domain, rec_signal, "r--", label='Original Signal')
ax2.set_title("Sygnał pierwotny i odtworzony nałożone na siebie")
ax2.set_xlabel("Czas [s]")
ax2.set_ylabel("Amplituda [V]")
plt.legend()
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(rec_time_domain, error_values, "r-")
plt.title('Błędy rekonstrukcji w dziedzinie czasu')
ax2.set_xlabel("Czas [s]")
ax2.set_ylabel("Różnica w amplitudazie [V]")
plt.grid(True)

plt.tight_layout()
plt.show()