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

def check_orthonormality(matrix):
    num_of_rows = matrix.shape[0]
    for i in range(num_of_rows):
        for j in range(i+1, num_of_rows):
            dot_product = np.dot(matrix[i], matrix[j])      # iloczyn skalarny dwóch rzędów
            if not np.isclose(dot_product, 0):              # sprawdza czy = 0 (taka funkcja przez potencjalnie blędy przy obliczeniach zmiennoprzecinkowych)
                return False
    return True

print(A)

if check_orthonormality(A):
    print("Wszystkie wektory (wiersze macierzy) są do siebie ortonormalne.")
else:
    print("Wszystkie wektory (wiersze macierzy) nie są do siebie ortonormalne.")
