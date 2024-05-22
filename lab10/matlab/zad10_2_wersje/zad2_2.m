clear all;
close all;
clc;

% Wczytywanie sygnałów
[x, fpr] = audioread('mowa1.wav');
[x2, ~] = audioread('coldvox.wav');

% Parametry
N = length(x);
Mlen = 240;  % Długość okna Hamminga
Mstep = 180; % Przesunięcie okna w czasie
Np = 10;     % Rząd filtra predykcji

% Preemfaza
x = filter([1 -0.9735], 1, x);

% Wybór dźwięcznego fragmentu mowy o stałej amplitudzie i częstotliwości tonu podstawowego
% Zakładamy, że wybrany fragment jest od indeksu 10000 do 10240
fragment = x(10000:10240);

% Obliczenie H(z) dla wybranego fragmentu
[a_fragment, e_fragment] = lpc(fragment, Np);

% Obliczenie sygnału resztkowego przez przefiltrowanie fragmentu filtrem odwrotnym
residual_signal = filter(a_fragment, 1, fragment);

% Wybór jednego okresu sygnału resztkowego jako pobudzenie
% Zakładamy, że okres wynosi 80 próbek (możesz dostosować tę wartość)
T_residual = 80;
residual_period = residual_signal(1:T_residual);

% Inicjalizacja zmiennych
s = [];  % Cała mowa zsyntezowana

% Analiza i synteza dla każdego okna
Nramek = floor((N - Mlen) / Mstep + 1);
for nr = 1 : Nramek
    n = (nr - 1) * Mstep + 1 : (nr - 1) * Mstep + Mlen;
    bx = x(n);
    bx = bx - mean(bx);

    [a, e] = lpc(bx, Np);
    r = xcorr(bx, 'coeff');
    [rmax, Tmax] = max(r(Mlen:end));
    T = Tmax;

    if rmax < 0.35 * r(Mlen)
        T = 0;
    elseif T > 80
        T = 80;
    else
        T = round(T / 2);
    end

    ss = zeros(1, Mstep);
    bs = zeros(1, Np+1);  % Bufer stanu filtra dostosowany do rzędu filtra + 1
    
    for i = 1:Mstep
        % Wybór pobudzenia w zależności od warunków
        if T == 0
            pob = 2 * x2(randi(length(x2)));  % Pobudzenie z coldvox.wav
        else
            % Zakomentuj poniższe linie zgodnie z wybranym eksperymentem
            pob = (i == T) * sqrt(e); % Standardowe pobudzenie

            % Eksperyment 1: Ignoruj decyzję V/UV (zawsze bezdźwięczne)
            % T = 0;
            % pob = 2 * x2(randi(length(x2)));

            % Eksperyment 2: Obniż dwukrotnie częstotliwość tonu podstawowego
            % if T ~= 0
            %     T = 2 * T;
            % end
            % pob = (i == T) * sqrt(e);

            % Eksperyment 3: Ustaw stałą wartość tonu podstawowego dla głosek dźwięcznych
            % if T ~= 0
            %     T = 80;
            % end
            % pob = (i == T) * sqrt(e);

            % Eksperyment 4: Ignoruj decyzję V/UV, użyj próbek z coldvox.wav
            % T = 0;
            % pob = 2 * x2(randi(length(x2)));

            % Eksperyment 5: Użyj sygnału resztkowego jako pobudzenia
            % pob = residual_period(mod(i-1, T_residual) + 1);
        end

        % Konwersja pob do wektora jednoelementowego
        pobVec = [pob];  % Używamy wektora zamiast skalaru
        [y, bs] = filter(1, [1 -a], pobVec, bs);  % Filtracja z prawidłowym stanem
        ss(i) = y;
        if i == T && T ~= 0  % Zapętlenie impulsu dla głosek dźwięcznych
            T = T + Tmax;
        end
    end
    s = [s ss];
end

% Deemfaza i odtwarzanie
s = filter(1, [1 -0.9735], s);
soundsc(s, fpr);
