% ----------------------------------------------------------
% Tabela 19-4 (str. 567)
% �wiczenie: Kompresja sygna�u mowy wed�ug standardu LPC-10
% ----------------------------------------------------------

clear;
close all;

[x,fpr] = audioread('mowa1.wav');  % wczytaj sygna� mowy (ca�y)
oryginalny = x;
bezdzw = 80700:81400; %g�oska bezdzwieczna (Przy!ci!sku...)
dzw = 3000:3700; %gloska dzwieczna (!M!aterial kursu...)

% Wyswietl sygnal i wybrane gloski
figure(1);
subplot(3,1,1);
plot((1:length(x))/fpr, x); title('Sygna� mowy');

subplot(3,1,2);
plot(dzw/fpr, x(dzw)); title('Gloska dzwieczna');

subplot(3,1,3);
plot(bezdzw/fpr, x(bezdzw)); title('Gloska bezdzwieczna');

% Widma gestosci mocy
figure(2);
subplot(2,1,1);
hpsdd1 = dspdata.psd(abs(x(dzw)), 'Fs', fpr);
plot(hpsdd1); title('Widmo gestosci mocy - gloska dzwieczna przed preem.');

subplot(2,1,2);
hpsdb1 = dspdata.psd(abs(x(bezdzw)), 'Fs', fpr);
plot(hpsdb1); title('Widmo gestosci mocy - gloska bezdzwieczna przed preem.');

% soundsc(x,fpr);  % oraz odtw�rz na g�o�nikach (s�uchawkach)

% Okno Hamminga
N = length(x);  % d�ugo�� sygna�u
Mlen = 240;  % d�ugo�� okna Hamminga (liczba pr�bek)
Mstep = 180;  % przesuni�cie okna w czasie (liczba pr�bek)
Np = 10;  % rz�d filtra predykcji
gdzie = Mstep + 1;  % pocz�tkowe polo�enie pobudzenia d�wi�cznego

lpc = [];  % tablica na wsp�czynniki modelu sygna�u mowy
s = [];  % ca�a mowa zsyntezowana
ss = [];  % fragment sygna�u mowy zsyntezowany
bs = zeros(1, Np);  % bufor na fragment sygna�u mowy
Nramek = floor((N - Mlen) / Mstep + 1);  % ile fragment�w (ramek) jest do przetworzenia

% Preemfaza - filtracja wstepna
x = filter([1 -0.9735], 1, x);

% Podpunkt a
figure(3);
subplot(3,1,1);
plot((1:length(x))/fpr, x); title('Sygna� mowy po preemfazie');

subplot(3,1,2);
plot(dzw, oryginalny(dzw), dzw, x(dzw)); title('Gloska dzwieczna przed i po preemfazie');
legend('przed', 'po');

subplot(3,1,3);
plot(bezdzw, oryginalny(bezdzw), bezdzw, x(bezdzw)); title('Gloska bezdzwieczna przed i po preemfazie');
legend('przed', 'po');

figure(4);
hpsdd2 = dspdata.psd(abs(x(dzw)), 'Fs', fpr);
hpsdb2 = dspdata.psd(abs(x(bezdzw)), 'Fs', fpr);

subplot(2,1,1);
plot(hpsdd2); title('Widmo gestosci mocy - gloska dzwieczna po preem.');

subplot(2,1,2);
plot(hpsdb2); title('Widmo gestosci mocy - gloska bezdzwieczna po preem.');

for nr = 1:Nramek

    % pobierz kolejny fragment sygna�u
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
    bx = bx - mean(bx);  % usu� warto�� �redni�
    for k = 0:Mlen-1
        r(k+1) = sum(bx(1:Mlen-k) .* bx(1+k:Mlen)); % funkcja autokorelacji
    end

    offset = 20; 
    rmax = max(r(offset:Mlen));  % znajd� maksimum funkcji autokorelacji
    imax = find(r == rmax);  % znajd� indeks tego maksimum
    if (rmax > 0.35 * r(1)) 
        T = imax; 
    else 
        T = 0; 
    end  % g�oska d�wi�czna/bezd�wi�czna?

    rr(1:Np, 1) = (r(2:Np+1))';
    for m = 1:Np
        R(m, 1:Np) = [r(m:-1:2) r(1:Np-(m-1))];  % zbuduj macierz autokorelacji
    end
    a = -inv(R) * rr;  % oblicz wsp�czynniki filtra predykcji
    wzm = r(1) + r(2:Np+1) * a;  % oblicz wzmocnienie
    H = freqz(1, [1; a]);  % oblicz jego odp. cz�stotliwo�ciow�

    % SYNTEZA - odtw�rz na podstawie parametr�w ----------------------------------------------------------------------
    % T = 0; % usu� pierwszy znak '%' i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    aa = quantize_coefficients(a);

    if (T ~= 0) 
        gdzie = gdzie - Mstep; 
    end  % 'przenie�' pobudzenie dxwi�czne
    for n = 1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if (T == 0)
            pob = 2 * (rand(1, 1) - 0.5); 
            gdzie = (3/2) * Mstep + 1;  % pobudzenie szumowe
        else
            if (n == gdzie) 
                pob = 1; 
                gdzie = gdzie + T;  % pobudzenie d�wi�czne
            else 
                pob = 0; 
            end
        end
        ss(n) = wzm * pob - bs * aa;  % filtracja 'syntetycznego' pobudzenia

        bs = [ss(n) bs(1:Np-1)];  % przesuni�cie bufora wyj�ciowego
    end
    s = [s ss];  % zapami�tanie zsyntezowanego fragmentu mowy
end

s = filter(1, [1 -0.9735], s);  % filtracja (deemfaza) - filtr odwrotny - opcjonalny

plot(s); title('mowa zsyntezowana');  %pause
soundsc(s, fpr)

function q = quantize_coefficients(a)
    % Quantize the coefficients using scaling and rounding
    q = zeros(size(a));
    q(1:2) = round(a(1:2) * 256) / 256;  % Quantize to 8 bits (256 levels)
    q(3:6) = round(a(3:6) * 64) / 64;    % Quantize to 6 bits (64 levels)
    q(7:10) = round(a(7:10) * 16) / 16;  % Quantize to 4 bits (16 levels)
end
