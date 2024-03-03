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
A = generate_DCT(size)
print("A: ", A)

# generowanie macierzy odwrotnej IDCT, przez transpozycję macierzy A
S = A.T
print("S: ", S)

# sprawdzenie czy iloczyn S * A == I (macierz identycznosci)
I = np.dot(S, A)
print("I: ", I)
if np.allclose(I, np.eye(size)):        # funkcja allclose żeby uniknąć potencjalnych błędów przez operacje zmiennoprzecinkowe
    print("Iloczyn S * A jest macierzą identycznościową.")
else:
    print("Iloczyn S * A nie jest macierzą identycznościową.")

input()

x = np.random.randn(size)   # generowanie losowego sygnału x
print("x: ", x)

y = np.dot(A, x)            # analiza sygnału x 
print("y: ", y)

x_rec = np.dot(S, y)        # rekonstrukcja sygnału
print("x_rec: ", x_rec)

if np.allclose(x_rec, x):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")
