clear all
close all
clc
%% 4. 
img = imread('im2.png');    % wczytaj obraz
img = double(img);
%img(20, 10)=100;
figure;
subplot(1,2,1);
imshow(img);

title("Oryginalny obraz");

% dct2
img_dct2 = dct2(img);

subplot(1,2,2);
imshow(img_dct2);
title("dct2");


figure;
test = img;
test(128,128)=0;
test_dct=dct2(test);
subplot(1, 2, 1);
imshow(test);
subplot(1, 2, 2)
imshow(test_dct);