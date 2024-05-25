% ----------------------------------------------------------
% Tabela 19-4 (str. 567)
% Æwiczenie: Kompresja sygna³u mowy wed³ug standardu LPC-10
% ----------------------------------------------------------

clear;
close all;

[x,fpr] = audioread('mowa1.wav');  % wczytaj sygna³ mowy (ca³y)
oryginalny = x;
bezdzw = 80700:81400; %g³oska bezdzwieczna (Przy!ci!sku...)
dzw = 3000:3700; %gloska dzwieczna (!M!aterial kursu...)

% Wyswietl sygnal i wybrane gloski
figure(1);
subplot(3,1,1);
plot((1:length(x))/fpr, x); title('Sygna³ mowy');

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

% soundsc(x,fpr);  % oraz odtwórz na g³o³nikach (s³uchawkach)

% Okno Hamminga
N = length(x);  % d³ugoœæ sygna³u
Mlen = 240;  % d³ugoœæ okna Hamminga (liczba próbek)
Mstep = 180;  % przesuniêcie okna w czasie (liczba próbek)
Np = 10;  % rz¹d filtra predykcji
gdzie = Mstep + 1;  % pocz¹tkowe polo¿enie pobudzenia dŸwiêcznego

lpc = [];  % tablica na wspóczynniki modelu sygna³u mowy
s = [];  % ca³a mowa zsyntezowana
ss = [];  % fragment sygna³u mowy zsyntezowany
bs = zeros(1, Np);  % bufor na fragment sygna³u mowy
Nramek = floor((N - Mlen) / Mstep + 1);  % ile fragmentów (ramek) jest do przetworzenia

% Preemfaza - filtracja wstepna
x = filter([1 -0.9735], 1, x);

% Podpunkt a
figure(3);
subplot(3,1,1);
plot((1:length(x))/fpr, x); title('Sygna³ mowy po preemfazie');

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

    % pobierz kolejny fragment sygna³u
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
    bx = bx - mean(bx);  % usuñ wartoœæ œredni¹
    for k = 0:Mlen-1
        r(k+1) = sum(bx(1:Mlen-k) .* bx(1+k:Mlen)); % funkcja autokorelacji
    end

    offset = 20; 
    rmax = max(r(offset:Mlen));  % znajdŸ maksimum funkcji autokorelacji
    imax = find(r == rmax);  % znajdŸ indeks tego maksimum
    if (rmax > 0.35 * r(1)) 
        T = imax; 
    else 
        T = 0; 
    end  % g³oska dŸwiêczna/bezdŸwiêczna?

    rr(1:Np, 1) = (r(2:Np+1))';
    for m = 1:Np
        R(m, 1:Np) = [r(m:-1:2) r(1:Np-(m-1))];  % zbuduj macierz autokorelacji
    end
    a = -inv(R) * rr;  % oblicz wspóczynniki filtra predykcji
    wzm = r(1) + r(2:Np+1) * a;  % oblicz wzmocnienie
    H = freqz(1, [1; a]);  % oblicz jego odp. czêstotliwoœciow¹

    % SYNTEZA - odtwórz na podstawie parametrów ----------------------------------------------------------------------
    % T = 0; % usuñ pierwszy znak '%' i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    aa = quantize_coefficients(a);

    if (T ~= 0) 
        gdzie = gdzie - Mstep; 
    end  % 'przenieœ' pobudzenie dxwiêczne
    for n = 1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if (T == 0)
            pob = 2 * (rand(1, 1) - 0.5); 
            gdzie = (3/2) * Mstep + 1;  % pobudzenie szumowe
        else
            if (n == gdzie) 
                pob = 1; 
                gdzie = gdzie + T;  % pobudzenie dŸwiêczne
            else 
                pob = 0; 
            end
        end
        ss(n) = wzm * pob - bs * aa;  % filtracja 'syntetycznego' pobudzenia

        bs = [ss(n) bs(1:Np-1)];  % przesuniêcie bufora wyjœciowego
    end
    s = [s ss];  % zapamiêtanie zsyntezowanego fragmentu mowy
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
