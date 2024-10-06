clear all; close all;

% DPCM - metoda kompresji sygnału, która zmniejsza ilość danych potrzebnych do reprezentacji 
% sygnału poprzez kodowanie różnic między kolejnymi próbkami zamiast samych próbek
% - Koder oblicza różnicę między bieżącą a przewidywaną próbką
% - Kwantyzator zaokrągla różnicę do najbliższego poziomu
% - Dekoder rekonstruuje sygnał dodając skwantyzowaną różnicę do przewidywanej próbki

%% Wczytanie próbki dzwiekowej
[x,Fs] = audioread( 'DontWorryBeHappy.wav', 'native' ); % Fs - czst. probkowania
x = double( x ); %  x - sygnał dźwiękowy

%% KODER
a = 0.9545; % parametr a kodera ( określa, jak bardzo poprzednia próbka wpływa na przewidywaną wartość bieżącej próbki )
d = x - a*[[0,0]; x(1:end-1,:)]; % KODER

% obliczamy różnicę między bieżącą próbką a przewidywaną wartością na podstawie poprzedniej próbki

%% KWANTYZACJA (Zmniejsza ilość danych. Latwiejsze i szybsze dla komputerów)

% rozdzielczosc sygnalu w bitach - ilosc stanow 2^n wartości
ile_bitow = 10; 
dq = lab11_kwant(d,ile_bitow); % kwantyzator (kwantyzujemy do 4 bitow)

n=1:length(x); % os x do wykresow

% wykres porownujacy sygnal przed i po kwantyzacji

figure;
n=1:length(x);
subplot(2,2,1);
hold on;
plot( n, d(:,1), 'k');
%plot( n, dq(:,1), 'r');
title('Oryginalny kanal lewy'); 
subplot(2,2,2);
hold on;
plot( n, d(:,2), 'k');
%plot( n, dq(:,2), 'r');
title('Oryginalny kanal prawy'); 
subplot(2,2,3);
hold on;
plot( n, dq(:,1), 'g');
title('Kwantyzacja kanal lewy'); 
subplot(2,2,4);
hold on;
plot( n, dq(:,2), 'g');
title('Kwantyzacja kanal prawy'); 

% Widać, że sygnał jest uproszczony, szczególnie w miejscach, gdzie amplituda 
% zmienia się szybko. To oznacza stratę pewnych informacji o sygnale

%% DEKODER - faktyczne zadanie
% dekodowanie sygnalu nieskwantyzowanego
y1(1) = d(1,1); % kanal lewy ( Inicjalizuje pierwszą próbkę zdekodowanego sygnału lewego )
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

% Dekodowanie polega na sumowaniu skwantyzowanych różnic z przewidywaną
% wartością na podstawie poprzedniej zrekonstruowanej próbki

% Kwantyzacja redukuje ilość danych potrzebnych do reprezentacji sygnału ale kosztem 
% wprowadzenia pewnych zniekształceń - im więcej bitów tym mniejsze zniekształcenia ale większa ilość danych

%% Wykresy (po dekodowaniu)
figure;
subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, y1, 'g');
title('Zdekodowany kanal lewy'); 
legend('Oryginalny','Zdekodowany');
subplot(1,2,2);
hold on;
plot( n, y2, 'g');
plot( n, x(:,2), 'k');

title('Zdekodowany kanal prawy'); 
legend('Oryginalny','Zdekodowany');

% oba sygnały bardzo dobrze sie pokrywają co znaczy że proces DPCM zadziałał poprawnie


figure;
subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, ydl, 'g');
title('Zdekodowany kanal lewy (z kwantyzacja)');
legend('Oryginalny','Zdekodowany');
subplot(1,2,2);
hold on;
plot( n, x(:,2), 'k');
plot( n, ydp, 'g');

title('Zdekodowany kanal prawy (z kwantyzacja)'); 
legend('Oryginalny','Zdekodowany');

% Kwantyzacja z 4-bitową rozdzielczością (16 stanów) powoduje znaczną utratę 
% informacji co prowadzi do zniekształceń w zdekodowanym sygnale



%% Obliczenia i wykresy błędów
error_nieskwant_lewy = x(:,1) - y1';
error_nieskwant_prawy = x(:,2) - y2';

error_kwant_lewy = x(:,1) - ydl';
error_kwant_prawy = x(:,2) - ydp';

figure;
subplot(2,2,1);
plot(n, error_nieskwant_lewy, 'r');
title('Błąd nieskwant. kanał lewy');
subplot(2,2,2);
plot(n, error_nieskwant_prawy, 'r');
title('Błąd nieskwant. kanał prawy');
subplot(2,2,3);
plot(n, error_kwant_lewy, 'r');
title('Błąd skwant. kanał lewy');
subplot(2,2,4);
plot(n, error_kwant_prawy, 'r');
title('Błąd skwant. kanał prawy');

%Error calc
disp('Roznica miedzy oryginalem a odtworzonym:');
display(abs(max(x(:,1)-y1')));
display(abs(max(x(:,2)-y2')));
disp('Roznica miedzy oryginalem skwantowanym a odtworzonym:');
display(abs(max(x(:,1)-ydl')));
display(abs(max(x(:,2)-ydp')));

% Pokazują różnice między oryginalnym sygnałem a zdekodowanym sygnałem

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

% funkcja dzieli sygnał na dwa kanały, oblicza zakres wartości dla każdego kanału i dzieli ten zakres na 
% 16 poziomów kwantyzacji. Każda wartość sygnału jest zaokrąglana do naj


