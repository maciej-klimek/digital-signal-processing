import numpy as np
import matplotlib.pyplot as plt
import scipy.io

def get_correlation(x, y):

    n = len(x)
    m = len(y)

    x_mean = np.mean(x)
    y_mean = np.mean(y)

    x_std = np.std(x)
    y_std = np.std(y)

    result = np.zeros(n + m - 1)
    delay = np.arange(-n + 1, m)
    print(delay)

    for i in range(len(result)):
        if delay[i] < 0:
            result[i] = np.sum((x[0:n + delay[i]] - x_mean) * (y[-delay[i]:m] - y_mean))
        elif delay[i] == 0:
            result[i] = np.sum((x - x_mean) * (y - y_mean))
        else:
            result[i] = np.sum((x[delay[i]:n] - x_mean) * (y[0:m - delay[i]] - y_mean))

        result[i] = result[i] / (x_std * y_std * (n - abs(delay[i])))

    return result


x = [1, 2, 3]
y = [1, 4, 3]

get_correlation(x, y)
print(get_correlation(x, y))