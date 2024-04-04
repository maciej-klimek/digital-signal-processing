import numpy as np
from scipy.signal import ellip, zpk2tf, freqs
import matplotlib.pyplot as plt

# Ustawienia początkowe
points = 4096
N = 4  # Maksymalny rząd filtra ustawiony na 4
mid_freq_unscaled = 96
mid_freq = 2 * np.pi * 1e6 * mid_freq_unscaled  # Przeliczenie na radiany/s
tollerance_unscaled = 50
tollerance = 2 * np.pi * 1e3 * tollerance_unscaled  # Przeliczenie na radiany/s

# Zakres częstotliwości
w = np.linspace(mid_freq - 2 * tollerance, mid_freq + 2 * tollerance, points)

# Projektowanie filtra
ze, pe, ke = ellip(N, 3, 40, [mid_freq - tollerance, mid_freq +
                   tollerance], btype='bandpass', analog=True, output='zpk')

# Konwersja zpk na transfer function (tf)
be, ae = zpk2tf(ze, pe, ke)

# Obliczenie odpowiedzi częstotliwościowej
he = freqs(be, ae, w)

# Rysowanie wykresu
# Zakładając, że he jest wynikiem z funkcji freqs,
# a w jest wektorem częstotliwości używanym w tej funkcji
# i masz tylko jeden zestaw danych odpowiedzi częstotliwościowej (nie 2)

# he[1] oznacza, że bierzemy drugi element zwrócony przez freqs, który jest odpowiedzią częstotliwościową
plt.plot(w / (2 * np.pi * 1e6), 20 * np.log10(np.abs(he[1])))
plt.axis([mid_freq_unscaled - 2 * tollerance_unscaled / 1e3,
         mid_freq_unscaled + 2 * tollerance_unscaled / 1e3, -45, 5])
plt.grid(True)
plt.title("Odpowiedź częstotliwościowa")
plt.xlabel("Częstotliwość (MHz)")
plt.ylabel("Odpowiedź (dB)")
plt.show()
