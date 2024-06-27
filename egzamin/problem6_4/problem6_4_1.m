clear all; close all;

% Parametry sygnału
fpr = 2000;                         % częstotliwość próbkowania (Hz)
T = 10;                             % czas trwania sygnału w sekundach
N = round(T * fpr);                 % liczba próbek
dt = 1 / fpr; t = dt * (0:N-1);     % oś czasu

% Generowanie sinusa
f_sin = 50; % częstotliwość sygnału sinusoidalnego
x = sin(2 * pi * f_sin * t); % sygnał sinusoidalny

% Dodawanie szumu i obliczanie widma mocy dla różnych poziomów szumu
std_noise_levels = 0:1:30;
figure;
 
try
    for std_noise = std_noise_levels
        noise = randn(1, N);                % generowanie szumu
        x_noisy = x + std_noise * noise;    % dodanie szumu
        X = fft(x_noisy);                   % obliczenie FFT
        P2 = abs(X / N).^2;                 % widmo mocy
        P1 = P2(1:N/2+1);                   % pojedyncze widmo mocy
        P1(2:end-1) = 2*P1(2:end-1);        % skalowanie
        f = fpr * (0:(N/2)) / N;            % oś częstotliwości

        subplot(2, 1, 1);
        plot(t(t >= 4 & t <= 4.3), x_noisy(t >= 4 & t <= 4.3), "r", LineWidth=3);
        hold on;
        title(['Sygnał z szumem (std = ', num2str(std_noise), ')']);
        xlabel('t (s)'); ylabel('Amplituda');
        axis("padded");
        
        subplot(2, 1, 2);
        plot(f, P1, "b:.", LineWidth=2, Marker=".", MarkerSize=15, MarkerEdgeColor="k");
        title('Widmo mocy sygnału dla różnych poziomów szumu');
        xlabel('f (Hz)'); ylabel('P(f) (V^2)');
        grid on;

        drawnow;
        pause();
    end
catch
    disp('Pętla przerwana, przechodzę do dalszej części kodu.');
end