import numpy as np
import matplotlib.pyplot as plt
import scipy.io

def get_correlation(x, y):

    n = len(x)
    m = len(y)

    x_mean = np.mean(x)
    y_mean = np.mean(y)

    x_std = np.std(x)       # odchylenie standardowe dwóch arrayow
    y_std = np.std(y)

    result_array = np.zeros(n + m - 1)
    shift_positions = np.arange(-n + 1, m)      # array zawierający przesunięcia z jakimi będziemy badać x i y

    # dla każdego opóźnienia : 
    for i in range(len(shift_positions)):      
        if shift_positions[i] < 0:
            result_array[i] = np.sum((x[0:n + shift_positions[i]] - x_mean) * (y[-shift_positions[i]:m] - y_mean))      # obliczamy sume iloczynu znormalizowanych punktów x i y
        elif shift_positions[i] == 0:
            result_array[i] = np.sum((x - x_mean) * (y - y_mean))
        else:
            result_array[i] = np.sum((x[shift_positions[i]:n] - x_mean) * (y[0:m - shift_positions[i]] - y_mean))

        result_array[i] = result_array[i] / (x_std * y_std * (n - abs(shift_positions[i])))     # i dzielimy przez odchylenie standardowe dwoch arrayow

    return result_array

data = scipy.io.loadmat('adsl_x.mat')
signal = np.array(data['x'])

prefix_length = 32
frame_length = 512
package_length = prefix_length + frame_length

max_correlation = 0
prefix_positions = np.zeros((3, 1))       # wiemy że są 3 prefiksy - trzeba znalezc takie pozycje startu prefixow, dla których suma 3 korelancji będzie najbliższa 1 (najwieksza)

for i in range(len(signal) // 3):               # wiemy że sygnał składa sie z powtarzających sie bloków (jeden po drugim), wiec badając jego 1/3 w praktyce zbadamy cały
    if (i + 3 * package_length) > len(signal):
        break
    max_corr_group = 0
    tmp_positions = np.zeros((3, 1))

    for j in range(3):          # sprawdzamy 3 kolejne potencjalne prefiksy
        prefix = signal[i + j * package_length: i + j * package_length + prefix_length]
        # print(prefix)
        tmp_positions[j, 0] = i + j * package_length 

        shifted_data_block = signal[i + j * package_length + frame_length:                  # !!! blok danych przesunięty o dlugosc całej ramki - clue algorytmu - sprawdzamy suma 3 korelancji
                                  i + j * package_length + frame_length + prefix_length]

        corr = get_correlation(prefix, shifted_data_block)
        # print(np.mean(corr))
        max_corr_group += np.mean(corr)

    if max_corr_group > max_correlation:        
        max_correlation = max_corr_group
        prefix_positions = tmp_positions
    # print(max_correlation)

# Wykres
plt.figure(figsize=(10, 6))
plt.plot(signal, "b-", label='Sygnał')
for i in range(3):
    plt.plot(prefix_positions[i, 0], 0, 'y*', label='Początek prefiksu' if i == 0 else "")
plt.title('Znalezienie początku prefiksu')
plt.xlabel('Indeks próbki')
plt.ylabel('Amplituda')
plt.legend()
plt.grid(True)
plt.show()
