import numpy as np
import matplotlib.pyplot as plt

# DO SKONCZENIA

# Generate original signal
N = 100  
sampling_frequency = 1000  
time_domain = np.arange(N) / sampling_frequency  
sin_frequencies = [50, 100, 150]  
sin_amplitudes = [50, 100, 150]  
signal = np.sum([amplitude * np.sin(2 * np.pi * frequency * time_domain) for frequency, amplitude in zip(sin_frequencies, sin_amplitudes)], axis=0)


# Generate DCT and IDCT matrices
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
    S = A.T  # Transpose of DCT matrix
    return S

A = generate_DCT(N)
S = generate_IDCT(N)

# Perform DCT and IDCT
y = np.dot(A, signal)
x_reconstructed = np.dot(S, y)

# Plot original signal
fig, ax = plt.subplots(2, 2, figsize=(12, 8))

ax[0, 0].plot(time_domain, signal, "b-o", label='Original Signal')
ax[0, 0].set_title('Comparison of Original and Reconstructed Signals')
ax[0, 0].set_xlabel('Time [s]')
ax[0, 0].set_ylabel('Amplitude [V]')
ax[0, 0].grid(True)
ax[0, 0].legend()

ax[1, 0].plot(time_domain, x_reconstructed, "r-o", label='Reconstructed Signal')
ax[1, 0].set_title('Comparison of Original and Reconstructed Signals')
ax[1, 0].set_xlabel('Time [s]')
ax[1, 0].set_ylabel('Amplitude [V]')
ax[1, 0].grid(True)
ax[1, 0].legend()

frequency_domain = np.arange(N) * sampling_frequency / N
ax[0, 1].plot(frequency_domain, np.abs(np.fft.fft(signal)[:N]), "b--", label='Original Signal')
ax[0, 1].set_title('Comparison of Frequency Analyses')
ax[0, 1].set_xlabel('Frequency [Hz]')
ax[0, 1].set_ylabel('Amplitude')
ax[0, 1].grid(True)
ax[0, 1].legend()

ax[1, 1].plot(frequency_domain, np.abs(np.fft.fft(x_reconstructed)[:N]), "r--", label='Reconstructed Signal')
ax[1, 1].set_title('Comparison of Frequency Analyses')
ax[1, 1].set_xlabel('Frequency [Hz]')
ax[1, 1].set_ylabel('Amplitude')
ax[1, 1].grid(True)
ax[1, 1].legend()

plt.tight_layout()
plt.show()



