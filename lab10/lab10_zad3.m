% ----------------------------------------------------------
% Tabela 19-4 (str. 567)
% ďż˝wiczenie: Kompresja sygnaďż˝u mowy wedďż˝ug standardu LPC-10
% ----------------------------------------------------------

clear all; clf; close all;

[x,fpr]=audioread('mowa1.wav');% wczytaj sygnaďż˝ mowy (caďż˝y)
[cv, fpr2] = audioread('coldvox.wav');

plot(x); title('sygnaďż˝ mowy');	% pokaďż˝ go
							% oraz odtwďż˝rz na gďż˝oďż˝nikach (sďż˝uchawkach)

N=length(x);	  % dďż˝ugoďż˝ďż˝ sygnaďż˝u
Mlen=240;		  % dďż˝ugoďż˝ďż˝ okna Hamminga (liczba prďż˝bek)
Mstep=180;		  % przesuniďż˝cie okna w czasie (liczba prďż˝bek)
Np=10;			  % rzďż˝d filtra predykcji
gdzie=Mstep+1;	  % poczďż˝tkowe poďż˝oďż˝enie pobudzenia dďż˝wiďż˝cznego

lpc=[];								   % tablica na wspďż˝czynniki modelu sygnaďż˝u mowy
s=[];									   % caďż˝a mowa zsyntezowana
ss=[];								   % fragment sygnaďż˝u mowy zsyntezowany
bs=zeros(1,Np);					   % bufor na fragment sygnaďż˝u mowy
Nramek=floor((N-Mlen)/Mstep+1);	% ile fragmentďż˝w (ramek) jest do przetworzenia

x=filter([1 -0.9735], 1, x);	% filtracja wstďż˝pna (preemfaza) - opcjonalna

for  nr = 1 : Nramek
    
    % pobierz kolejny fragment sygnaďż˝u
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    bx = bx - mean(bx);  % usuďż˝ wartoďż˝ďż˝ ďż˝redniďż˝
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    
%     subplot(411); plot(n,bx); title('fragment sygnaďż˝u mowy');
%     subplot(412); plot(r); title('jego funkcja autokorelacji');
    
    offset=20; rmax=max( r(offset : Mlen) );	   % znajdďż˝ maksimum funkcji autokorelacji
    imax=find(r==rmax);								   % znajdďż˝ indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % gďż˝oska dďż˝wiďż˝czna/bezdďż˝wiďż˝czna?
    
     if (T>80) T=round(T/2); end							% znaleziono drugďż˝ podharmonicznďż˝
    T=0;							   							% wyďż˝wietl wartoďż˝ďż˝ T
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr;											% oblicz wspďż˝czynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);										% oblicz jego odp. czďż˝stotliwoďż˝ciowďż˝
%     subplot(413); plot(abs(H)); title('widmo filtra traktu gďż˝osowego');
%     if ( T~=0)
%         resztkowy = filter([1;a], 1, x(n));
%         figure; subplot(2, 1, 1); plot(resztkowy);
%         df=(fpr/length(resztkowy))/2; 
%         f = df * (0:length(resztkowy)-1);
%         Reszt = fft(resztkowy);
%         [~,maxpos]=max(Reszt);
%         T=1/(2*pi*f(maxpos));
%         %subplot(2, 1, 2); plot(f, Reszt);
%         
%     end
    
    lpc=[lpc; T; wzm; a; ];								% zapamiďż˝taj wartoďż˝ci parametrďż˝w
    
    % SYNTEZA - odtwďż˝rz na podstawie parametrďż˝w ----------------------------------------------------------------------
    % T = 0;                                        % usuďż˝ pierwszy znak ďż˝%ďż˝ i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end					% ďż˝przenieďż˝ďż˝ pobudzenie dďż˝wiďż˝czne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            %pob=2*(rand(1,1)-0.5);
            pob=cv(n);
            gdzie=(3/2)*Mstep+1;			% pobudzenie szumowe
        else
            pob=resztkowy(n);           %wykorzystnie sygnału resztkowego
        end
        ss(n)=wzm*pob-bs*a;		% filtracja ďż˝syntetycznegoďż˝ pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesunďż˝cie bufora wyjďż˝ciowego
    end
%     subplot(414); plot(ss); title('zsyntezowany fragment sygnaďż˝u mowy'); pause
    s = [s ss];						% zapamiďż˝tanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

figure; plot(s); title('mowa zsyntezowana');
%soundsc(x,fpr); pause(1);
soundsc(s, fpr)
