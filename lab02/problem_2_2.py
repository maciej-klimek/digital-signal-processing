import numpy as np

def generate_bad_DCT(N):
    s = np.sqrt(1/N)
    w = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                w[k, n] = np.sqrt(1/N)
            else:
                w[k, n] = np.sqrt(2/N) * np.cos((np.pi * (k+ 0.25) * (2*n + 1)) / (2 * N))
    return w
size = 20

A_bad = generate_bad_DCT(size)

def check_orthogonality(matrix):
    return np.allclose(np.dot(matrix, matrix.T), np.eye(matrix.shape[0]))

if check_orthogonality(A_bad):
    print("Macierz A_bad jest ortogonalna.")
else:
    print("Macierz A_bad nie jest ortogonalna.")

print()


# generowanie losowego sygnalu i proba rekonstrukcji
x_rand = np.random.randn(size)

y= np.dot(A_bad, x_rand)
S = np.linalg.inv(A_bad)
x_rec = np.dot(S, y)

if np.allclose(x_rec, x_rand):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")
