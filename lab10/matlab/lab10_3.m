clear all;
close all;
clc;

% Wczytywanie sygnałów
[x, fpr] = audioread('mowa1.wav');

% Parametry
N = length(x);
Mlen = 240;  % Długość okna Hamminga
Mstep = 180; % Przesunięcie okna w czasie
Np = 10;     % Rząd filtra predykcji

% Preemfaza
x = filter([1 -0.9735], 1, x);

% Inicjalizacja zmiennych
s = [];  % Cała mowa zsyntezowana

% Analiza i synteza dla każdego okna
Nramek = floor((N - Mlen) / Mstep + 1);
for nr = 1:Nramek
    n = (nr - 1) * Mstep + 1 : (nr - 1) * Mstep + Mlen;
    bx = x(n);
    bx = bx - mean(bx);

    % Obliczenie LPC i energii predykcji
    [a, e] = lpc(bx, Np);

    % Obliczenie sygnału resztkowego przez przefiltrowanie fragmentu filtrem odwrotnym
    residual_signal = filter(a, 1, bx);

    % Normalizacja sygnału resztkowego
    residual_signal = residual_signal / max(abs(residual_signal));
    
    % Synteza mowy przy użyciu sygnału resztkowego jako pobudzenie
    ss = filter(1, a, residual_signal);

    % Łączenie przetworzonych ramek w całość
    s = [s; ss(Mstep+1:Mlen)];
end

% Deemfaza i odtwarzanie
s = filter(1, [1 -0.9735], s);
soundsc(s, fpr/2);

% Wyświetlenie wyników
figure;
plot(s);
title('Syntezowany sygnał mowy');
xlabel('Próbka');
ylabel('Amplituda');

% Wyświetlenie sygnału resztkowego dla przykładowej ramki
figure;
plot(residual_signal);
title('Sygnał resztkowy dla przykładowej ramki');
xlabel('Próbka');
ylabel('Amplituda');

disp('Przetwarzanie zakończone.');
