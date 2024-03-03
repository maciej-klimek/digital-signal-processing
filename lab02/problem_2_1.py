import numpy as np

# tylko po to żeby wyświetlać długi format liczb
np.set_printoptions(suppress=True, floatmode='fixed')

def generate_DCT(N):
    s = np.sqrt(1/N)
    w = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                w[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))
            else:
                w[k, n] = np.sqrt(2/N) * np.cos(np.pi * k / N * (n + 0.5))
    return w

size = 20

# Wygenerowanie losowej macierzy kwadratowej A za pomocą funkcji randn() dla N=20
A_rand = np.random.randn(size, size)
print("A_rand: ", A_rand)

# Sprawdzenie ortonormalności wierszy macierzy A
row_norms = np.linalg.norm(A_rand, axis=1)
if np.allclose(row_norms, 1):
    print("Wiersze macierzy A są ortonormalne.")
else:
    print("Wiersze macierzy A nie są ortonormalne.")

# Wyznaczenie macierzy odwrotnej S=inv(A)
S_rand = np.linalg.inv(A_rand)
print("S_rand: ", S_rand)

# Sprawdzenie czy AS jest macierzą identycznościową
I = np.dot(A_rand, S_rand)
print("I: ", I)
if np.allclose(I, np.eye(size)):
    print("Iloczyn AS jest macierzą identycznościową.")
else:
    print("Iloczyn AS nie jest macierzą identycznościową.")


input()

# Wygenerowanie losowego sygnału x_random
x_rand = np.random.randn(size)
print("x_rand: ", x_rand)

# Analiza sygnału x_random
y_rand = np.dot(A_rand, x_rand)
print("y_rand: ", y_rand)

# Rekonstrukcja sygnału x_random
x_rec = np.dot(S_rand, y_rand)
print("x_rec: ", x_rec)

# Sprawdzenie czy rekonstrukcja jest dokładna
if np.allclose(x_rec, x_rand):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")
