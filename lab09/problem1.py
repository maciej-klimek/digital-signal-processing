import numpy as np
import matplotlib.pyplot as plt

# Generowanie sygnału złożonego z dwóch harmonicznych
fs = 8000  # częstotliwość próbkowania
t = np.linspace(0, 1, fs, endpoint=False)  # czas trwania 1 sekundy
A1, f1 = 0.5, 34.2  # amplituda i częstotliwość pierwszej harmonicznej
A2, f2 = 1, 115.5  # amplituda i częstotliwość drugiej harmonicznej
signal = A1 * np.sin(2 * np.pi * f1 * t) + A2 * np.sin(2 * np.pi * f2 * t)

# Sygnał odniesienia (czysty)
dref = signal

# Poziomy SNR w dB
snr_levels = [10, 20, 40]

# Tablica do przechowywania zaszumionych sygnałów
noisy_signals = []

# Generowanie zaszumionych sygnałów dla różnych poziomów SNR
for snr_db in snr_levels:
    noise_power = np.var(signal) / (10**(snr_db / 10))  # moc szumu
    noise = np.random.normal(0, np.sqrt(noise_power), len(signal))  # generowanie szumu
    d_noisy = signal + noise  # zaszumiony sygnał
    noisy_signals.append(d_noisy)  # dodanie zaszumionego sygnału do tablicy

# Parametry filtru adaptacyjnego
M = 7  # długość filtru
mi = 0.1  # współczynnik szybkości adaptacji

# Czas trwania wykresu (w sekundach)

# Filtracja adaptacyjna dla każdego zaszumionego sygnału
filtered_signals = []
for d_noisy in noisy_signals:
    y = np.zeros(len(d_noisy))  # sygnał wyjściowy z filtra
    e = np.zeros(len(d_noisy))  # błąd estymacji
    h = np.zeros(M)  # wagi filtru

    for n in range(M, len(d_noisy)):
        bx = np.concatenate(([d_noisy[n]], d_noisy[n-M:n-1]))  # pobierz próbki do bufora
        y[n] = np.dot(h, bx)  # filtr FIR
        e[n] = d_noisy[n] - y[n]  # błąd estymacji
        h = h + mi * e[n] * bx  # LMS
        # h = h + mi * e[n] * bx /(bx.transpose() * bx)

    filtered_signals.append(y)  # dodanie odszumionego sygnału do tablicy

# Obliczenie wskaźnika SNR dla każdego odszumionego sygnału
snr_values = []
for d_noisy, y in zip(noisy_signals, filtered_signals):
    snr = 10 * np.log10(np.sum(dref**2) / np.sum((dref - y)**2))  # wskaźnik SNR
    snr_values.append(snr)


plot_duration = 0.1  # Możesz zmienić na dowolną wartość, np. 0.1, 0.5, itp.

# Wyświetlenie wyników
for d_noisy, y, snr in zip(noisy_signals, filtered_signals, snr_values):
    plt.figure(figsize=(10, 6))

    # Ograniczenie osi czasu
    plot_samples = int(plot_duration * fs)
    plt.plot(t[:plot_samples], dref[:plot_samples], label='Oryginalny sygnał', color='blue')
    plt.plot(t[:plot_samples], d_noisy[:plot_samples], label='Zaszumiony sygnał', linestyle='--', color='orange')
    plt.plot(t[:plot_samples], y[:plot_samples], label=f'Odszumiony sygnał (SNR = {snr:.2f} dB)', color='green')

    plt.title('Odszumianie sygnału')
    plt.xlabel('Czas [s]')
    plt.ylabel('Amplituda')
    plt.legend()
    plt.grid(True)

    plt.show()