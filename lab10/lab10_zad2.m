clear;
close all;

[x, fpr] = audioread('mowa1.wav');  % wczytaj sygnał mowy (cały)
oryginalny = x;
bezdzw = 80700:81400; % głoska bezdźwięczna (Przy!ci!sku...)
dzw = 3000:3700; % głoska dźwięczna (!M!aterial kursu...)

% Preemfaza - filtracja wstępna
x = filter([1 -0.9735], 1, x);

% Parametry
N = length(x);  % długość sygnału
Mlen = 240;  % długość okna Hamminga (liczba próbek)
Mstep = 180;  % przesunięcie okna w czasie (liczba próbek)
Np = 10;  % rząd filtra predykcji
gdzie = Mstep + 1;  % początkowe położenie pobudzenia dźwięcznego

lpc = [];  % tablica na współczynniki modelu sygnału mowy
s = [];  % cała mowa zsyntezowana
ss = [];  % fragment sygnału mowy zsyntezowany
bs = zeros(1, Np);  % bufor na fragment sygnału mowy
Nramek = floor((N - Mlen) / Mstep + 1);  % ile fragmentów (ramek) jest do przetworzenia

% Dekoder z różnymi wariantami pobudzenia
for nr = 1:Nramek

    % Pobierz kolejny fragment sygnału
    n = 1 + (nr - 1) * Mstep : Mlen + (nr - 1) * Mstep;
    bx = x(n);

    % Progowanie - str. 554 (570 z PDF'a)
    P = 0.3 * max(bx);
    for iii = 1:length(bx)
        if bx(iii) >= P
            bx(iii) = bx(iii) - P;
        elseif bx(iii) <= -P
            bx(iii) = bx(iii) + P;
        else
            bx(iii) = 0;
        end
    end

    % Analiza - wyznacz parametry modelu
    bx = bx - mean(bx);  % usuń wartość średnią
    for k = 0:Mlen-1
        r(k+1) = sum(bx(1:Mlen-k) .* bx(1+k:Mlen)); % funkcja autokorelacji
    end

    offset = 20; 
    rmax = max(r(offset:Mlen));  % znajdź maksimum funkcji autokorelacji
    imax = find(r == rmax);  % znajdź indeks tego maksimum
    if (rmax > 0.35 * r(1)) 
        T = imax; 
    else 
        T = 0; 
    end  % głoska dźwięczna/bezdźwięczna?

    rr(1:Np, 1) = (r(2:Np+1))';
    for m = 1:Np
        R(m, 1:Np) = [r(m:-1:2) r(1:Np-(m-1))];  % zbuduj macierz autokorelacji
    end
    a = -inv(R) * rr;  % oblicz współczynniki filtra predykcji
    wzm = r(1) + r(2:Np+1) * a;  % oblicz wzmocnienie
    H = freqz(1, [1; a]);  % oblicz jego odp. częstotliwościową

    % Warianty dekodowania
    variant = 1; % Zmień wartość na 1, 2, 3, lub 4 aby wybrać odpowiedni wariant

    switch variant
        case 1
            T = 0;  % Zawsze bezdźwięczne
        case 2
            if T ~= 0
                T = 2 * T;  % Obniż dwukrotnie częstotliwość tonu podstawowego
            end
        case 3
            if T ~= 0
                T = 80;  % Ustaw stałą wartość tonu podstawowego
            end
        case 4
            T = 0;  % Użyj próbek z pliku coldvox.wav
            [coldvox, ~] = audioread('coldvox.wav');
    end

    % SYNTEZA - odtwórz na podstawie parametrów
    aa = quantize_coefficients(a);

    if (T ~= 0) 
        gdzie = gdzie - Mstep; 
    end  % 'przenieś' pobudzenie dźwięczne
    for n = 1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if (T == 0)
            if variant == 4
                pob = coldvox(mod(n-1, length(coldvox)) + 1);  % Pobudzenie z coldvox.wav
            else
                pob = 2 * (rand(1, 1) - 0.5);  % Pobudzenie szumowe
            end
            gdzie = (3/2) * Mstep + 1;  % pobudzenie szumowe
        else
            if (n == gdzie) 
                pob = 1; 
                gdzie = gdzie + T;  % pobudzenie dźwięczne
            else 
                pob = 0; 
            end
        end
        ss(n) = wzm * pob - bs * aa;  % filtracja 'syntetycznego' pobudzenia

        bs = [ss(n) bs(1:Np-1)];  % przesunięcie bufora wyjściowego
    end
    s = [s ss];  % zapamiętanie zsyntezowanego fragmentu mowy
end

s = filter(1, [1 -0.9735], s);  % filtracja (deemfaza) - filtr odwrotny - opcjonalny

plot(s); title('mowa zsyntezowana');  %pause
soundsc(s, fpr)


% Obliczanie sygnału resztkowego

% Zakładając, że 'oryginalny' zawiera nagranie oryginalnego sygnału mowy,
% gdzie zawiera nagranie oryginalnego sygnału mowy
% Zakładamy, że 'oryginalny' zawiera nagranie oryginalnego sygnału mowy,
% 'fpr' jest częstotliwością próbkowania

% Wybierz dźwięczny fragment mowy o stałej amplitudzie i częstotliwości tonu podstawowego
dzw_amplituda = mean(abs(oryginalny(dzw)));
dzw_czestotliwosc = 200; % Załóżmy, że częstotliwość tonu podstawowego to 200 Hz

% Wygeneruj sygnał o zadanej amplitudzie i częstotliwości
t = (0:length(dzw)-1) / fpr; % Czas trwania sygnału w sekundach
sygnal_dzw = dzw_amplituda * sin(2*pi*dzw_czestotliwosc*t);

% Obliczanie transmitancji H(z)
A = [1 0.2 -0.6]; % Przykładowe współczynniki transmitancji
B = [1 -0.5 0.7]; % Przykładowe współczynniki transmitancji
H_z = freqz(B, A, length(sygnal_dzw));

% Przefiltrowanie transmitancji odwrotnym filtrem
H_z_odwrotny = freqz(A, B, length(sygnal_dzw));
sygnal_resztkowy = filter(B, A, sygnal_dzw);

% Wyświetlenie sygnału resztkowego
figure;
subplot(2,1,1);
plot(sygnal_dzw);
title('Sygnał dźwięczny');
xlabel('Próbki');
ylabel('Amplituda');
subplot(2,1,2);
plot(sygnal_resztkowy);
title('Sygnał resztkowy');
xlabel('Próbki');
ylabel('Amplituda');


function q = quantize_coefficients(a)
    % Quantize the coefficients using scaling and rounding
    q = zeros(size(a));
    q(1:2) = round(a(1:2) * 256) / 256;  % Quantize to 8 bits (256 levels)
    q(3:6) = round(a(3:6) * 64) / 64;    % Quantize to 6 bits (64 levels)
    q(7:10) = round(a(7:10) * 16) / 16;  % Quantize to 4 bits (16 levels)
end