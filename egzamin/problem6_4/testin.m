clear all; close all;

% Parametry sygnału
fpr = 2000; % częstotliwość próbkowania (Hz)
T = 10; % czas trwania sygnału w sekundach
N = round(T * fpr); % liczba próbek
dt = 1 / fpr; t = dt * (0:N-1); % oś czasu

% Generowanie sygnału sinusoidalnego z szumem
f_sin = 50; % częstotliwość sygnału sinusoidalnego
x = sin(2 * pi * f_sin * t); % sygnał sinusoidalny

% Dodawanie szumu i obliczanie widma mocy dla różnych poziomów szumu
std_noise_levels = 0:1:20; % poziomy odchylenia standardowego szumu
figure;

try
    for std_noise = std_noise_levels
        noise = randn(1, N); % generowanie szumu
        x_noisy = x + std_noise * noise; % dodanie szumu
        X = fft(x_noisy); % obliczenie FFT
        P2 = abs(X / N).^2; % widmo mocy
        P1 = P2(1:N/2+1); % pojedyncze widmo mocy
        P1(2:end-1) = 2*P1(2:end-1); % skalowanie
        f = fpr * (0:(N/2)) / N; % oś częstotliwości

        subplot(2, 1, 1);
        plot(t(t >= 4 & t <= 5), x_noisy(t >= 4 & t <= 5)); % rysowanie sygnału z szumem
        title(['Sygnał z szumem (std = ', num2str(std_noise), ')']);
        xlabel('t (s)'); ylabel('Amplituda');

        subplot(2, 1, 2);
        plot(f, P1); % rysowanie widma mocy
        title('Widmo mocy sygnału dla różnych poziomów szumu');
        xlabel('f (Hz)'); ylabel('P(f) (V^2)');
        grid on;

        drawnow;
        pause(); % TUTAJ, używając live scriptu, zrób tak, że kiedy przerwę tę pętlę, dane z niej się zapiszą i zacznie się wykonywać reszta kodu
    end
catch
    disp('Pętla przerwana, przechodzę do dalszej części kodu.');
end

% Zwiększenie długości sygnału
T_long = 100; % czas trwania długiego sygnału w sekundach
N_long = round(T_long * fpr); % liczba próbek dla długiego sygnału
t_long = dt * (0:N_long-1); % oś czasu dla długiego sygnału
x_long = sin(2 * pi * f_sin * t_long); % długi sygnał sinusoidalny
x_noisy_long = x_long + std_noise * randn(1, N_long); % dodanie szumu do długiego sygnału

% Podział na mniejsze fragmenty i średnie widmo mocy
fragment_length = 1 * fpr; % długość fragmentu (1 sekunda)
num_fragments = floor(N_long / fragment_length);
P_avg = zeros(1, fragment_length/2+1);

% Obliczenie oś częstotliwości dla długiego sygnału
f_frag_long = fpr * (0:(fragment_length/2)) / fragment_length;

figure;
for i = 1:num_fragments
    fragment = x_noisy_long((i-1)*fragment_length + 1:i*fragment_length);
    X_frag = fft(fragment);
    P2_frag = abs(X_frag / fragment_length).^2;
    P1_frag = P2_frag(1:fragment_length/2+1);
    P1_frag(2:end-1) = 2*P1_frag(2:end-1);
    P_avg = P_avg + P1_frag;

    % Plotowanie fragmentu sygnału
    subplot(3, 1, 1);
    plot(t_long((i-1)*fragment_length + 1:i*fragment_length), fragment);
    title(['Fragment sygnału ', num2str(i)]);
    xlabel('t (s)'); ylabel('Amplituda');
    grid on;

    % Plotowanie widma mocy fragmentu
    subplot(3, 1, 2);
    plot(f_frag_long, P1_frag);
    title(['Widmo mocy fragmentu ', num2str(i)]);
    xlabel('f (Hz)'); ylabel('P(f) (V^2)');
    grid on;

    % Obliczenie średniego widma mocy z uwzględnieniem wszystkich fragmentów do aktualnego
    P_avg_current = P_avg / i;

    % Plotowanie średniego widma mocy
    subplot(3, 1, 3);
    plot(f_frag_long, P_avg_current);
    title('Średnie widmo mocy ze wszystkich przetworzonych fragmentów');
    xlabel('f (Hz)'); ylabel('P(f) (V^2)');
    grid on;

    drawnow;
    pause(); % Pauza między rysowaniem kolejnych fragmentów
end

% Ostateczne obliczenie średniego widma mocy
P_avg = P_avg / num_fragments;
f_frag_long = fpr * (0:(fragment_length/2)) / fragment_length;

% Wyświetlenie sygnału i średniego widma mocy
figure;
subplot(2, 1, 1);
plot(t_long, x_noisy_long);
title('Długi sygnał z szumem');
xlabel('t (s)'); ylabel('Amplituda');
grid on;

subplot(2, 1, 2);
plot(f_frag_long, P_avg);
title('Średnie widmo mocy z wielu fragmentów sygnału');
xlabel('f (Hz)'); ylabel('P(f) (V^2)');
grid on;
