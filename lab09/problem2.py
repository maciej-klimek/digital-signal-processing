import numpy as np
import soundfile as sf

def normalize(signal):
    return signal / np.max(np.abs(signal))

def LMS_filter(d, x, M, mi):
    h = np.zeros(M)
    bx = np.zeros(M)

    y = np.zeros(len(x))
    e = np.zeros(len(x))

    for n in range(len(x)):
        bx[1:] = bx[:-1]
        bx[0] = x[n]
        y[n] = np.dot(h, bx)
        e[n] = d[n] - y[n]


        h = h + mi * e[n] * bx

    return y, e, h

# Load signals
SA, samplerate = sf.read('mowa_1.wav')
SB, _ = sf.read('mowa_2.wav')
SA_G_SB, _ = sf.read('mowa_3.wav')

# Normalize signals
SA = normalize(SA)
SB = normalize(SB)
SA_G_SB = normalize(SA_G_SB)

# Parameters
M = 100
mi = 0.01

# Apply adaptive algorithm
y, e, h = LMS_filter(SA_G_SB, SB, M, mi)

# Output cleaned signal
SA_clean = y
sf.write('mowa_1_cleaned.wav', SA_clean, samplerate, subtype='PCM_16')
