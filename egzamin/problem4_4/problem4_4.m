clear all; close all;

% Ortogonalna macierz dla ortogonalnej transformacji DFT
N = 100;                                  % wymiar macierzy kwadratowej
k = (0:N-1); n = (0:N-1);                 % k-kolumny/funkcje, n-wiersze/probki

% Macierz DFT
A = sqrt(1/N)*exp(-1j*2*pi/N*k'*n);       % macierz analizy
S = A';                                   % macierz syntezy: transpozycja A


% Sprawdzenie ortonormalności: S * A powinno być macierzą jednostkową
orthonormal_check = S * A;
disp('Sprawdzenie ortonormalności (S * A):');
disp(orthonormal_check);

% Generowanie sygnałów
x1 = 10 * A(:,5);                         % sygnal #1                 
x2 = 20 * A(:,10);                        % sygnal #2

x = real(x1) + imag(x2);                  % kombinacja real(x1) i imag(x2)
figure; plot(x, 'bo-', LineWidth=2); title('Oryginalny Sygnał x(n)'); grid; % rysunek oryginalnego sygnału
hold on;
plot(real(x1))
hold on;
plot(imag(x2))
hold on;
pause;

% Wykonanie DFT
c = A * x;                                % współczynniki DFT
figure; stem(abs(c)); title('Współczynniki DFT |c|'); grid;  % rysunek współczynników DFT

% Wykres współczynników DFT
figure;
subplot(2, 1, 1);
stem(real(c)); title('Rzeczywista część współczynników DFT Re(c)'); grid;
subplot(2, 1, 2);
stem(imag(c)); title('Urojona część współczynników DFT Im(c)'); grid;
pause;

% Wyzerowanie współczynników związanych z sygnałem x1 lub x2
c1 = c; c1(5) = 0; c1(97) = 0;            % wyzerowanie 5-tego i (ew. )97-tego współczynnika (związanego z x1)
c2 = c; c2(10) = 0; c2(92) = 0;           % wyzerowanie 10-tego i (ew.) 92-tego współczynnika (związanego z x2)

figure; stem(abs(c1)); title('Współczynniki DFT |c1|'); grid;  % rysunek współczynników DFT
figure; stem(abs(c2)); title('Współczynniki DFT |c2|'); grid;  % rysunek współczynników DFT
pause;

% Wykonanie IDFT dla każdej zmodyfikowanej grupy współczynników
y1 = S * c1;                              % IDFT z zmodyfikowanym c1
y2 = S * c2;                              % IDFT z zmodyfikowanym c2

% Rysowanie wyników
figure;
subplot(2, 1, 1);
plot(x, 'bo-'); hold on;
plot(real(y1), 'ro-'); 
title('Odzyskany Sygnał y1(n) z zmodyfikowanym c1'); grid;
legend('Oryginalny sygnał', 'Część rzeczywista sygnału odzyskanego y1');

subplot(2, 1, 2);
plot(x, 'bo-'); hold on;
plot(real(y2), 'ro-'); 
title('Odzyskany Sygnał y2(n) z zmodyfikowanym c2'); grid;
legend('Oryginalny sygnał', 'Część rzeczywista sygnału odzyskanego y2');

% Porównanie odzyskanych sygnałów z oryginalnym
error1 = max(abs(x - y1));                 % błąd rekonstrukcji dla y1
error2 = max(abs(x - y2));                 % błąd rekonstrukcji dla y2

