import numpy as np
import matplotlib.pyplot as plt
import scipy.io

def get_correlation(x, y):

    n = len(x)
    m = len(y)

    x_mean = np.mean(x)
    y_mean = np.mean(y)

    x_std = np.std(x)
    y_std = np.std(y)

    result = np.zeros(n + m - 1)
    delay = np.arange(-n + 1, m)

    for i in range(len(result)):
        if delay[i] < 0:
            result[i] = np.sum((x[0:n + delay[i]] - x_mean) * (y[-delay[i]:m] - y_mean))
        elif delay[i] == 0:
            result[i] = np.sum((x - x_mean) * (y - y_mean))
        else:
            result[i] = np.sum((x[delay[i]:n] - x_mean) * (y[0:m - delay[i]] - y_mean))

        result[i] = result[i] / (x_std * y_std * (n - abs(delay[i])))

    return result

# Wczytanie danych
data = scipy.io.loadmat('adsl_x.mat')
signal = np.array(data['x'])

prefix_length = 32
frame_length = 512
package_length = prefix_length + frame_length

max_correlation = 0
start_prefix_positions = np.zeros((3, 1))       # wiemy że są 3 prefiksy 

for i in range(len(signal) // 3):
    if (i + 3 * package_length) > len(signal):
        break

    max_corr_group = 0
    tmp_start_prefix_positions = np.zeros((3, 1))

    for j in range(3):
        prefix = signal[i + j * package_length: i + j * package_length + prefix_length]
        tmp_start_prefix_positions[j, 0] = i + j * package_length

        copy_probe_block = signal[i + j * package_length + frame_length:
                                  i + j * package_length + frame_length + prefix_length]

        corr = get_correlation(prefix, copy_probe_block)
        max_corr_group += np.mean(corr)

    if max_corr_group > max_correlation:
        max_correlation = max_corr_group
        start_prefix_positions = tmp_start_prefix_positions

# Wykres
plt.figure(figsize=(10, 6))
plt.plot(signal, "b-", label='Sygnał')
for i in range(3):
    plt.plot(start_prefix_positions[i, 0], 0, 'y*', label='Początek prefiksu' if i == 0 else "")
plt.title('Znalezienie początku prefiksu')
plt.xlabel('Indeks próbki')
plt.ylabel('Amplituda')
plt.legend()
plt.grid(True)
plt.show()
