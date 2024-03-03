import numpy as np
import matplotlib.pyplot as plt

sin_amplitude = 230
bckg_sin_frequency = 10000
sampling_frequency = 100
duration = 1

bckg_time_domain = np.arange(0, duration, 1/bckg_sin_frequency)
time_domain = np.arange(0, duration, 1/sampling_frequency)

plt.figure(figsize=(10, 6))
plot_handle = None

for sin_frequency in range(0, 301, 5):
    bckg_sin = sin_amplitude * \
        np.sin(2 * np.pi * sin_frequency * bckg_time_domain)
    sample_values = sin_amplitude * \
        np.sin(2 * np.pi * sin_frequency * time_domain)

    plt.clf() 
    plt.plot(bckg_time_domain, bckg_sin, "-", color="#bababa",  label="Poglądawy wykres")
    
    plt.plot(time_domain, sample_values, "r-", label=f"Sygnał spróbkowany")
    plt.scatter(time_domain, sample_values, color='red')

    plt.title(f"PRZEBIEG {sin_frequency//5 + 1}: Sinus o częstotliwości {sin_frequency}Hz, próbkowany z częstotliwością {sampling_frequency}Hz")
    plt.xlabel("Czas [s]")
    plt.ylabel("Amplituda [V]")
    plt.legend()
    plt.grid(True)

    plt.draw() 
    plt.waitforbuttonpress()  

plt.show() 

