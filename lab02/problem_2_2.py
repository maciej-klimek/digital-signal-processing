import numpy as np

# TO TRZEBA NAPRAWIC

# tylko po to żeby wyświetlać długi format liczb
np.set_printoptions(suppress=True, floatmode='fixed')

# Funkcja do generowania "zepsutej" macierzy DCT
def generate_bad_DCT(N):
    s = np.sqrt(1/N)
    w_bad = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                w_bad[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))
            else:
                w_bad[k, n] = np.sqrt(2/N) * np.cos(np.pi * (k + 0.25) / N * (n + 0.5))  # Zastąpienie "k" przez "k + 0.25"
    return w_bad

# Rozmiar macierzy DCT
size = 20

# Generowanie "zepsutej" macierzy DCT
A_bad = generate_bad_DCT(size)

# Sprawdzenie ortogonalności macierzy A_bad
# Przechowywane jako funkcja, aby uniknąć duplikacji kodu
def check_orthogonality(matrix):
    num_rows = matrix.shape[0]
    for i in range(num_rows):
        for j in range(i+1, num_rows):
            dot_product = np.dot(matrix[i], matrix[j])
            if not np.isclose(dot_product, 0):
                return False
    return True

if check_orthogonality(A_bad):
    print("Macierz A_bad jest ortogonalna.")
else:
    print("Macierz A_bad nie jest ortogonalna.")

# Generowanie losowej macierzy kwadratowej A_rand za pomocą funkcji randn() dla N=20
A_rand = np.random.randn(size, size)
print("A_rand: ", A_rand)

# Sprawdzenie ortonormalności wierszy macierzy A_rand
row_norms = np.linalg.norm(A_rand, axis=1)
if np.allclose(row_norms, 1):
    print("Wiersze macierzy A_rand są ortonormalne.")
else:
    print("Wiersze macierzy A_rand nie są ortonormalne.")

# Wyznaczenie macierzy odwrotnej S_rand=inv(A_rand)
S_rand = np.linalg.inv(A_rand)
print("S_rand: ", S_rand)

# Sprawdzenie czy iloczyn AS_rand jest macierzą identycznościową
I = np.dot(A_rand, S_rand)
print("I: ", I)
if np.allclose(I, np.eye(size)):
    print("Iloczyn AS_rand jest macierzą identycznościową.")
else:
    print("Iloczyn AS_rand nie jest macierzą identycznościową.")

input()

# Generowanie losowego sygnału x_rand
x_rand = np.random.randn(size)
print("x_rand: ", x_rand)

# Analiza sygnału x_rand
y_rand = np.dot(A_rand, x_rand)
print("y_rand: ", y_rand)

# Rekonstrukcja sygnału x_rand
x_rec = np.dot(S_rand, y_rand)
print("x_rec: ", x_rec)

# Sprawdzenie czy rekonstrukcja jest dokładna
if np.allclose(x_rec, x_rand):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")
