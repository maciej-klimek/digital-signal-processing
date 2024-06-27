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

    % % Plotowanie kolejnych fragmentów wygnału
    % subplot(3, 1, 1);
    % plot(t_long((i-1)*fragment_length + 1:i*fragment_length), fragment, "r", LineWidth=1);
    % hold on;
    % title(sprintf('Złączone %d fragmenty.', i));
    % xlabel('t (s)'); ylabel('Amplituda');
    % axis("padded")
    % grid on;

    % Plotowanie fragmentu sygnału
    subplot(3, 1, 1);
    plot(fragment, "r", LineWidth=1);
    title(sprintf('Fragment %d', i));
    xlabel('t (s)'); ylabel('Amplituda');
    axis("padded")
    grid on;

    % Plotowanie widma mocy fragmentu
    subplot(3, 1, 2);
    plot(f_frag_long, P1_frag, "b:.", LineWidth=2, Marker=".", MarkerSize=15);
    title(['Widmo mocy fragmentu ', num2str(i)]);
    xlabel('f (Hz)'); ylabel('P(f) (V^2)');
    grid on;

    % Obliczenie średniego widma mocy
    P_avg_current = P_avg / i;

    subplot(3, 1, 3);
    plot(f_frag_long, P_avg_current, "m:.", LineWidth=3, Marker=".", MarkerSize=20, MarkerEdgeColor="k");
    title('Średnie widmo mocy ze wszystkich przetworzonych fragmentów');
    xlabel('f (Hz)'); ylabel('P(f) (V^2)');
    grid on;

    drawnow;
    pause(); % Pauza między rysowaniem kolejnych fragmentów
end

% Ostateczne obliczenie średniego widma mocy
P_avg = P_avg / num_fragments;
f_frag_long = fpr * (0:(fragment_length/2)) / fragment_length;

% Plotowanie sygnału i średniego widma mocy
figure;
subplot(2, 1, 1);
plot(t_long, x_noisy_long, "r");
title('Długi sygnał z szumem');
xlabel('t (s)'); ylabel('Amplituda');
grid on;

subplot(2, 1, 2);
plot(f_frag_long, P_avg, "m:.", LineWidth=3, Marker=".", MarkerSize=20, MarkerEdgeColor="k");
title('Średnie widmo mocy z wielu fragmentów sygnału');
xlabel('f (Hz)'); ylabel('P(f) (V^2)');
grid on;