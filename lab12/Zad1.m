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
        if(img_dct2(i,j)>10)
            fprintf('Wspolczynnik znaczacy: %d %d', i, j);
            fprintf('\n');
        end
    end
end

% zerowanie "polowy" wspol. zn.
img_0dct2 = img_dct2;
% img_0dct2(1,1)  = 0;
img_0dct2(1,12) = 0;
% img_0dct2(12,1) = 0;

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

%% 2.
[img2, cmap] = imread("cameraman.tif");     % wczytaj obraz
img2_dct2_a = dct2(img2);                   % wyznacz dct2
img2_dct2_b = dct2(img2);

% plot
figure;
subplot(2,5,1);
imshow(img2);
title('Obraz oryginalny');

subplot(2,5,6);
imshow(img2);
title('Obraz oryginalny');

subplot(2,5,2);
imshow(img2_dct2_a);
title("DCT obrazu a");

subplot(2,5,7);
imshow(img2_dct2_b);
title("DCT obrazu b");

%% Podpunkt A

% Filtr LP/HP
high = false;
[M, N, K] = size(img2);

% wartosci maski filtra LP w dziedzinie 2D-DCT
K = 128;
H = myTriangleMask(M, N, K);

% wartosci maski filtra HP w dziedzinie 2D-DCT
if high
    H = ones(M,N) - H;
end

subplot(2,5,3);
imshow(H);
t = "Maska filtra ";
if high
    t = t + "High Pass";
else
    t = t + "Low Pass";
end
title(t);

% filtracja (% iloczyn widma DCT i maski) - wyzerowanie czestotliwosci
img2_dct2_a = img2_dct2_a.*H; 

% plot
subplot(2,5,4);
imshow(img2_dct2_a);
title("Wyzerowanie czestotliwosci - filtracja");

% idct
img2_rek_a = idct2(img2_dct2_a);

% plot
subplot(2,5,5);
imshow(img2_rek_a, cmap);
title("Obraz rekonstruowany a");

%% Podpunkt B

threshold = 100;
img2_dct2_b(abs(img2_dct2_b) < threshold) = 0;

% plot
subplot(2,5,9);
imshow(img2_dct2_b);
title("Threshold 200");

% idct
img2_rek_b = idct2(img2_dct2_b);
img2_rek_b = rescale(img2_rek_b);

% plot
subplot(2,5,10);
imshow(img2_rek_b);
title("Obraz rekonstruowany b");

%% 3
% generacja obrazów bazowych
IM1 = zeros(128, 128);
IM1(2, 10) = 1;
im1 = idct2(IM1);

IM2 = zeros(128, 128);
IM2(7, 28) = 1;
im2 = idct2(IM2);

IM3 = zeros(128, 128);
IM3(70, 120) = 1;
im3 = idct2(IM3);

IM4 = zeros(128, 128);
IM4(111, 20) = 1;
im4 = idct2(IM4);

figure;
subplot(2,4,1);
imshow(IM1);
title("IM1");
subplot(2,4,2);
imshow(rescale(im1));
title("im1");

subplot(2,4,3);
imshow(IM2);
title("IM2");
subplot(2,4,4);
imshow(rescale(im2));
title("im2");

subplot(2,4,5);
imshow(IM3);
title("IM3");
subplot(2,4,6);
imshow(rescale(im3));
title("im3");

subplot(2,4,7);
imshow(IM4);
title("IM4");
subplot(2,4,8);
imshow(rescale(im4));
title("im4");

% generujemy nowy obrazek 128x128
% suma obrazów bazowych
im = im1 + im2 + im3 + im4;

% wyznacz dct2
IM = dct2(im);

figure;
subplot(1,4,1);
imshow(rescale(im));
title("Obraz sumaryczny");

% analiza obrazu sumarycznego
subplot(1,4,2);
imshow(IM); title('DCT2 obrazu sumarycznego');

% szukamy wspolrzednych 3-5 pikselow aby je potem moc wyzerowac
for i = 1:length(IM)
    for j = 1:length(IM)
        if(abs(IM(i,j))>0.99)
            fprintf('Zapalony piksel w: %d %d', i, j);
            fprintf('\n');
        end
    end
end

% zostawiamy tylko jeden zapalony wspolczynnik
% wyłaczanie pikseli
IM(2, 10) = 0;          % IM 1
IM(7, 28) = 0;          % IM 2
% IM(70, 120) = 0;      % IM 3
IM(111, 20) = 0;        % IM 4

im = idct2(IM);
subplot(1,4,3);
imshow(rescale(im)); 
title('DCT2 obrazu sum. - wyzerowane wsp.');

im = im - im3;
subplot(1,4,4);
imagesc(im); 
set(gca,'DataAspectRatio',[1 1 1]);
colorbar;
title('Roznica im wyzerowanego i jego niewyzerowanej skladowej');

%% 4. 
img = imread('im2.png');    % wczytaj obraz
img = double(img);

figure;
subplot(1,4,1);
imshow(img);
title("Oryginalny obraz");

% dct2
img_dct2 = dct2(img);

subplot(1,4,2);
imshow(img_dct2);
title("Matlabowe dct");

% my dct 2D
IMG = zeros(128, 128);
for i = 1 : 128
    row = img(i, :);
    ROW = dct(row);
    IMG(i, :) = ROW;
end

subplot(1,4,3);
imshow(IMG);
title("Pół mojego dct");

for i = 1 : 128
    col = IMG(:, i);
    COL = dct(col);
    IMG(:, i) = COL;
end

subplot(1,4,4);
imshow(IMG);
title("Moje dct");
