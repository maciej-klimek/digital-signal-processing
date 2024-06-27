% cps03_trans.m
clear all; close all

% Orthogonal matrix for DCT-IV orthogonal transform
N = 100;                                  % wymiar macierzy kwadratowej, 25, 100
k = (0:N-1); n=(0:N-1);                   % k-kolumny/funkcje, n-wiersze/probki
S = sqrt(2/N)*cos(pi/N*(n'+1/2)*(k+1/2)); % macierz syntezy
A = S';                                   % macierz analizy: transpozycja i sprzezenie S

% S*A, pause  % sprawdzenie ortogonalnosci: macierz z jedynkami na przekatnej?
 
x1 = 10*A(:,5);                                  % sygnal #1                 
x2 = 20*A(:,10);                                 % sygnal #2
x3 = 30*sqrt(2/N)*cos(pi/N*(n'+1/2)*(15+1/2));   % sygnal #3
x4 = randn(N,1);                                 % sygnal #4
x = x;                                          % wybor x1, x2, x3, x4, x1+x2, x1+x3, x1+x4 
figure; plot(x,'bo-'); title('y(n)'); grid;      % rysunek sygnalu wejsciowego
 
c = A*x;                 % analiza sygnalu: wyznaczenie wspolczynnikow transformacji
figure; stem(c); grid;   % pokazanie wspolczynnikow transformacji
%c(3) = 0;               % opcjonalne usuniecie 3-ciej skladowej sygnalu 
y = S*c;                 % synteza sygnalu: suma przeskalowanych funkcji bazowych
figure; plot(y,'bo-'); title('x(n)'); grid;       % rysunek sygnalu wyjsciowego
error = max(abs(x-y)),   % blad odtworzenia/rekonstrukcji sygnalu
