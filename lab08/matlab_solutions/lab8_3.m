clear all;
close all;

%% parametry 3 sinusów
f1 = 1001.2;fs1 = 8e3;
f2 = 303.1;fs2 = 32e3;
f3 = 2110.4;fs3 = 48e3;

t1 = 0:1/fs1:1-1/fs1;
t2 = 0:1/fs2:1-1/fs2;
t3 = 0:1/fs3:1-1/fs3;

x1 = sin(2*pi*f1*t1);
x2 = sin(2*pi*f2*t2);
x3 = sin(2*pi*f3*t3);

figure(1);
plot(t1,x1,'r');
hold on;
plot(t2,x2,'b');
hold on;
plot(t3,x3,'g');
xlabel('Czas [s]');
ylabel('Amplituda');
title('fragmenty 3 sygna³ow sinusoidalnych');
legend('1001.2Hz','303.1Hz','2110.4Hz');
xlim([0 1/f3]);

%% Suma sygnalow x4 analitycznie
x4 = sin(2*pi*f1*t3) + sin(2*pi*f2*t3) + sin(2*pi*f3*t3);

%% upsampling
x1up = upsample(x1,fs3/fs1); %x1 z 8khz na 48khz *6
x2up = decimate(upsample(x2,3),2); %x2 z 32khz na 96khz i potem co druga probka ->48khz
x4_upsampling = x1up + x2up + x3;

%% resampling
x1re = resample(x1,fs3,fs1); %x1 z 8khz na 48khz *6
[P,Q] = rat(fs3/fs2);
x2re = resample(x2,P,Q); %x2 z 32khz na 96khz i potem co druga probka ->48khz
x4_resampling = x1re + x2re + x3;

%% Porownanie analityczny vs upsampled
figure(2);

subplot(3,1,1);
hold all;
plot(x4, 'r');
plot(x4_upsampling, 'b');
legend('analityczny','upsampling');
title('Sygnal analityczny i upsampling');

subplot(3,1,2);
plot(abs(fft(x4)),'b');
title('Widmo - sygnal analityczny');

subplot(3,1,3);
plot(abs(fft(x4_upsampling)),'b');
title('Widmo - sygnal upsampling');

%{
sound(x4, fs3);
pause(2);
sound(x4_upsampling, fs3);
%}

%% Porownanie analityczny vs resampled
figure(3);

subplot(3,1,1);
hold all;
plot(x4, 'r');
plot(x4_resampling, 'b');
legend('analityczny','resampling');
title('Sygnal analityczny i resampling');

subplot(3,1,2);
plot(abs(fft(x4)),'b');
title('Widmo - sygnal analityczny');

subplot(3,1,3);
plot(abs(fft(x4_resampling)),'b');
title('Widmo - sygnal resampling');

%{
pause(4);
sound(x4, fs3);
pause(2);
sound(x4_resampling, fs3);
%}

%% MIKS x1 i x2
[x1wav, fs1w] = audioread('x1.wav');
[x2wav, fs2w] = audioread('x2.wav');
x1wav = x1wav(:,1)';
x2wav = x2wav';
f_wav = 48e3; %czestotliwosc do ktorej resamplingujemy

%interpolacja wav1
[P1,Q1] = rat(f_wav/fs1w);
x1_resamp = resample(x1wav, P1,Q1);
vector1 = linspace(1, length(x1wav), 1.5*length(x1wav)); %1,5*32kHz ->48kHz
x1wav_interp = interp1(x1wav, vector1);

%interpolacja wav2
[P2,Q2] = rat(f_wav/fs2w);
x2_resamp = resample(x2wav, P2,Q2);
vector2 = linspace(1, length(x2wav), 6*length(x2wav)); %6*8kHz ->48kHz
x2wav_interp = interp1(x2wav, vector2);

miks = x1wav_interp; %sygna³ 1

miks(1:length(x2wav_interp)) = miks(1:length(x2wav_interp)) + x2wav_interp; %sygna³ 2 dodany do 1

sound(miks(1:length(x1wav_interp)), f_wav);





