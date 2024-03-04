import numpy as np
import matplotlib.pyplot as plt

N = 100  
sampling_frequency = 1000  
time_domain = np.arange(N) / sampling_frequency  
sin_frequencies = [50, 100, 150]  
sin_amplitudes = [50, 100, 150]  
signal = np.sum([amplitude * np.sin(2 * np.pi * frequency * time_domain) for frequency, amplitude in zip(sin_frequencies, sin_amplitudes)], axis=0)

def generate_DCT(N):
    s = np.sqrt(1/N)
    A = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                A[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))
            else:
                A[k, n] = np.sqrt(2/N) * np.cos(np.pi * k / N * (n + 0.5))
    return A

def generate_IDCT(N):
    s = np.sqrt(1/N)
    A = generate_DCT(N)
    S = A.T  
    return S

A = generate_DCT(N)
S = generate_IDCT(N)

y = np.dot(A, signal)
reconstructed_signal = np.dot(S, y)

fig, axs = plt.subplots(3, 2, figsize=(12, 12))

axs[0, 0].plot(time_domain, signal, "b-o", label='Oryginalny Sygnał')
axs[0, 0].set_title('Oryginalny sygnał')
axs[0, 0].set_xlabel('Czas [s]')
axs[0, 0].set_ylabel('Amplituda [V]')
axs[0, 0].grid(True)
axs[0, 0].legend()

axs[1, 0].plot(time_domain, y, 'g-o', label='Zanalizowany Sygnał')
axs[1, 0].set_title('Zanalizowany sygnał')
axs[1, 0].set_xlabel('Czas [s]')
axs[1, 0].set_ylabel('Amplituda [V]')
axs[1, 0].grid(True)
axs[1, 0].legend()

axs[2, 0].plot(time_domain, reconstructed_signal, "r-o", label='Odtworzony Sygnał')
axs[2, 0].set_title('Odtworzone sygnały')
axs[2, 0].set_xlabel('Czas [s]')
axs[2, 0].set_ylabel('Amplituda [V]')
axs[2, 0].grid(True)
axs[2, 0].legend()

frequency_domain = np.arange(N) * sampling_frequency / N
axs[0, 1].plot(frequency_domain, np.abs(np.fft.fft(signal)[:N]), "b--", label='Oryginalny Sygnał')
axs[0, 1].set_title('Analiza częstotliwości oryginalnego sygnału')
axs[0, 1].set_xlabel('Częstotliwość [Hz]')
axs[0, 1].set_ylabel('Amplituda')
axs[0, 1].grid(True)
axs[0, 1].legend()

scaled_frequency_domain = np.arange(N) * sampling_frequency / N
axs[1, 1].plot(scaled_frequency_domain, np.abs(y[:N]), 'g--', label='Zanalizowany Sygnał')
axs[1, 1].set_title('Analiza częstotliwości zanalizowanego sygnału')
axs[1, 1].set_xlabel('Częstotliwość [Hz]')
axs[1, 1].set_ylabel('Amplituda')
axs[1, 1].grid(True)
axs[1, 1].legend()

axs[2, 1].plot(frequency_domain, np.abs(np.fft.fft(reconstructed_signal)[:N]), "r--", label='Odtworzony Sygnał')
axs[2, 1].set_title('Analiza częstotliwości odtworzonego sygnału')
axs[2, 1].set_xlabel('Częstotliwość [Hz]')
axs[2, 1].set_ylabel('Amplituda')
axs[2, 1].grid(True)
axs[2, 1].legend()

plt.tight_layout()
plt.show()

# Sprawdzenie perfekcyjnej rekonstrukcji
perfect_reconstruction = np.allclose(reconstructed_signal, signal)
print("Czy rekonstrukcja jest perfekcyjna?", perfect_reconstruction)

# Możliwa jest rekonstrukcja sygnału, ponieważ wektor y zawiera informacje o "ile" każdego wzorca częstotliwości jest obecne w sygnale. 
# Macierz S jest transpozycją macierzy A, która zawiera te same wzorce częstotliwości, ale w innej formie. 
# Wiedząc, ile razy każdy wzorzec występuje w sygnale (informacja zawarta w wektorze y), 
# możemy pomnożyć każdy wzorzec przez odpowiednią ilość i zsumować te przeskalowane wzorce, aby odtworzyć sygnał. 
# Ostatecznie, rekonstrukcja sygnału jest możliwa dzięki temu, że mamy informacje o tym, jakie wzorce częstotliwości występują w analizowanym sygnale.
