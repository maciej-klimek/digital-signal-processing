clear all
close all
clc
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
high = true;
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
img2_rek_a = abs(idct2(img2_dct2_a));

% plot
subplot(2,5,5);
imshow(img2_rek_a, cmap);
title("Obraz rekonstruowany a");

%% Podpunkt B

threshold = 50; %!!!!!!!!!!!!!!!!!!
img2_dct2_b(abs(img2_dct2_b) < threshold) = 0;

% plot
subplot(2,5,9);
imshow(img2_dct2_b);
title("Threshold "+ threshold);

% idct
img2_rek_b = idct2(img2_dct2_b);
img2_rek_b = rescale(img2_rek_b);

% plot
subplot(2,5,10);
imshow(img2_rek_b);
title("Obraz rekonstruowany b");