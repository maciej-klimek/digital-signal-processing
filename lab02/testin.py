import numpy as np

w1 = np.array([0, 0, 1, 0, 0, 0, 0, 0])      # Wektor 1
w2 = np.array([0, 0, 0, 0, 1, 0, 0, 0])      # Wektor 2
w12 = w1 * w2                                # Iloczyn odpowiadających sobie próbek
prod1 = np.sum(w12)                          # '0' oznacza że wektory są ortogonalne
prod2 = np.dot( w1, w2 )                     # w przestrzeni Euklidesowej
prod3 = w1 @ w2                              # skrótwa wersja np.matmul(a,b)

print(prod1)
print(prod2)
print(prod3)