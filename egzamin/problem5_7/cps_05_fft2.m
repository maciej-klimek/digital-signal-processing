% cps_05_fft2.m

% Algorytm radix-2 DIT (decimation in time) FFT
  clear all; close all;

  N=8;               % liczba probek sygnalu (potega dwojki)
  x=0:N-1;           % przykladowy analizowany sygnal, np. inny wybor x=randn(1,N)
  Nbits = log2(N);   % liczba bitow potrzebna na indeksy probek, dla N=8, Nbits=3

% Przestawianie probek sygnalu (odwracanie bitow numeru probki)
  n = 0:N-1;            % indeksy WSZYSTKICH probek 
  m = dec2bin(n);       % bity tych indeksow
  m = m(:,Nbits:-1:1);  % odwrocone bity
  m = bin2dec(m);       % nowe indeksy WSZYSTKICH probek
  y(m+1) = x(n+1);      % przestawianie danych wejsciowych
  y,                    % sprawdzenie wyniku

% WSZYSTKIE 2-punktowe DFTs na sasiednich parach probek (po ich przestawieniu)
  y = [ 1 1; 1 -1] * [ y(1:2:N); ...
                       y(2:2:N) ]; y = y(:)';   % 2-punktowe widma DFT

  y,

% Rekonstrukcja N-punktowego DFT z 2-punktowych
% Widma DFT: 2-punktowe --> 4-punktowe --> 8-punktowe --> 16-punktowe ...
  Nx = N;                   % liczba probek (zmiana nazwy zmiennej)
  Nlevels = Nbits;          % liczba etapow oliczeniowych rowna log2(Nx)
  N = 2;                    % poczatkowa dlugosc DFT po 2-punktowych DFT
  for lev = 2 : Nlevels                % nastepny ETAP
      N = 2*N;                         % nowa dlugosc widma DFT po polaczeniu 
      Nblocks = Nx/N;                  % nowa liczba widm DFT po polaczeniu 
      W = exp( -j*2*pi/N*(0:N-1) );    % korekta stosowana na tym etapie
      for k = 1 : Nblocks                                 % nastepny BLOK dwoch DFT
          y1 = y( 1     + (k-1)*N : N/2 + (k-1)*N );      % widmo y1 - NIZEJ 
          y2 = y( N/2+1 + (k-1)*N : N   + (k-1)*N );      % widmo y2 - WYZEJ
          y(1 + (k-1)*N : N + (k-1)*N ) = [ y1 y1 ] + W .* [ y2 y2 ];   % LACZENIE
      end
  end
  ERROR = max( abs( fft(x) - y ) ),    % blad?
