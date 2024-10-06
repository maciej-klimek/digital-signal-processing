close all; clear all;

%% Dane
[x, fpr] = audioread('DontWorryBeHappy.wav');
x = double( x );
x = x(:, 1); % przetwarzamy lewy kanal
%x = x(1:1024);

%% Okno analizy i syntezy
%N = 32; %128 % dlugosc okna w probkach
N = 128;
n = 0:N-1;
h = sin(pi*(n+0.5)/N);  %okno analizy i syntezy

figure;
plot(n, h)
hold all
grid
title("Okno analizy i syntezy")
xlabel("Próbki"); ylabel("Amplituda");

%% Macierz analizy Modified DCT
A = zeros(N/2, N); 
for k = 1:N/2 
    A(k, :) = sqrt(4/N)*cos(2*pi/N*(k-1+0.5)*(n+0.5+N/4));
end

%% Macierz syntezy (transponowanie macierzy analizy)
S = A';

%% Takie tam działania 
%pozbywamy się częstotliwości mniej znaczących
% Q - współczynnik skalujący
Q = 70; % około 70 już jest git

% Wypełnienie y i referencyjnego zerami o długości sygnału
y = zeros(1, length(x));
dref = y;
for i=1:N/2:length(x)-N
    %Pobranie próbki o długości okna
    probka = x(i:i+N-1);
    %Okienkowanie; mnożenie z oknem
    okienkowany = probka'.*h;
    %Analiza; mnożenie z macieżą analizy
    analizowany = A*okienkowany';
    %Kwantyzacja
%     kwantyzowany = kwantyzacja_mono(analizowany, Q);
    kwantyzowany = round(analizowany*Q);
    %Synteza; mnożenie z znalizą syntezy
    syntezowany = S*kwantyzowany;
    %Okienkowanie ponowne
    odokienkowany = h.*syntezowany';
    %Zapisywanie do sygnału
    y(i:i+N-1) = y(i:i+N-1) + odokienkowany;
    
    %Rwferencja bez kwantyzacji
    syntezowany = S*analizowany;
    odokienkowany = h.*syntezowany';
    dref(i:i+N-1) = dref(i:i+N-1) + odokienkowany;
end

%Zmniejszanie amplitudy. Pomaga ukryć szumy
y = y/Q;

%% Błąd
error_signal = x - y';
max_error = max(abs(error_signal));
mean_error = mean(abs(error_signal));
disp(['Max Error: ', num2str(max_error)])
disp(['Mean Error: ', num2str(mean_error)])

%% Wykresy
n=1:length(x);

figure;
hold all;
plot(n, x, 'k')  % sygnał oryginalny na czarno
plot(n, y, 'g*'); % sygnał zrekonstruowany na zielono
title('Sygnał oryginalny vs po odkodowaniu z MDCT');
legend('Referencyjny', 'Zrekonstruowany')

figure;
plot(n, error_signal, 'r') % wykres błędu na czerwono
title('Błąd między sygnałem oryginalnym a odtworzonym');
xlabel('Próbki'); ylabel('Amplituda błędu');
grid on;

%% Słuchanie
soundsc(y, fpr)
