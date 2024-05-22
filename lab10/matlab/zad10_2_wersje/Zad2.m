clear all;  close all;

[x,fpr]=audioread('mowa1.wav');	      % wczytaj sygnał mowy (cały)
oryginalny = x;

N=length(x);	  % długość sygnału
Mlen=240;		  % długość okna Hamminga (liczba próbek)
Mstep=180;		  % przesunięcie okna w czasie (liczba próbek)
Np=10;			  % rząd filtra predykcji
gdzie=Mstep+1;	  % początkowe polożenie pobudzenia dźwięcznego

f = (1:Mlen)./fpr;
TT=[];

temp=0;
lpc=[];								   % tablica na współczynniki modelu sygnału mowy
s=[];								   % cała mowa zsyntezowana
ss=[];								   % fragment sygnału mowy zsyntezowany
bs=zeros(1,Np);					   % bufor na fragment sygnału mowy
Nramek=floor((N-Mlen)/Mstep+1);	% ile fragmentów (ramek) jest do przetworzenia
bz1 = [];                          % inicjalizacja bz1 jako pusta tablica

% Wczytaj próbki z pliku coldvox.wav
[coldvox, fpr_coldvox] = audioread('coldvox.wav');
coldvox = coldvox(:, 1); % zakładamy, że plik jest mono

 %% Preemfaza - filtracja wstępna
x=filter([1 -0.9735], 1, x);

for  nr = 1 : Nramek
    % pobierz kolejny fragment sygnału
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    bx = bx - mean(bx);  % usuń wartość średnią
    P = 0.3*max(bx);
    bx = progowanie(bx,P);  % zastosuj progowanie
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    
    offset=20; rmax=max( r(offset : Mlen) );	   % znajdź maksimum funkcji autokorelacji
    imax=find(r==rmax);							   % znajdź indeks tego maksimum
    if ( rmax > 0.35*r(1) ) 
        T=imax; 
    else
        T=0; 
    end % głoska dźwięczna/bezdźwięczna?
    if (T>80) T=round(T/2); end							% obniżenie częstotliwości dla głosek dźwięcznych
    
    % Ustawienie stałej wartości T dla głosek dźwięcznych
    if (T~=0) T=80; end
    
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr;											% oblicz współczynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);										% oblicz jego odp. częstotliwościową
    H2 = 1./H;
    if (temp==0 && T>0)
        bz = conv(bx,H2);
        % Sprawdzenie rozmiaru bz1 i dopasowanie rozmiaru
        if isempty(bz1)
            bz1 = abs(bz(512:end))';
        else
            bz1 = abs(bz(512:end))' + bz1; 
            bz1 = bz1./2;
        end
        temp=1;
    end
    
    lpc=[lpc; T; wzm; a; ];								% zapamiętaj wartości parametrów
    
    % SYNTEZA - odtwórz na podstawie parametrów ------------------------------------------------------
    if (T~=0) gdzie=gdzie-Mstep; end					% przenieś pobudzenie dźwięczne
    for n=1:Mstep
        if( T==0)
            % Użyj próbek z pliku coldvox.wav dla głosek bezdźwięcznych
            pob=2*coldvox(randi(length(coldvox))); gdzie=(3/2)*Mstep+1;			
        else
            if (n==gdzie)                                
                pob = bz1(n);
                gdzie=gdzie+T;	   % pobudzenie dźwięczne
            else
                pob=0; 
            end
        end
        ss(n)=wzm*pob-bs*a;		% filtracja syntetycznego pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesunięcie bufora wyjściowego
    end
    s = [s ss];						% zapamiętanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny
plot(bz1);
soundsc(s, fpr)

% Definicja funkcji progowanie
function bx = progowanie(bx, P)
    bx(abs(bx) < P) = 0;
end
