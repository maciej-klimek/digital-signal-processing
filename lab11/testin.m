clear all; close all;

%% Wczytanie próbki dzwiekowej
[x,Fs] = audioread( 'DontWorryBeHappy.wav', 'native' );
x = double( x );

%% KODER
a = 0.9545; % parametr a kodera
d = x - a*[[0,0]; x(1:end-1,:)]; % KODER

%% KWANTYZACJA
% rozdzielczosc sygnalu w bitach - ilosc stanow 2^n wartości
ile_bitow = 7;      % 6/7 bitow zaczynaja sie zaklocenia
dq = lab11_kwant(d,ile_bitow); % kwantyzator

n=1:length(x); % os x do wykresow

% wykres porownujacy sygnal przed i po kwantyzacji

figure;
n=1:length(x);
subplot(2,2,1);
hold on;
plot( n, d(:,1), 'b');
%plot( n, dq(:,1), 'r');
title('Oryginalny kanal lewy'); 
subplot(2,2,2);
hold on;
plot( n, d(:,2), 'r');
%plot( n, dq(:,2), 'r');
title('Oryginalny kanal prawy'); 
subplot(2,2,3);
hold on;
plot( n, dq(:,1), 'b');
title('Kwantyzacja kanal lewy'); 
subplot(2,2,4);
hold on;
plot( n, dq(:,2), 'r');
title('Kwantyzacja kanal prawy'); 

%% DEKODER - faktyczne zadanie
% dekodowanie sygnalu nieskwantyzowanego
y1(1) = d(1,1); % kanal lewy
for k=2:length(dq)
    y1(k) = d(k,1) + a*y1(k-1);
end

y2(1) = d(1,2); % kanal prawy
for k=2:length(dq)
    y2(k) = d(k,2) + a*y2(k-1);
end


% dekodowanie sygnalu z kwantyzacja 
ydl(1) = dq(1,1); %kanal lewy
for k=2:length(dq)
    ydl(k) = dq(k,1) + a*ydl(k-1);
end


ydp(1) = dq(1,2); %kanal prawy
for k=2:length(dq)
    ydp(k) = dq(k,2) + a*ydp(k-1);
end

%% vWykresy (po dekodowaniu)
figure;
subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, y1, 'b.');
title('Zdekodowany kanal lewy'); 
legend('Oryginalny','Zdekodowany');
subplot(1,2,2);
hold on;
plot( n, y2, 'k');
plot( n, x(:,2), 'r.');

title('Zdekodowany kanal prawy'); 
legend('Oryginalny','Zdekodowany');

figure;
subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, ydl, 'b.');
title('Zdekodowany kanal lewy (z kwantyzacja)');
legend('Oryginalny','Zdekodowany');
subplot(1,2,2);
hold on;
plot( n, x(:,2), 'k');
plot( n, ydp, 'r.');
title('Zdekodowany kanal prawy (z kwantyzacja)'); 
legend('Oryginalny','Zdekodowany');

%Error calc
disp('Roznica miedzy oryginalem a odtworzonym:');
display(abs(max(x(:,1)-y1')));
display(abs(max(x(:,2)-y2')));
disp('Roznica miedzy oryginalem skwantowanym a odtworzonym:');
display(abs(max(x(:,1)-ydl')));
display(abs(max(x(:,2)-ydp')));

% laczymy zdekodowanysygnal prawy z lewym
% y_decode = vertcat(y1,y2); 
% soundsc(y_decode,Fs); % odtwarzamy stereo


% laczymy zdekodowanysygnal prawy z lewym
y_kwant = vertcat(ydl,ydp); 
soundsc(y_kwant,Fs); % odtwarzamy stereo

function y = lab11_kwant(x,b) %(sygnał, liczba bitów)
      xlewy = x(:,1);   %  rozdzielamy na kanal lewy i prawy
      xprawy = x(:,2);
      xMinLewy = min(xlewy);    %znajduje min i max w każdym
      xMaxLewy = max(xlewy);
      xMinPrawy = min(xprawy);
      xMaxPrawy = max(xprawy);
      
      % minimum, maksimum, zakres (odległośc punktów od siebie)
      x_zakresLewy=xMaxLewy-xMinLewy; 
      x_zakresPrawy=xMaxPrawy-xMinPrawy;
      
      % liczba bitów, liczba przedzialów kwantowania
      Nb=b; Nq=2^Nb; 
      % szerokosc przedzialu kwantowania
      dx=x_zakresLewy/Nq; %dzielę na równe progi
      xqlewy=dx*round(xlewy/dx); %zaokrąglam do najbliższego progu
      
      dx=x_zakresPrawy/Nq;
      xqprawy=dx*round(xprawy/dx);
      
      % funkcja zwraca sygnal stereo - zlozenie horyzontalne
      y = horzcat(xqlewy,xqprawy);  %składa sygnał z dwóch kanałów
end
