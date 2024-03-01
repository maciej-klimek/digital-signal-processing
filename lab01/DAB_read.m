% Wczytaj sygna³ DAB IQ ze zbioru

  ReadSize = 500000;      % max 500000
  fs_file = 2.048e6;      % czêstotliwoœæ próbkowania w zbiorze
  fs = 2.048e6;           % czêstotliwoœæ próbkowania DAB

% ReadFile = fopen('DAB_real_2.048MHz_IQ_float.dat', 'rb');  % rzeczywisty odebrany DAB ("brudny" - zaszuminy, ...)
  ReadFile = fopen('DAB_synt_2.048MHz_IQ_float.dat', 'rb');  % rzeczywisty nadawany DAB ("czysty" - niezaszumiony,...)

  iq = fread( ReadFile, [2, ReadSize], 'float' );
  x = iq(1,:) + iq(2,:)*i;
  [r, c] = size(x);
  x = reshape(x, c, r);
  if( fs_file ~= fs )
      x = resample(x, fs/1e3, fs_file/1e3);     % signal resampling from fs_file to fs (page 145)
  end

  figure;
  subplot(211); plot(real(x)); title('I (In phase) - real');
  subplot(212); plot(imag(x)); title('Q (In quadrature) - imag');
  
  [PhaseRefSymb, sigPhaseRefSymb ] = PhaseRefSymbGen( 1 );
  figure;
  subplot(211); stem(real(PhaseRefSymb)); title('PhaseRefSymb FREQUENCY (In phase) - real');
  subplot(212); stem(imag(PhaseRefSymb)); title('PhaseRefSymb FREQUENCY (In quadrature) - imag');
  figure;
  subplot(211); plot(real(sigPhaseRefSymb)); title('PhaseRefSymb TIME (In phase) - real');
  subplot(212); plot(imag(sigPhaseRefSymb)); title('PhaseRefSymb TIME (In quadrature) - imag');
  
  
  