import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqs, butter, cheby1, cheby2, ellip, tf2zpk

sampling_freq = 256 * 1000  # częstotliwość próbkowania przetwornika A/C
cutoff = sampling_freq / 2  # maksymalne tłumienie
points = 4096
w = np.linspace(0, sampling_freq, points) * 2 * np.pi

freq_64 = 1000 * 64
freq_112 = 1000 * 112
freq_128 = 1000 * 128

# Butterworth filter
b_butter, a_butter = butter(7, 2 * np.pi * freq_64, analog=True)
frequnecy_response_butter = freqs(b_butter, a_butter, w)[1]
poles_butter = tf2zpk(b_butter, a_butter)[1]

# Chebyshev Type I filter
b_cheby1, a_cheby1 = cheby1(5, 3, 2 * np.pi * freq_64, analog=True)
frequnecy_response_cheby1 = freqs(b_cheby1, a_cheby1, w)[1]
poles_cheby1 = tf2zpk(b_cheby1, a_cheby1)[1]

# Chebyshev Type II filter
b_cheby2, a_cheby2 = cheby2(5, 40, 2 * np.pi * freq_112, analog=True)
frequnecy_response_cheby2 = freqs(b_cheby2, a_cheby2, w)[1]
poles_cheby2 = tf2zpk(b_cheby2, a_cheby2)[1]

# Elliptic filter
b_ellip, a_ellip = ellip(3, 3, 40, 2 * np.pi * freq_64, analog=True)
frequnecy_response_ellip = freqs(b_ellip, a_ellip, w)[1]
poles_ellip = tf2zpk(b_ellip, a_ellip)[1]

plt.figure()
plt.plot(w / (2000 * np.pi), 20 * np.log10(np.abs(frequnecy_response_butter)))
plt.plot(w / (2000 * np.pi), 20 * np.log10(np.abs(frequnecy_response_cheby1)))
plt.plot(w / (2000 * np.pi), 20 * np.log10(np.abs(frequnecy_response_cheby2)))
plt.plot(w / (2000 * np.pi), 20 * np.log10(np.abs(frequnecy_response_ellip)))
plt.axis([0, 256, -40, 10])
plt.grid()
plt.title("Odpowiedź częstotliwościowa modelów")
plt.xlabel("Częstotliwość (kHz)")
plt.ylabel("Odpowiedź (dB)")
plt.legend(["Butter", "Czeby1", "Czeby2", "Elipt"])

plt.figure()
plt.plot(np.real(poles_butter), np.imag(poles_butter), '*')
plt.plot(np.real(poles_cheby1), np.imag(poles_cheby1), '+')
plt.plot(np.real(poles_cheby2), np.imag(poles_cheby2), 's')
plt.plot(np.real(poles_ellip), np.imag(poles_ellip), 'd')
plt.grid()
plt.title("Rozkład biegunów filtrów")
plt.legend(["Butter", "Czeby1", "Czeby2", "Elipt"])
plt.xlabel("Re")
plt.ylabel("Im")

plt.show()
