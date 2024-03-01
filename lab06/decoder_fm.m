% odbiornik FM: P. Swiatkiewicz, T. Twardowski, T. Zielinski, J. Bułat

clear all; close all;

fs = 3.2e6;         % sampling frequency
N  = 32e6;         % number of samples (IQ)
fc = 0.50e6;        % central frequency of MF station

bwSERV = 80e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 16e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);

s = s-127;

% IQ --> complex
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;

% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');

% Filter out the service from the wide-band signal
b=????
a=????
wideband_signal_filtered = filter( b, a, wideband_signal_shifted );

% Down-sample to service bandwidth - bwSERV = new sampling rate
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );

% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );

% Decimate to audio signal bandwidth bwAUDIO
y = ...                  % antyaliasing filter
ym = y(bwSERV/bwAUDIO);  % decimate (1/5)

% De-emfaza
% (...)

% Listen to the final result
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
soundsc( ym, bwAUDIO*2);
