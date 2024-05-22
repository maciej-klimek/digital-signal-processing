import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

p_12 = -0.5 + 9.5j
p_34 = -1 + 10j
p_56 = -0.5 + 10.5j
z_12 = 5j
z_34 = 15j

p_array = np.array([p_12, p_34, p_56])
p_array = np.concatenate((p_array, np.conj(p_array)))

z_array = np.array([z_12, z_34])
z_array = np.concatenate((z_array, np.conj(z_array)))


plt.figure()
plt.plot(p_array.real, p_array.imag, "o")
plt.plot(z_array.real, z_array.imag, "x")
plt.grid(True)
plt.axis('equal')
plt.xlabel("Re(z)")
plt.ylabel("Im(z)")

amp = 0.42
# amp = 1

a_poly = np.poly(p_array)
b_poly = np.poly(z_array) * amp

w = np.arange(2, 18, 0.1)
s = 1j * w
H_lin = np.abs(np.polyval(b_poly, s) / np.polyval(a_poly, s))

plt.figure()
plt.plot(w, H_lin)
plt.xlabel("Frequency [rad/s]")
plt.ylabel("|H(jw)|")

plt.figure()
H_log = 20 * np.log10(H_lin)
wlog = np.logspace(0, 3, 40)
plt.plot(w, H_log, 'r')
plt.xlabel("Frequency [rad/s]")
plt.ylabel("20log10(|H(jw)|)")

plt.figure()
H_phase = np.unwrap(np.angle(np.polyval(b_poly, s) / np.polyval(a_poly, s)))
plt.plot(w, H_phase, 'g')
plt.xlabel('Frequency [rad/s]')
plt.ylabel('Phase [rad]')
plt.title('Frequency Response Phase')
plt.grid(True)

# 3D plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot(w, H_lin, H_phase, color='b')
ax.set_xlabel('Frequency [rad/s]')
ax.set_ylabel('|H(jw)|')
ax.set_zlabel('Phase [rad]')
ax.set_title('3D Frequency Response')
plt.show()
