import scipy.io
import numpy as np
import matplotlib.pyplot as plt

mat_data = scipy.io.loadmat('lab_03.mat')

index = 414836
signal_key = 'x_' + str(index % 16 + 1)

# Sygnał ADSL
signal = mat_data[signal_key][:, 0]
print(signal)

# Parametry sygnału
N = 512  # długość ramki
M = 32   # długość prefiksu
K = 8    # liczba ramek

# zapis harmonicznych do pliku
with open("problem_4_harmoniczne.txt", "w") as file:
    # Analiza częstotliwościowa
    for i in range(K):

        # Ramka sygnału (bez prefiksu)
        frame = signal[i * (N + M) + M: (i + 1) * (N + M)]

        spectrum = np.fft.fft(frame, N)
        frequencies = np.linspace(0, 512, N, endpoint=False)

        file.write("Ramka {} - Harmoniczne uzywane:\n".format(i+1))
        for freq in frequencies:
            if abs(spectrum[int(freq)]) > 1:
                file.write("{}  |  {}\n".format(freq, abs(spectrum[int(freq)])))
        file.write("\n")


fig, ax = plt.subplots(4, 2, figsize=(12,20))

for i in range(K):
    # Ramka sygnału (bez prefiksu)
    frame = signal[i * (N + M) + M: (i + 1) * (N + M)]

    spectrum = np.fft.fft(frame, N)

    if i > 3:
        j = i - 4
        s = 1
    else:
        j = i
        s = 0
    ax[j, s].plot(frequencies, abs(spectrum), "g-o")
    ax[j, s].set_title("Ramka numer {}".format(i+1))

plt.tight_layout()
plt.show()