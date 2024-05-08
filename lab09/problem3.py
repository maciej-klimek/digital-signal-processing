import numpy as np
import matplotlib.pyplot as plt

# Funkcja implementująca pętlę PLL
def pll_loop(p, fpilot, fs):
    freq = 2 * np.pi * fpilot / fs
    theta = np.zeros(len(p) + 1)
    alpha = 1e-2
    beta = alpha**2 / 4
    
    for n in range(len(p)):
        perr = -p[n] * np.sin(theta[n])
        theta[n+1] = theta[n] + freq + alpha * perr
        freq = freq + beta * perr
    
    c57 = np.cos(3 * theta[:-1])  # Generowanie sygnału harmonicznej 57 kHz
    return c57

# Generowanie sygnału pilota o stałym przesunięciu fazowym
def generate_constant_pilot_signal(fpilot, fs, duration=1.0):
    t = np.linspace(0, duration, int(duration * fs))
    pilot_signal = np.sin(2 * np.pi * fpilot * t)
    return t, pilot_signal

# Generowanie sygnału pilota z dodatkowymi zmianami częstotliwości
def generate_variable_pilot_signal(fpilot, fs, duration=1.0, df=10, fm=0.1):
    t = np.linspace(0, duration, int(duration * fs))
    df_signal = np.sin(2 * np.pi * fm * t) * df
    pilot_signal = np.sin(2 * np.pi * (fpilot + df_signal) * t)
    return t, pilot_signal

# Funkcja obliczająca szybkość zbieżności pętli PLL
def convergence_speed(c57_reference, c57_pll):
    for i in range(len(c57_reference)):
        if np.allclose(c57_reference[i:], c57_pll[:len(c57_reference)-i]):
            return i
    return len(c57_reference)

# Funkcja obliczająca MSE między oczekiwanym sygnałem nosnej a sygnałem wyjściowym pętli PLL
def calculate_mse(expected_signal, actual_signal):
    return np.mean((expected_signal - actual_signal)**2)

# Parametry sygnału pilota
fpilot = 19000  # częstotliwość pilota 19 kHz
fs = 48000  # częstotliwość próbkowania
duration = 1.0  # czas trwania sygnału

# Punkt 1: Generowanie sygnału pilota o stałym przesunięciu fazowym
t_constant, pilot_signal_constant = generate_constant_pilot_signal(fpilot, fs, duration)
c57_constant = pll_loop(pilot_signal_constant, fpilot, fs)

# Punkt 2: Generowanie sygnału pilota z dodatkowymi zmianami częstotliwości
t_variable, pilot_signal_variable = generate_variable_pilot_signal(fpilot, fs, duration)
c57_variable = pll_loop(pilot_signal_variable, fpilot, fs)

# Punkt 3: Szybkość zbieżności pętli PLL
snr_levels = [0, 5, 10, 20]  # poziomy SNR w dB
convergence_samples = []

for snr in snr_levels:
    pilot_signal_noisy = np.random.normal(pilot_signal_constant, snr, size=len(pilot_signal_constant))
    c57_noisy = pll_loop(pilot_signal_noisy, fpilot, fs)
    convergence_samples.append(convergence_speed(c57_constant, c57_noisy))

# Punkt 1: Obliczanie MSE dla sygnału pilota o stałym przesunięciu fazowym
expected_c57_constant = np.cos(3 * np.linspace(0, duration, int(duration * fs)))  # Oczekiwany sygnał nosnej
mse_constant = calculate_mse(c57_constant, expected_c57_constant)
print("MSE dla sygnału pilota o stałym przesunięciu fazowym:", mse_constant)

# Punkt 2: Obliczanie MSE dla sygnału pilota z dodatkowymi zmianami częstotliwości
expected_c57_variable = np.cos(3 * np.linspace(0, duration, int(duration * fs)))  # Oczekiwany sygnał nosnej
mse_variable = calculate_mse(c57_variable, expected_c57_variable)
print("MSE dla sygnału pilota z dodatkowymi zmianami częstotliwości:", mse_variable)

# Wykresy
t_start = 0.2
t_end = 0.25

# Punkt 1: Wykresy sygnału pilota o stałym przesunięciu fazowym
plt.figure()
plt.plot(t_constant, pilot_signal_constant)
plt.title('Sygnał pilota (stałe przesunięcie fazowe)')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.xlim(t_start, t_end)
plt.grid(True)
plt.show()

plt.figure()
plt.plot(t_constant, c57_constant)
plt.title('Sygnał nosnej 57 kHz')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.xlim(t_start, t_end)
plt.grid(True)
plt.show()

# Punkt 2: Wykresy sygnału pilota z dodatkowymi zmianami częstotliwości
plt.figure()
plt.plot(t_variable, pilot_signal_variable)
plt.title('Sygnał pilota (zmienne częstotliwości)')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.xlim(t_start, t_end)
plt.grid(True)
plt.show()

plt.figure()
plt.plot(t_variable, c57_variable)
plt.title('Sygnał nosnej 57 kHz')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.xlim(t_start, t_end)
plt.grid(True)
plt.show()

# Punkt 3: Wykres szybkości zbieżności pętli PLL
plt.figure()
plt.plot(snr_levels, convergence_samples, marker='o')
plt.title('Szybkość zbieżności pętli PLL w zależności od SNR')
plt.xlabel('SNR [dB]')
plt.ylabel('Liczba próbek do zbieżności')
plt.grid(True)
plt.show()
