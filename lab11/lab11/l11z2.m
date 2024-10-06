clear all; close all;

%% Dane
[x, fpr] = audioread('DontWorryBeHappy.wav');
x = x(:,1);

N = 32; %dlugosc okna w probkach, co N/2 próbek sie przesuwam
K = N/2;
[n,k] = meshgrid(0:(N-1), 0:(K-1)); %
win = sin(pi*(n+0.5)/N); %okno analizy i syntezy
% macierz analizy
C = sqrt(2/K)*win.*cos(pi/K*(k+1/2).*(n+1/2+K/2)); 
D = C';

Q = 100;

Nramek = floor(length(x)/N);

%% SYNTEZA I ANALIZA
y = zeros(1, length(x));
for k=1:2*Nramek
    n1st = 1+(k-1)*K; nlast = N+(k-1)*K;
    n = n1st:nlast;
    bx = x(n);
    BX = C*bx;
    
    by= D*BX;
    y(n) = y(n) + by';
end
y = y';


%% Wykresy sygnalow i bledu
n=1:length(x);
error = x-y;

figure;
plot(n,x,'k', n,y,'g');
grid;
title('Sygnały WE i WY');

figure;
plot(n,x,'k', n,y,'g');
grid;
xlim([0 1200]);
title('Sygnały WE i WY (poczatek)');
legend("oryginalny","zakodowany")

figure;
plot(n,error);
xlim([0 1200]);
grid;
title('Błąd odtworzenia dla pierwszych 1200 próbek');
