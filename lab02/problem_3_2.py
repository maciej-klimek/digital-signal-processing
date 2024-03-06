import numpy as np
import matplotlib.pyplot as plt

def plot_analysis(sin_frequencies):
    N = 100  
    sampling_frequency = 1000  
    time_domain = np.arange(N) / sampling_frequency  

    sin_amplitudes = [50, 100, 150]  

    # Sygnał będący sumą trzech sinusoid
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

    frequency_domain = np.arange(N) * sampling_frequency / N

    plt.figure(figsize=(12, 12))
    plt.subplot(3, 2, 1)
    plt.plot(time_domain, signal, "b-o", label='Oryginalny Sygnał')
    plt.title('Oryginalny sygnał')
    plt.xlabel('Czas [s]')
    plt.ylabel('Amplituda [V]')
    plt.grid(True)
    plt.legend()

    plt.subplot(3, 2, 3)
    plt.plot(time_domain, y, 'g-o', label='Zanalizowany Sygnał')
    plt.title('Zanalizowany sygnał')
    plt.xlabel('Czas [s]')
    plt.ylabel('Amplituda [V]')
    plt.grid(True)
    plt.legend()

    plt.subplot(3, 2, 5)
    plt.plot(time_domain, reconstructed_signal, "r-o", label='Odtworzony Sygnał')
    plt.title('Odtworzone sygnały')
    plt.xlabel('Czas [s]')
    plt.ylabel('Amplituda [V]')
    plt.grid(True)
    plt.legend()

    plt.subplot(3, 2, 2)
    plt.plot(frequency_domain, np.abs(np.fft.fft(signal)[:N]), "b--", label='Oryginalny Sygnał')
    plt.title('Analiza częstotliwości oryginalnego sygnału')
    plt.xlabel('Częstotliwość [Hz]')
    plt.ylabel('Amplituda')
    plt.grid(True)
    plt.legend()

    plt.subplot(3, 2, 4)
    plt.plot(frequency_domain, np.abs(y[:N]), 'g--', label='Zanalizowany Sygnał')
    plt.title('Analiza częstotliwości zanalizowanego sygnału')
    plt.xlabel('Częstotliwość [Hz]')
    plt.ylabel('Amplituda')
    plt.grid(True)
    plt.legend()

    plt.subplot(3, 2, 6)
    plt.plot(frequency_domain, np.abs(np.fft.fft(reconstructed_signal)[:N]), "r--", label='Odtworzony Sygnał')
    plt.title('Analiza częstotliwości odtworzonego sygnału')
    plt.xlabel('Częstotliwość [Hz]')
    plt.ylabel('Amplituda')
    plt.grid(True)
    plt.legend()

    plt.tight_layout()

plot_analysis([50, 100, 150])

plot_analysis([f + 2.5 for f in [50, 100, 150]])

plt.show()
