import numpy as np
import matplotlib.pyplot as plt

# Algorytm radix-2 DIT (decimation in time) FFT
def fft_radix2(x):
    
    N = len(x)           # liczba próbek sygnału (potęga dwójki)
    Nbits = int(np.log2(N))  # liczba bitów potrzebna na indeksy próbek, dla N=8, Nbits=3

    # Przestawianie próbek sygnału (odwracanie bitów numeru próbki)
    n = np.arange(N)            # indeksy WSZYSTKICH próbek 

    m = [f"{i:0{Nbits}b}" for i in n]  # Generowanie binarnych indeksów
    m = [b[::-1] for b in m]  # Odwrócenie bitów
    m = np.array([int(b, 2) for b in m])  # Konwersja z binarnych indeksów na liczby dziesiętne

    y = np.zeros(N, dtype=complex)  # inicjalizacja tablicy wyjściowej
    y[m] = x                    # przestawianie danych wejściowych
    print(f"\nPrzestawione próbki: {y}\n")  # sprawdzenie wyniku
    print("------------------------------------------------------------------------------")

    # WSZYSTKIE 2-punktowe DFTs na sąsiednich parach próbek (po ich przestawieniu)
    for i in range(0, N, 2):
        temp = y[i]
        y[i] = y[i] + y[i + 1]
        y[i + 1] = temp - y[i + 1]
    print(f"Po 2-punktowych DFT: {y}\n")  # 2-punktowe widma DFT

    # Rekonstrukcja N-punktowego DFT z 2-punktowych
    # Widma DFT: 2-punktowe --> 4-punktowe --> 8-punktowe --> 16-punktowe ...
    Nx = N                       # liczba próbek (zmiana nazwy zmiennej)
    Nlevels = Nbits              # liczba etapów obliczeniowych równa log2(Nx)
    N = 2                        # początkowa długość DFT po 2-punktowych DFT
    for lev in range(1, Nlevels):        # następny ETAP
        N = 2 * N                      # nowa długość widma DFT po połączeniu 
        Nblocks = Nx // N              # nowa liczba widm DFT po połączeniu 
        W = np.exp(-2j * np.pi / N * np.arange(N // 2))  # korekta stosowana na tym etapie
        for k in range(Nblocks):                # następny BLOK dwóch DFT
            for j in range(N // 2):
                idx = k * N + j
                temp = y[idx]
                y[idx] = temp + W[j] * y[idx + N // 2]
                y[idx + N // 2] = temp - W[j] * y[idx + N // 2]
        print(f"Po etapie {lev + 1}: {y}\n")  # wyniki po każdym etapie
    return y


# ------------------------------------------------- Wywołanie funkcji ----------------------------------------------
N = 8
x = np.arange(N)  # przykładowy sygnał, np. inny wybór x = np.random.randn(N)
x = np.random.randn(N)

y_radix2 = fft_radix2(x)
y_numpy = np.fft.fft(x)

# Obliczenie błędu
error = np.max(np.abs(y_numpy - y_radix2))
print("------------------------------------------------------------------------------")
print(f"Błąd: {error}")
print(f"Wynik FFT (radix-2): {y_radix2}")
print(f"Wynik FFT (numpy): {y_numpy}")




# ------------------------------------------------- Plotowanie widm -------------------------------------------------
plt.figure(figsize=(12, 6))

# Część rzeczywista
plt.subplot(2, 1, 1)
markers_radix2, stemlines_radix2, baseline_radix2 = plt.stem(np.real(y_radix2), linefmt='b-', markerfmt='bo', basefmt='r-', label='Radix-2 FFT')
markers_numpy, stemlines_numpy, baseline_numpy = plt.stem(np.real(y_numpy), linefmt='y--', markerfmt='yo', basefmt='r-', label='Numpy FFT')
plt.setp(stemlines_radix2, 'linewidth', 4)
plt.setp(stemlines_numpy, 'linewidth', 2)
plt.title('Część rzeczywista')
plt.legend()

# Część urojona
plt.subplot(2, 1, 2)
markers_radix2_imag, stemlines_radix2_imag, baseline_radix2_imag = plt.stem(np.imag(y_radix2), linefmt='b-', markerfmt='bo', basefmt='r-', label='Radix-2 FFT')
markers_numpy_imag, stemlines_numpy_imag, baseline_numpy_imag = plt.stem(np.imag(y_numpy), linefmt='y--', markerfmt='yo', basefmt='r-', label='Numpy FFT')
plt.setp(stemlines_radix2_imag, 'linewidth', 4)
plt.setp(stemlines_numpy_imag, 'linewidth', 2)
plt.title('Część urojona')
plt.legend()

plt.tight_layout()
plt.show()
