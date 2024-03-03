import numpy as np
import matplotlib.pyplot as plt
import scipy.io


print(np.correlate([1, 2, 3], [0, 1, 0.5]),

np.correlate([1, 2, 3], [0, 1, 0.5], "same"),

np.correlate([1, 2, 3], [0, 1, 0.5], "full"))
