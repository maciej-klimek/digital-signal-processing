clc;
clear all;
close all;

%% 1.
img = imread('im1.png');        % wczytaj obraz
img_dct2 = dct2(img);           % wyznacz dct2
img_idct2 = idct2(img_dct2);    % wyznacz idct2 na dct2 (powrót do stanu z początku)

% Petla szukajaca wspolczynnikow znaczacych
for i = 1:length(img_dct2)
    for j = 1:length(img_dct2)
        if(img_dct2(i,j)>100)
            fprintf('Wspolczynnik znaczacy: %d %d', i, j);
            fprintf('\n');
        end
    end
end

% zerowanie "polowy" wspol. zn.
img_0dct2 = img_dct2;
%img_0dct2(1,1)  = 0;
img_0dct2(1,12) = 0;
%img_0dct2(12,1) = 0;

% IDCT2 na DCT2 z wyzerowaną połową wspol. zn.
img_0idct2 = idct2(img_0dct2);

% wyswietl obraz oryginalny
figure;
subplot(2,3,1);
imagesc(img);
set(gca,'DataAspectRatio',[1 1 1]);
title('Obraz oryginalny');

subplot(2,3,4);
imagesc(img);
set(gca,'DataAspectRatio',[1 1 1]);
title('Obraz oryginalny');

% wyswietl obraz po DCT2
subplot(2,3,2);
imagesc(img_dct2);
set(gca,'DataAspectRatio',[1 1 1]);
title('Po DCT2');

% wyswietl obraz po IDCT2 bez zerowania wspol. zn.
subplot(2,3,3);
imagesc(img_idct2);
set(gca,'DataAspectRatio',[1 1 1]);
title('Po IDCT2 bez zerowania wspol. zn.');

% wyswietl obraz po DCT2 z wyzerowaną połową wspol. zn.
subplot(2,3,5);
imagesc(img_0dct2);
set(gca,'DataAspectRatio',[1 1 1]);
title('DCT2 Po wyzerowaniu wspol. zn.');

% wyswietl obraz po IDCT2 na DCT2 z wyzerowaną połową wspol. zn.
subplot(2,3,6);
imagesc(img_0idct2);
set(gca,'DataAspectRatio',[1 1 1]);
title('IDCT2 Po wyzerowaniu wspol. zn.');