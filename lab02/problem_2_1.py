import numpy as np

def check_orthonormality(matrix):
    N = len(matrix)
    for i in range(N):
        for j in range(i+1, N):
            dot_product = np.dot(matrix[i], matrix[j])

            if i == j:
                if not np.isclose(dot_product, 1):
                    return False
            else:
                if not np.isclose(dot_product, 0):
                    return False
    return True

N = 20
A = np.random.randn(N, N)

rows_norm = np.linalg.norm(A, axis=1)
if check_orthonormality(A) and np.allclose(rows_norm, 1):
    print("Macierz A jest ortonormalna.")

S = np.linalg.inv(A)

identity_matrix = np.eye(N)
if np.allclose(np.dot(A, S), identity_matrix):
    print("Właściwość AS == I zachowana.")

x = np.random.randn(N)
y = np.dot(A, x)
x_s = np.dot(S, y)

if np.allclose(x_s, x):
    print("Właściwość perfekcyjnej rekonstrukcji zachowana.")
