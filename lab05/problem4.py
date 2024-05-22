import numpy as np
from scipy.signal import ellip, zpk2tf, freqs
import matplotlib.pyplot as plt

# Ustawienia początkowe
num_points = 4096
max_filter_order = 4
center_frequency_norm = 96  # MHz
center_frequency = 2 * np.pi * 1000000 * center_frequency_norm  # radiany
tolerance_1MHz_norm = 1  # MHz
tolerance_1MHz = 2 * np.pi * 1000000 * tolerance_1MHz_norm  # radiany

frequencies_1MHz = np.linspace(center_frequency - 2 * tolerance_1MHz,
                                center_frequency + 2 * tolerance_1MHz, num_points)

# Projektowanie testowego filtru (96 MHz ±1 MHz)
ze_1MHz, pe_1MHz, ke_1MHz = ellip(max_filter_order, 3, 40, [
                                   center_frequency - tolerance_1MHz, center_frequency + tolerance_1MHz], btype='bandpass', analog=True, output='zpk')
be_1MHz, ae_1MHz = zpk2tf(ze_1MHz, pe_1MHz, ke_1MHz)
frequency_response_1MHz = freqs(be_1MHz, ae_1MHz, frequencies_1MHz)


# Wykres charakterystyki częstotliwościowej testowego filtru (96 MHz ±1 MHz)
plt.figure(figsize=(10, 6))
plt.plot(frequencies_1MHz / (2 * np.pi * 1e6), 20 *
         np.log10(np.abs(frequency_response_1MHz[1])))
plt.grid(True)
plt.title("Charakterystyka częstotliwościowa testowego filtru (±1 MHz)")
plt.xlabel("Częstotliwość (MHz)")
plt.ylabel("Odpowiedź (dB)")
plt.show()

