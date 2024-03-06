import numpy as np

# tylko po to żeby wyświetlać długi format liczb
np.set_printoptions(suppress=True, floatmode='fixed')

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

size = 20
A = generate_DCT(size)

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

print(A)

if check_orthonormality(A):
    print("Macierz jest ortonormalna.")
else:
    print("Macierz nie jest ortonormalna.")
