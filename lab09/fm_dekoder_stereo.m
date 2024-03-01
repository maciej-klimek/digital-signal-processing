% ############################################
% RADIO FM: DEKODER - przyklad
% Dekoder RDS wedlug standardu IEC 62106
% Program fm_dekoder.m
% Autor: Tomasz ZIELINSKI, tzielin@agh.edu.pl

clear all; close all;
ifigs = 0;

fm_param_samples_LR   % wczytaj parametry
bwSERV = 250e3;     % bandwidth of an FM service

load stereo_fm_broken_pilot_b;
y = I+1i*Q;
N = length(y);

y = y .* exp(-sqrt(-1)*2*pi*bwSERV/fs*(0:N-1)');

[b,a] = butter( 4, (bwSERV)/(fs/2) );
y = filter( b, a, y );
y = y( 1 : fs/bwSERV : end );
fs = bwSERV;

% ODTWORZENIE SYGNALU MONO
dy = (y(2:end).*conj(y(1:end-1)));
y = atan2( imag(dy), real(dy) ); clear dy;

% Filtracja dolnoprzepustowa sygnalu L+R (mono)
hLPaudio = fir1(L,(Abw/2)/(fs/2),kaiser(L+1,7));
ym = filter( hLPaudio, 1, y );
ym = ym(1:fs/Abw:end);

% ODTWORZENIE SYGNALU STEREO
% Odseparowanie sygnalu pilota 19 kHz (filtracja pasmowoprzepustowa)
fcentr = fpilot; df1 = 1000; df2 = 2000;
ff = [ 0 fcentr-df2 fcentr-df1 fcentr+df1 fcentr+df2 fs/2 ]/(fs/2);
fa = [ 0 0.01 1 1 0.01 0 ];
hBP19 = firpm(L,ff,fa);
p = filter(hBP19,1,y);

%%%%%%%%%%%%%%%%%%%%%%%%%%  ToDo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Petla PLL
c19 = [];   % pilot 19 kHz
c38 = [];   % pilot 38 kHz
%%%%%%%%%%%%%%%%%%%%%%%%%%  ToDo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Filtracja pasmowo-przepustowa sygnalu L-R wokol 38 kHZ
fcentr = fstereo; df1 = 10000; df2 = 12500;
ff = [ 0 fcentr-df2 fcentr-df1 fcentr+df1 fcentr+df2 fs/2 ]/(fs/2);
fa = [ 0 0.01 1 1 0.01 0 ];
hBP38 = firpm(L,ff,fa);
ys = filter(hBP38,1,y);
% Przesuniecie sygnalu L-R w czestotliwosci do DC (38 kHz --> 0 kHz)

ys = real(ys .* c38); 
clear c38;

% Filtracja dolno-przepustowa
ys = filter( hLPaudio, 1, ys );
ys = ys(1:fs/Abw:end);

% Synchronizacja czasowa sygnalow L+R i L-R (uwzglednienie opoznienia L-R)
delay = (L/2)/(fs/Abw); ym = ym(1:end-delay); ys=2*ys(1+delay:end); % 2 od modul
clear ymm yss;

% Odtworzenie kanalow L i R
y1 = 0.5*( ym + ys ); y2 = 0.5*( ym - ys ); clear ym ys;
y1 = filter(b_de,a_de,y1); y2 = filter(b_de,a_de,y2);

plot( 1:length(y1), y1, 'b', 1:length(y2), y2, 'r'); legend('Left', 'Right');


