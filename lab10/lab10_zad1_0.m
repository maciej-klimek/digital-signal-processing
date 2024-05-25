% ----------------------------------------------------------
% Tabela 19-4 (str. 567)
% Ćwiczenie: Kompresja sygnału mowy według standardu LPC-10
% ----------------------------------------------------------

clear;
close all;

[x, fpr] = audioread('mowa1.wav');  % wczytaj sygnał mowy (cały)
oryginalny = x;
bezdzw = 80700:81400; % głoska bezdźwięczna (Przy!ci!sku...)
dzw = 3000:3700; % głoska dźwięczna (!M!aterial kursu...)

% Wyświetl sygnał i wybrane głoski
figure(1);
subplot(3,1,1);
plot((1:length(x))/fpr, x); title('Sygnał mowy');

subplot(3,1,2);
plot(dzw/fpr, x(dzw)); title('Głoska dźwięczna');

subplot(3,1,3);
plot(bezdzw/fpr, x(bezdzw)); title('Głoska bezdźwięczna');

% Widma gęstości mocy
figure(2);
subplot(2,1,1);
hpsdd1 = dspdata.psd(abs(x(dzw)), 'Fs', fpr);
plot(hpsdd1); title('Widmo gęstości mocy - głoska dźwięczna przed preemfazą');

subplot(2,1,2);
hpsdb1 = dspdata.psd(abs(x(bezdzw)), 'Fs', fpr);
plot(hpsdb1); title('Widmo gęstości mocy - głoska bezdźwięczna przed preemfazą');

% soundsc(x,fpr);  % oraz odtwórz na głośnikach (słuchawkach)

% Okno Hamminga
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

% Preemfaza - filtracja wstępna
x = filter([1 -0.9735], 1, x);

% Podpunkt a
figure(3);
subplot(3,1,1);
plot((1:length(x))/fpr, x); title('Sygnał mowy po preemfazie');

subplot(3,1,2);
plot(dzw, oryginalny(dzw), dzw, x(dzw)); title('Głoska dźwięczna przed i po preemfazie');
legend('przed', 'po');

subplot(3,1,3);
plot(bezdzw, oryginalny(bezdzw), bezdzw, x(bezdzw)); title('Głoska bezdźwięczna przed i po preemfazie');
legend('przed', 'po');

figure(4);
hpsdd2 = dspdata.psd(abs(x(dzw)), 'Fs', fpr);
hpsdb2 = dspdata.psd(abs(x(bezdzw)), 'Fs', fpr);

subplot(2,1,1);
plot(hpsdd2); title('Widmo gęstości mocy - głoska dźwięczna po preemfazie');

subplot(2,1,2);
plot(hpsdb2); title('Widmo gęstości mocy - głoska bezdźwięczna po preemfazie');

for nr = 1:Nramek

    % pobierz kolejny fragment sygnału
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

    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
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
    H = freqz(1, [1; a]);  % oblicz jego odpowiedź częstotliwościową

    % SYNTEZA - odtwórz na podstawie parametrów ----------------------------------------------------------------------
    % T = 0; % usuń pierwszy znak '%' i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    aa = quantize_coefficients(a);

    if (T ~= 0) 
        gdzie = gdzie - Mstep; 
    end  % 'przenieś' pobudzenie dźwięczne
    for n = 1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if (T == 0)
            pob = 2 * (rand(1, 1) - 0.5); 
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

plot(s); title('Mowa zsyntezowana');  %pause
soundsc(s, fpr)

function q = quantize_coefficients(a)
    % Quantize the coefficients using scaling and rounding
    q = zeros(size(a));
    q(1:2) = round(a(1:2) * 256) / 256;  % Quantize to 8 bits (256 levels)
    q(3:6) = round(a(3:6) * 64) / 64;    % Quantize to 6 bits (64 levels)
    q(7:10) = round(a(7:10) * 16) / 16;  % Quantize to 4 bits (16 levels)
end
