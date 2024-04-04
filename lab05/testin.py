import numpy as np
from scipy.signal import freqs, impulse, TransferFunction, step
import matplotlib.pyplot as plt

N_values = [2, 4, 6, 8]
omega_3dB = 2 * np.pi * 100
w = np.linspace(0, 2000, num=20001) * 2 * np.pi  # Angular frequency in rad/s
ang = np.zeros((4, len(w)))
Hdec = np.zeros((4, len(w)))
Hlin = np.zeros((4, len(w)))

for i, N in enumerate(N_values):
    angles = np.pi/2 + (1/2) * np.pi/N + (np.arange(1, N+1)-1)*np.pi/N
    poles = omega_3dB * np.exp(1j * angles)
    wzm = np.prod(-poles)
    a = np.poly(poles)
    b = [wzm]
    w, h = freqs(b, a, worN=w)

    ang[i, :] = np.angle(h)
    Hdec[i, :] = 20 * np.log10(np.abs(h))
    Hlin[i, :] = np.abs(h)

# Logarithmic scale plot
plt.figure()
for row in range(4):
    plt.semilogx(w / (2 * np.pi), Hdec[row, :], label=f"{N_values[row]}")
plt.grid(True)
plt.legend()
plt.title("Charakterystyka A-cz skala logarytmiczna")

# Linear scale plot
plt.figure()
for row in range(4):
    plt.plot(w / (2 * np.pi), Hlin[row, :], label=f"{N_values[row]}")
plt.legend()
plt.title("Charakterystyka A-cz skala liniowa")

# Phase plot
plt.figure()
for row in range(4):
    plt.plot(w / (2 * np.pi), ang[row, :], label=f"{N_values[row]}")
plt.legend()
plt.title("Charakterystyka cz-f")

# Impulse and step response for N=4
N = 4
omega_3dB = 2 * np.pi * 100  # Example cutoff frequency
poles4 = omega_3dB * \
    np.exp(1j * (np.pi/2 + 1/2 * np.pi/N + (np.arange(1, N+1)-1)*np.pi/N))

a = np.poly(poles4)
b = [np.prod(-poles4)]
H = TransferFunction(b, a)

# Impulse response
tOut, y = impulse(H)
plt.figure()
plt.plot(tOut, y)
plt.title("Odpowiedź impulsowa")

# Step response
tOut, y = step(H)
plt.figure()
plt.plot(tOut, y)
plt.title("Odpowiedź na skok jednostkowy")

plt.show()
