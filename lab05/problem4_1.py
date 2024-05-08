import numpy as np
from scipy.signal import ellip, zpk2tf, freqs
import matplotlib.pyplot as plt

num_points = 4096
max_filter_order = 4
center_frequency_norm = 96  # MHz
center_frequency = 2 * np.pi * 1000000 * center_frequency_norm  # radiany
tolerance_norm = 50  # kHz
tolerance = 2 * np.pi * 1000 * tolerance_norm  # radiany

frequencies = np.linspace(center_frequency - 2 * tolerance,
                          center_frequency + 2 * tolerance, num_points)

ze, pe, ke = ellip(max_filter_order, 3, 40, [
                   center_frequency - tolerance, center_frequency + tolerance], btype='bandpass', analog=True, output='zpk')

# Konwersja zpk na współczynniki transmitancji (mianownik, licznik)
be, ae = zpk2tf(ze, pe, ke)

frequency_response = freqs(be, ae, frequencies)

plt.plot(frequencies / (2 * np.pi * 1e6), 20 *
         np.log10(np.abs(frequency_response[1])))
plt.axis([center_frequency_norm - 2 * tolerance_norm / 1e3,
         center_frequency_norm + 2 * tolerance_norm / 1e3, -45, 5])
plt.grid(True)
plt.title("Charakterystyka częstotliwościowa filtru (±100 kHz)")
plt.xlabel("Częstotliwość (MHz)")
plt.ylabel("Odpowiedź (dB)")

# Dodanie linii w 3 dB
plt.axhline(y=-3, color='r', linestyle='--')
plt.axhline(y=-40, color='r', linestyle='--')


plt.show()
