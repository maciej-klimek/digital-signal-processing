% Zad. 3
% zrobione wg. https://www.mathworks.com/help/signal/ref/freqs.html#mw_34730865-ac06-4487-864f-f6bc6ae1d533
clear all;
% cele:
% - maks tłumienie dla f>f_s/2
% - wzmocnienie = 1 dla f<f_s/2
% - minimalny rząd
% - zmiany tłumienia w paśmie f < 64 kHz nie większe niż 3 dB
% - tłumienie dla częstotliwości f_s/2 co najmniej 40 dB
sampling_freq = (256 * 1000); %czestotliwosc probkowania przetwornika A/C
cutoff = sampling_freq/2; %maksymalne tłumienie
points = 4096; 
w = linspace(0,sampling_freq,points)*2*pi;

%typy filtrów: Butterworth,Czebyszew 1, Czebyszew 2, eliptyczny

freq_64 = 1000*64;
freq_112 = 1000*112;
freq_128 = 1000*128;


%7 poziom filtra
[zeros_butter,poles_butter,gain_butter] = butter(7,2*pi*freq_64,'s');
%b_butter -> Transfer function numerator coefficients a_butter -> Transfer function denominator coefficients
[b_butter,a_butter] = zp2tf(zeros_butter,poles_butter,gain_butter);
frequnecy_response_butter = freqs(b_butter,a_butter,w);

% 3 to zmiany tłumienia dla częstotliwości nie tłumionych
[zeros_cheby1,poles_cheby1,gain_cheby1]=cheby1(5,3,2*pi*freq_64,'s');
[b_cheby1,a_cheby1] = zp2tf(zeros_cheby1,poles_cheby1,gain_cheby1);
frequnecy_response_cheby1 = freqs(b_cheby1,a_cheby1,w);

% 40 to tłumienie w paśmie tłumienia
[zeros_cheby2,poles_cheby2,gain_cheby2]=cheby2(5,40,2*pi*freq_112,'s');
[b_cheby1,a_cheby1] = zp2tf(zeros_cheby2,poles_cheby2,gain_cheby2);
frequnecy_response_cheby2 = freqs(b_cheby1,a_cheby1,w);

% jak wyżej
[zeros_ellip,poles_ellip,gain_ellip]=ellip(3,3,40,2*pi*freq_64,'s');
[b_ellip,a_ellip] = zp2tf(zeros_ellip,poles_ellip,gain_ellip);
frequnecy_response_ellip = freqs(b_ellip,a_ellip,w);



figure
hold on
% Odpowiedzi częstotliwościowe
plot([w; w; w; w]'/(2e3*pi), mag2db(abs([frequnecy_response_butter; frequnecy_response_cheby1; frequnecy_response_cheby2; frequnecy_response_ellip]')));
axis([0 256 -40 5])
grid;
% osie są w kHz a nie w Hz bo nie ma sensu mnożyć bytów
title("Odpowiedź częstotliwościowa modelów")
xlabel("Częstotliwość (kHz)");
ylabel("Odpowiedź (dB)");
%rectangle('Position',[0 -45 64 42],'FaceColor','red','LineWidth',0.1,'EdgeColor','k','Visible',true)
%line([128 128],[5 -40],'LineWidth',0.1,'Visible',true,'Color','k');

legend(["Butter" "Czeby1" "Czeby2" "Elipt"]);
hold off;



figure;
% Ustalenie osi w celu uzyskania kwadratowego wykresu
hAx = axes('NextPlot', 'add');
hAx.Position(3) = hAx.Position(4);

% Rysowanie biegunów filtrów za pomocą funkcji plot
plot(hAx, real(poles_butter), imag(poles_butter), '*');
hold on;
plot(hAx, real(poles_cheby1), imag(poles_cheby1), '+');
plot(hAx, real(poles_cheby2), imag(poles_cheby2), 'square');
plot(hAx, real(poles_ellip), imag(poles_ellip), 'diamond');
hold off;

title("Rozkład biegunów filtrów");
legend(["Butter" "Czeby1" "Czeby2" "Elipt"]);
xlabel("Re");
ylabel("Im");
