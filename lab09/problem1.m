% Co robi kod:
% Generuje sygna referencyjny skadajcy si z dwóch harmonicznych.
% Dodaje do niego szum Gaussowski o rónych poziomach mocy (10 dB, 20 dB, 40 dB)  przykad pokazano tylko dla 10 dB.
% Implementuje adaptacyjny filtr LMS do odszumienia sygnau.
% Wywietla wyniki w postaci wykresów porównujcych sygna czysty, zaszumiony i odszumiony.
% Oblicza stosunek sygnau do szumu (SNR), który jest miar efektywnoci odszumienia.

%AWGN 10 dB: Wysoki poziom szumu w stosunku do sygnau; filtr LMS prawdopodobnie bdzie mia trudnoci z dokadnym odszumieniem sygnau, co skutkuje wizualnie zauwaalnymi artefaktami na wykresie po odszumieniu.
%AWGN 20 dB: redni poziom szumu; filtracja powinna by skuteczniejsza ni w przypadku 10 dB, z mniejsz iloci artefaktów po odszumieniu.
%AWGN 40 dB: Relatywnie niski poziom szumu w porównaniu do sygnau; filtr LMS powinien by bardzo skuteczny w odszumianiu sygnau, z minimalnymi artefaktami widocznymi na wykresie.
% 
%Obliczenia SNR:
% SNR po odszumieniu:
%     Dla 10 dB: SNR powinien wzrosn, ale nieznacznie, ze wzgldu na wysoki poziom szumu pierwotnego.
%     Dla 20 dB: Oczekuje si wikszej poprawy SNR, jako e szum jest mniej intensywny.
%     Dla 40 dB: SNR po odszumieniu powinien by znacznie wyszy, pokazujc du efektywno filtru w warunkach niskiego poziomu szumu.
% 
% Praktyczne Wnioski:
% 
%     Efektywno odszumienia: Filtr LMS jest bardziej efektywny przy wyszych wartociach SNR wejciowego sygnau, co jest typowe dla wikszoci adaptacyjnych technik filtracji.
%     Wyzwania: Filtracja w warunkach niskiego SNR moe nie by w peni skuteczna, co wymaga albo zastosowania bardziej zaawansowanych technik, takich jak RLS czy filtry Kalmana, albo zwikszenia mocy sygnau przed jego przetwarzaniem.
%bd to eónica midzy sygnaem wejciowym (zaszumionym) w wyjciem filtru
%przy 40dB si dugo dostosowuje

%wiksze M - wikszy szum
%przesunicie o faz

%wiksze m - wikszy szum
%wypaszczenie amplitudy

close all;
clear all;

%% Parametry inicjalne
fs = 8000;  % Czstotliwo próbkowania [Hz]
t = 0:1/fs:1;  % Wektor czasowy od 0 do 1 sekundy
A1 = -0.5;  % Amplituda pierwszej harmonicznej
A2 = 1;     % Amplituda drugiej harmonicznej
f1 = 34.2;  % Czstotliwo pierwszej harmonicznej [Hz]
f2 = 115.5; % Czstotliwo drugiej harmonicznej [Hz]

%% Sygna referencyjny - sygna czysty
dref = A1 * cos(2 * pi * f1 * t) + A2 * cos(2 * pi * f2 * t);

%% AWGN 10 dB
d = awgn(dref, 10, 'measured');  % Dodanie biaego szumu Gaussowskiego
x = [d(1) d(1:end-1)];  % Sygna wejciowy filtru (opóniony), pierwszy element jest powielony, aby utrzyma dugo wektora
M = 90;  % Dugo filtru
mi = 0.01;  % Wspóczynnik szybkoci adaptacji
y = []; e = [];  % Inicjalizacja sygnaów wyjciowych i bdu
bx = zeros(M, 1);  % Bufor na próbki sygnau wejciowego
h = zeros(M, 1);  % Pocztkowe wagi filtru, filtr zaczyna dziaa bez wstpnej wiedzy o sygnale

for n = 1:length(x)
    bx = [x(n); bx(1:M-1)];  % Aktualizacja bufora próbkami
    y(n) = h' * bx;  % Obliczenie wyjcia filtru FIR
    e(n) = d(n) - y(n);  % Obliczenie bdu
    h = h + mi * e(n) * bx;  % Aktualizacja wag filtru (LMS)
end

%% AWGN 20 dB
d2 = awgn(dref, 20, 'measured'); 
x2 = [d2(1) d2(1:end-1)]; 
y2 = []; e2 = []; 
bx2 = zeros(M,1); 
h2 = zeros(M,1); 

for m = 1 : length(x2)
    bx2 = [x2(m); bx2(1:M-1)]; 
    y2(m) = h2' * bx2; 
    e2(m) = d2(m) - y2(m);
    h2 = h2 + mi * e2(m) * bx2; 
end

%% AWGN 40 dB
d4 = awgn(dref, 40,'measured'); 
x4 = [d4(1) d4(1:end-1)]; 
y4 = []; e4 = []; 
bx4 = zeros(M,1); 
mi4 = 0.03;  % Zwikszony wspóczynnik szybkoci adaptacji dla wyszego szumu
h4 = zeros(M,1); 

for j = 1 : length(x4)
    bx4 = [x4(j); bx4(1:M-1)]; 
    y4(j) = h4' * bx4; 
    e4(j) = d4(j) - y4(j); 
    h4 = h4 + mi4 * e4(j) * bx4; 
end

%% Wykresy
figure(1);

subplot(3,1,1);
plot(t, dref, 'b', t, d, 'r', t, y, 'k');
title('AWGN 10dB');
legend('Sygna czysty', 'Zaszumiony', 'Po odszumieniu');

subplot(3,1,2);
plot(t, dref, 'b', t, d2, 'r', t, y2, 'k');
title('AWGN 20dB');
legend('Sygna czysty', 'Zaszumiony', 'Po odszumieniu');

subplot(3,1,3);
plot(t, dref, 'b', t, d4, 'r', t, y4, 'k');
title('AWGN 40dB');
legend('Sygna czysty', 'Zaszumiony', 'Po odszumieniu');

%% Obliczenie SNR dla kadego poziomu szumu
SNR10 = 10 * log10((1/fs * sum(dref.^2)) / (1/fs * sum((dref - y).^2)));
display(SNR10);

SNR20 = 10 * log10((1/fs * sum(dref.^2)) / (1/fs * sum((dref - y2).^2)));
display(SNR20);

SNR40 = 10 * log10((1/fs * sum(dref.^2)) / (1/fs * sum((dref - y4).^2)));
display(SNR40);