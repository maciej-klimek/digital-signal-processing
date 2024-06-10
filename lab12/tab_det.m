close all; clear all; clc
I = imread('car1.jpg');
% ---- ewentualne przejœcie do skali szaroœci
I1 =  double(rgb2gray(I));
figure; imshow(I1,[]); title('I1 - bazowy')

%----- filtracja wstêpna:generowanie maski filtru Gaussa lub innego filtru
h = fspecial('gaussian', , ); % generowanie maski filtru Gaussa...
% h = [];  % generowanie maski innego filtru...
I2 = imfilter(I1, h); figure;imshow(I2,[]);title('I2 - po filtracji wstêpnej')
I2 = quant(I2,1); % kwantyzacja po filtracji [0 255]

% -----  dobór progu ------
imcontrast  

lt =   ;      % dolny prog binaryzacji
ut =   ;     % gorny prog binaryzacji

% ----- binaryzacja -------
B1 = I2; 
B1(B1<lt)=0; % usuniêcie pikseli o wartoœciach mniejszych od lt 
B1(B1>ut)=0; % usuniêcie pikseli o wartoœciach wiêkszych od ut 
B1(B1>0) = 1; % przypisanie pozosta³ym o wartoœciom 1
figure;imshow(B1,[]);title('B1 - po binaryzacji')

% -- operacje morfologiczne (kolejnoœæ i liczba iteracji do wyboru):
B1 = bwmorph(B1,'dilate',1);figure;imshow(B1,[]);title('B1 - po operacji morfologicznej dylatacji')
B1 = bwmorph(B1,'erode',1);figure;imshow(B1,[]);title('B1 - po operacji morfologicznej erozji')
B1 = imfill(B1,4,'holes');figure;imshow(B1,[]);title('B1 - po operacji morfologicznej wype³anienia')
B1 = bwareaopen(B1,  ); figure;imshow(B1,[]);title('B1 - po operacji morfologicznej usuniêcia elementów o powierzchni mniejszej ni¿ X pikseli')

% -- detekcja krawêdzi (kolejnoœæ i liczba iteracji do wyboru):

Isob = edge(B1,'sobel'); figure; imshow(Isob,[]); title('Detekcja krawêdzi filtrem Sobela')
Ican = edge(B1,'canny', ); figure; imshow(Ican,[]); title('Detekcja krawêdzi filtrem Cannego')