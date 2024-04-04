clear all;
points=4096;
% Model dostaje epilepsji powyżej 4 punktów, dlatego jest zablokowane na 4
N=4;
mid_freq_unscaled = 96;
mid_freq = 2*pi*1e6*mid_freq_unscaled;
tollerance_unscaled = 50;
tollerance = 2*pi*1e3*tollerance_unscaled;
w = linspace(mid_freq-2*tollerance,mid_freq+2*tollerance,points);
[ze,pe,ke]=ellip(N,3,40,[mid_freq-tollerance,mid_freq+tollerance],'s'); % Akceptując niewielkie wahania charakterystyki w zakresie pasma przepuszczania i zaporowego, można osiągnąć wąskie pasmo przejściowe.
[be,ae] = zp2tf(ze,pe,ke);
he=freqs(be,ae,w);
% Odpowiedzi częstotliwościowe
plot(w/(2e6*pi), mag2db(abs(he)));
axis([mid_freq_unscaled-2*tollerance_unscaled/1e3 mid_freq_unscaled+2*tollerance_unscaled/1e3 -45 5])
grid;
% osie są w kHz a nie w Hz bo nie ma sensu mnożyć bytów
title("Odpowiedź częstotliwościowa")
xlabel("Częstotliwość (MHz)");
ylabel("Odpowiedź (dB)");