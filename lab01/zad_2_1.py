import numpy as np
import matplotlib.pyplot as plt

sin_frequency = 200
sampling_frequency = 10000

dt2 = 1/sin_frequency
dt1 = 1/sampling_frequency

time_fs2 = np.arange(0, 0.1, dt2)
time_fs1 = np.arange(0, 0.1, dt1)

analog_sin = 230 * np.sin(2 * np.pi * 50 * time_fs2)
sampled_sin = 230 * np.sin(2 * np.pi * 50 * time_fs1)

rec_signal = np.zeros(len(time_fs1))

for x1 in range(len(time_fs1)):
    sample_value = 0
    for x2 in range(len(time_fs2)):
        T1 = 1/sin_frequency
        T2 = 1/sampling_frequency
        t = x1 * T2
        nT = x2 * T1
        y = np.pi/T1 * (t - nT)
        sampling_value = 1
        if y != 0:
            sampling_value = np.sin(y)/y
        sample_value = sample_value + analog_sin[x2] * sampling_value
    rec_signal[x1] = sample_value

plt.figure()
plt.grid(True)
plt.plot(time_fs1, sampled_sin, 'g-')
plt.plot(time_fs1, rec_signal, 'r-')
plt.xlabel('Czas (s)')
plt.ylabel('Amplituda (V)')
plt.title('Rekonstrukcja sygnału')
plt.legend(['Sygnał oryginalny', 'Sygnał zrekonstruowany'])

errors = np.abs(sampled_sin - rec_signal)
plt.figure()
plt.grid(True)
plt.plot(time_fs1, errors, 'r-')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda [V]')
plt.title('Błędy rekonstrukcji sygnału sin(x)/x')
plt.legend(['Błędy rekonstrukcji'])

plt.show()