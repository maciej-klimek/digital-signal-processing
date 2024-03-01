
% ##############################################
% RADIO FM: parametry dla nadajnika i odbiornika
% Autor: Tomasz ZIELINSKI, tzielin@agh.edu.pl

% ########################################################
% INICJOWANIE WARTOSCI PARAMETROW, ZAPROJEKTOWANIE FILTROW
% Program fm_param.m
  fs = 1e6;         % czestotliwosc probkowania sygnalu szerokopasmowego FM
  fpilot = 19000;      % czestotliwosc pilota [Hz]
  fsymb = fpilot/16;   % czestotliwosc probkowania symboli RDS, 1187.5 Hz
  fstereo = 2*fpilot;  % czestotliwosc nosnej sygnalu L-R, 38000 Hz
  frds = 3*fpilot;     % czestotliwosc nosnej danych RDS, 57000 Hz
  Abw = 25000;         % zalozona szerokosc pasma sygnalu audio
  L = 500;             % dlugosc zastosowanych filtrow nierekursywnych
  dt = 1/fs;           % okres probkowania

% Filtr pre-fazy i de-emfazy
  f1 = 2120; tau1 = 1/(2*pi*f1); w1 = tan(1/(2*Abw*tau1));
  b_de = [w1/(1+w1), w1/(1+w1)]; a_de = [1, (w1-1)/(w1+1)];
  b_pre = a_de; a_pre = b_de;
  
 
% Filtr ksztaltowania impulsow (PSF - pulse shaping filter)
  Tsymb = 1/fsymb;         % czas trwania symbolu RDS
  Nsymb = fs/fsymb;        % liczba probek na symbol RDS (210.5263158)
  Nsymb4 = floor(4*Nsymb); % liczba probek 4 symboli
  df = fs/Nsymb4; f = 0 : df : 2/Tsymb; Nf=length(f); % widmo z normy
  H = zeros(1, Nsymb4); H(1:Nf) = cos(pi*f*Tsymb/4); H(end:-1:end-(Nf-2))=H(2:Nf);
  hpsf = fftshift(ifft(H)); hpsf=hpsf/max(hpsf); % odp. impulsowa
    
  hpsf2 = firrcos( Nsymb4, fsymb, 1.0, fs,'rollof','sqrt');  % odp. impuls #2
  hpsf2 = hpsf2/max(hpsf2); hpsf2 = hpsf2(1:end-1);
  n=1:length(hpsf); n2=1:length(hpsf2);
  
  phasePSF = angle( exp(-j*2*pi*fsymb/fs*[0:Nsymb4-1]) * hpsf' ); % przes. fazowe
  
% Filtr dolnoprzepustowy LowPass do odzyskania sygnalu L+R
  hLPaudio = fir1(L,(Abw/2)/(fs/2),kaiser(L+1,7));

% Filtr waskopasmowy BandPass do odzyskania sygnalu pilota (wokol 19 kHz)
  fcentr = fpilot; df1 = 1000; df2 = 2000;
  ff = [ 0 fcentr-df2 fcentr-df1 fcentr+df1 fcentr+df2 fs/2 ]/(fs/2);
  fa = [ 0 0.01 1 1 0.01 0 ];
  hBP19 = firpm(L,ff,fa);

% Filtr szerokopasmowy BandPass do odzyskania sygnalu L-R (wokol 38 kHz)
  fcentr = fstereo; df1 = 10000; df2 = 12500;
  ff = [ 0 fcentr-df2 fcentr-df1 fcentr+df1 fcentr+df2 fs/2 ]/(fs/2);
  fa = [ 0 0.01 1 1 0.01 0 ];
  hBP38 = firpm(L,ff,fa);

% Filtr waskopasmowy BandPass do odzyskania sygnalu RDS (wokol 57 kHz)
  fcentr = frds; df1 = 2500; df2 = 5000;
  ff = [ 0 fcentr-df2 fcentr-df1 fcentr+df1 fcentr+df2 fs/2 ]/(fs/2);
  fa = [ 0 0.01 1 1 0.01 0 ];
  hBP57 = firpm(L,ff,fa);
  