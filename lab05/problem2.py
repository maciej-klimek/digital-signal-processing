import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqs, TransferFunction, impulse, step

N_values = [2, 4, 6, 8]
omega_3dB = 2 * np.pi * 100
w = np.arange(0, 2000, 0.1)
ang = np.zeros((4, len(w)))
H_dec = np.zeros((4, len(w)))
H_lin = np.zeros((4, len(w)))


for i, N in enumerate(N_values):
    poles = omega_3dB * \
        np.exp(1j * (np.pi / 2 + 1 / 2 * np.pi / N + (np.arange(N) * np.pi / N)))
    amp = np.prod(-poles)
    a = np.poly(poles)
    b = amp
    H = TransferFunction(b, a)
    w_out, h = freqs(H.num, H.den, w)

    ang[i, :] = np.angle(h)
    H_dec[i, :] = 20 * np.log10(np.abs(h))
    H_lin[i, :] = np.abs(h)

plt.figure()
plt.subplot(2, 1, 1)
plt.grid(True)
for row in range(4):
    plt.plot(w_out / (2 * np.pi), H_dec[row, :])
plt.legend(N_values)
plt.title("Charakterystyka Amplitudy w Skali Logarytmicznej")
plt.ylabel("Amplituda [dB]")

plt.subplot(2, 1, 2)
plt.grid(True)
for row in range(4):
    plt.plot(w_out / (2 * np.pi), H_lin[row, :])
plt.legend(N_values)
plt.title("Charakterystyka Amplitudy w Skali Liniowej")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Amplituda")

plt.figure()
plt.grid(True)
for row in range(4):
    plt.plot(w_out / (2 * np.pi), ang[row, :])
plt.legend(N_values)
plt.title("Charakterystyka Fazowa")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Kąt [rad]")

plt.figure()
plt.grid(True)
for row in range(4):
    plt.plot(w_out / (2 * np.pi), np.unwrap(ang[row, :]))
plt.legend(N_values)
plt.title("Charakterystyka Fazowa [unwraped]")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Kąt [rad]")



plt.figure()
plt.grid(True)


poles4 = omega_3dB * \
    np.exp(1j * (np.pi / 2 + 1 / 2 * np.pi / 4 + (np.arange(4) * np.pi / 4)))
a = np.poly(poles4)
b = amp
H = TransferFunction(b, a)
tOut, y = impulse(H)
plt.plot(tOut, y)
plt.title("Odpowiedź Impulsowa")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda")

plt.figure()
plt.grid(True)
tOut, y = step(H)
plt.plot(tOut, y)
plt.title("Odpowiedź na Skok Jednostkowy")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda")

plt.show()
