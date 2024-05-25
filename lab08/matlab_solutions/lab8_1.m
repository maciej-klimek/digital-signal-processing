    clear;
close all;

%% za³adowanie sygna³ów
load('lab08_am.mat');
x=s7;

%% wygenerowanie teoretycznej odpowiedzi impulsowej
fs=1000;        %czestotliwosc probkowania
fc=200;         %czestotliwosc nosna
M=64;           %polowa dlugosci filtra
N=2*M+1;
n=1:M;
h=(2/pi)*sin(pi*n/2).^2 ./n;    %po³owa odpowiedzi impulsowej (TZ str. 352)
h=[-h(M:-1:1) 0 h(1:M)];        %ca³a odpowiedŸ dla n = ?M,...,0,...,M

%% wymna¿amy przez okno Blackmana
w=blackman(N); w=w';            
hw=h.*w; % wymno¿enie odpowiedzi impulsowej z oknem

%% filtracja odpowiedzia imp.
y=conv(x,hw); % filtracja sygna³u x(n) za pomoc¹ odp. impulsowej hw(n); otrzymujemy Nx+N?1 próbek
y=y(N:1000);  % odciêcie stanów przejœciowych (po N?1 próbek) z przodu sygna³u y(n)
c=x(M+1:1000-M);   % odciêcie tych próbek z x(n), dla których nie ma poprawnych odpowiedników w y(n)
m=sqrt(c.^2+y.^2);  %Obwiednia to pierwiastek z sumy kwadratów sygna³ów x i jego transformacji Hilberta HT(x).
%m = m-mean(m);

NFFT=2^nextpow2(fs);
Y=fft(m,NFFT)/fs; %transformata fouriera syg m
f=fs/2*linspace(0,1,NFFT/2+1);
figure(2);
plot(f,2*abs(Y(1:NFFT/2+1)));
title('FFT obwiedni');


%% odczytane parametry sygna³u moduluj¹cego
f1=7;
f2=20;
f3=30;
A1=0.3;
A2=0.1;
A3=0.5;

%% sygna³ moduluj¹cy - suma 3 cosinusow
t=0:1/fs:1-1/fs;
xr=1+A1*cos(2*pi*f1*t)+A2*cos(2*pi*f2*t)+A3*cos(2*pi*f3*t); %sygna³ moduluj¹cy
xr=xr(M+1:1000-M); %odciêcie próbek

%% sygna³ z pliku po transformacie hilberta vs sygna³ skonstruowany
figure(3);
hold all;
plot(m, 'b');
plot(xr,'k*');
title('Porównanie sygna³ów');
legend('FIR - hilbert','odtworzone suma cos'); %dla przejrzystosci mozna wywalic hilberta matlaba

%% sygna³ z pliku zmodulowany vs sygna³ skonstruowany zmodulowany
figure(4)
xp=sin(2*pi*fc*t);  %noœna z treœci
xp=xp(M+1:1000-M);  %odciêcie próbek
xz=xp.*xr;          %sygna³ zmodulowany po odtworzeniu
hold on;
plot(xz,'b');
plot(y,'r*');
legend('Sygna³ skonstruowany i zmod.','Sygna³ zmod. z pliku');
