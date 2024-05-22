clc; clear all; clf; close all;

[x,fpr]=audioread('mowa1.wav'); % wczytaj sygnał mowy (cały)
[cv, fpr2] = audioread('coldvox.wav');
figure(1)
plot(x); title('sygnał mowy'); % pokaż go oraz odtwórz na głośnikach (słuchawkach)
% soundsc(x, fpr);

N=length(x); % długość sygnału
Mlen=240; % długość okna Hamminga (liczba próbek)
Mstep=180; % przesunięcie okna w czasie (liczba próbek)
Np=8; % rząd filtra predykcji
gdzie=Mstep+1; % początkowe położenie pobudzenia dźwięcznego

lpc=[]; % tablica na współczynniki modelu sygnału mowy
s=[]; % cała mowa zsyntezowana
ss=[]; % fragment sygnału mowy zsyntezowany
bs=zeros(1,Np); % bufor na fragment sygnału mowy
Nramek=floor((N-Mlen)/Mstep+1); % ile fragmentów (ramek) jest do przetworzenia
x_preemphasized = filter([1 -0.9735], 1, x); % filtracja wstępna (preemfaza) - opcjonalna

% Dodanie wykresów czasowych i widmowych przed i po preemfazie
figure(2);
subplot(2,2,1); plot(x); title('Sygnał mowy przed preemfazą');
subplot(2,2,2); plot(abs(fft(x))); title('Widmo mowy przed preemfazą');
subplot(2,2,3); plot(x_preemphasized); title('Sygnał mowy po preemfazie');
subplot(2,2,4); plot(abs(fft(x_preemphasized))); title('Widmo mowy po preemfazie');

autokorelacje = zeros(Nramek, Mlen); % Tablica na funkcje autokorelacji
widma_filtrow = zeros(Nramek, 512); % Tablica na widma filtrów (domyślnie 512 punktów)
czestotliwosci = []; % Tablica na częstotliwości tonu podstawowego

for nr = 1 : Nramek
    
    % pobierz kolejny fragment sygnału
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    % Progowanie
    bx = bx - mean(bx); % usuń wartość średnią
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    
    % Zapamiętaj autokorelację
    autokorelacje(nr, :) = r;
    
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))]; % zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr; % oblicz współczynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a; % oblicz wzmocnienie
    H=freqz(1,[1;a]); % oblicz jego odp. częstotliwościową
    
    % Zapamiętaj widmo filtru
    widma_filtrow(nr, :) = abs(H);
    
    offset=20; rmax=max( r(offset : Mlen) ); % znajdź maksimum funkcji autokorelacji
    imax=find(r==rmax); % znajdź indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % głoska dźwięczna/bezdźwięczna?
    if (T>80) T=round(T/2); end % znaleziono drugą podharmoniczną
    %T=0; % wyświetl wartość T
    
    % Zapamiętaj częstotliwość tonu podstawowego
    if T ~= 0
        czestotliwosci = [czestotliwosci; fpr/T];
    else
        czestotliwosci = [czestotliwosci; 0];
    end
    
    lpc=[lpc; T; wzm; a; ]; % zapamiętaj wartości parametrów
    
    % SYNTEZA - odtwórz na podstawie parametrów ----------------------------------------------------------------------
    % T = 0; % usuń pierwszy znak % i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end % przenieś pobudzenie dźwięczne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            pob=2*(rand(1,1)-0.5);
            %pob=cv(n);
            gdzie=(3/2)*Mstep+1; % pobudzenie szumowe
        else
            if (n==gdzie) 
                pob=1; 
                gdzie=gdzie+T; % pobudzenie dźwięczne
            else pob=0; 
            end
        end
        ss(n)=wzm*pob-bs*a; % filtracja „syntetycznego” pobudzenia
        bs=[ss(n) bs(1:Np-1) ]; % przesunięcie bufora wyjściowego
    end
    
    s = [s ss]; % zapamiętanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

% Dodanie porównania ramki oryginalnej i zsyntezowanej w dziedzinie czasu oraz częstotliwości
figure(3);
subplot(2,1,1); plot(x); title('Oryginalna mowa');
subplot(2,1,2); plot(s); title('Zsyntezowana mowa');

figure(4);
subplot(2,1,1); plot(abs(fft(x))); title('Widmo oryginalnej mowy');
subplot(2,1,2); plot(abs(fft(s))); title('Widmo zsyntezowanej mowy');

figure(5);
plot(s); title('Mowa zsyntezowana');
soundsc(s, fpr);

% Dodanie ogólnych wykresów dla analizy
figure(6);
subplot(3,1,1); plot(mean(autokorelacje)); title('Średnia funkcja autokorelacji');
subplot(3,1,2); plot(mean(widma_filtrow)); title('Średnie widmo filtra traktu głosowego');
subplot(3,1,3); plot(czestotliwosci); title('Częstotliwości tonu podstawowego');

disp('Analiza zakończona.');