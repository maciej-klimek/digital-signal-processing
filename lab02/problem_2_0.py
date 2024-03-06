import numpy as np

def generate_DCT(N):
    s = np.sqrt(1/N)
    w = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                w[k, n] = np.sqrt(1/N)
            else:
                w[k, n] = np.sqrt(2/N) * np.cos((np.pi * k * (2*n + 1)) / (2 * N))
    return w

def check_orthonormality(matrix):
    N = len(matrix)
    for i in range(N):
        for j in range(i+1, N):
            dot_product = np.dot(matrix[i], matrix[j])

            if i == j:
                # dla tej samej pary wektorów oczekujemy wartości 1
                if not np.isclose(dot_product, 1):
                    return False
            else:
                # dla różnych wektorów oczekujemy wartości 0
                if not np.isclose(dot_product, 0):
                    return False
    return True

size = 20

A = generate_DCT(size)
S = np.transpose(A)
I = np.dot(S, A)


if np.allclose(I, np.eye(size)):
    print("Iloczyn AS jest macierzą identycznościową.")
else:
    print("Iloczyn AS nie jest macierzą identycznościową.")

print()

x_rand = np.random.rand(size)
print("Sygnał wygenerowany losowo: ", x_rand)

x_rand_A = np.dot(A, x_rand)
x_rec = np.dot(S, x_rand_A)
print("Sygnał zrekonstruowany: ", x_rec)

rec_error = np.max(np.abs(x_rand - x_rec))
                   
print()                   
print(f"Błąd rekonstrukcji wynosi: {rec_error}.")

if np.allclose(x_rec, x_rand):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")



