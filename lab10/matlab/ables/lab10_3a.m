% ----------------------------------------------------------
% Tabela 19-4 (str. 567)
% ï¿½wiczenie: Kompresja sygnaï¿½u mowy wedï¿½ug standardu LPC-10
% ----------------------------------------------------------

clear all; clf; close all;

[x,fpr]=audioread('mowa1.wav');% wczytaj sygnaï¿½ mowy (caï¿½y)
[cv, fpr2] = audioread('coldvox.wav');

plot(x); title('sygnaï¿½ mowy');	% pokaï¿½ go
							% oraz odtwï¿½rz na gï¿½oï¿½nikach (sï¿½uchawkach)

N=length(x);	  % dï¿½ugoï¿½ï¿½ sygnaï¿½u
Mlen=240;		  % dï¿½ugoï¿½ï¿½ okna Hamminga (liczba prï¿½bek)
Mstep=180;		  % przesuniï¿½cie okna w czasie (liczba prï¿½bek)
Np=10;			  % rzï¿½d filtra predykcji
gdzie=Mstep+1;	  % poczï¿½tkowe poï¿½oï¿½enie pobudzenia dï¿½wiï¿½cznego

lpc=[];								   % tablica na wspï¿½czynniki modelu sygnaï¿½u mowy
s=[];									   % caï¿½a mowa zsyntezowana
ss=[];								   % fragment sygnaï¿½u mowy zsyntezowany
bs=zeros(1,Np);					   % bufor na fragment sygnaï¿½u mowy
Nramek=floor((N-Mlen)/Mstep+1);	% ile fragmentï¿½w (ramek) jest do przetworzenia

x=filter([1 -0.9735], 1, x);	% filtracja wstï¿½pna (preemfaza) - opcjonalna

for  nr = 1 : Nramek
    
    % pobierz kolejny fragment sygnaï¿½u
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    bx = bx - mean(bx);  % usuï¿½ wartoï¿½ï¿½ ï¿½redniï¿½
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    
%     subplot(411); plot(n,bx); title('fragment sygnaï¿½u mowy');
%     subplot(412); plot(r); title('jego funkcja autokorelacji');
    
    offset=20; rmax=max( r(offset : Mlen) );	   % znajdï¿½ maksimum funkcji autokorelacji
    imax=find(r==rmax);								   % znajdï¿½ indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % gï¿½oska dï¿½wiï¿½czna/bezdï¿½wiï¿½czna?
    
     if (T>80) T=round(T/2); end							% znaleziono drugï¿½ podharmonicznï¿½
    T=0;							   							% wyï¿½wietl wartoï¿½ï¿½ T
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr;											% oblicz wspï¿½czynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);										% oblicz jego odp. czï¿½stotliwoï¿½ciowï¿½
%     subplot(413); plot(abs(H)); title('widmo filtra traktu gï¿½osowego');
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
    
    lpc=[lpc; T; wzm; a; ];								% zapamiï¿½taj wartoï¿½ci parametrï¿½w
    
    % SYNTEZA - odtwï¿½rz na podstawie parametrï¿½w ----------------------------------------------------------------------
    % T = 0;                                        % usuï¿½ pierwszy znak ï¿½%ï¿½ i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end					% ï¿½przenieï¿½ï¿½ pobudzenie dï¿½wiï¿½czne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            %pob=2*(rand(1,1)-0.5);
            pob=cv(n);
            gdzie=(3/2)*Mstep+1;			% pobudzenie szumowe
        else
            pob=resztkowy(n);           %wykorzystnie sygna³u resztkowego
        end
        ss(n)=wzm*pob-bs*a;		% filtracja ï¿½syntetycznegoï¿½ pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesunï¿½cie bufora wyjï¿½ciowego
    end
%     subplot(414); plot(ss); title('zsyntezowany fragment sygnaï¿½u mowy'); pause
    s = [s ss];						% zapamiï¿½tanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

figure; plot(s); title('mowa zsyntezowana');
%soundsc(x,fpr); pause(1);
soundsc(s, fpr)
