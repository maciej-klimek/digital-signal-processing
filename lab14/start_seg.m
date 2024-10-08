close all
clear all

tic
% Segmentacja danych CT obszary w płucach wypełnione powietrzem

load vol; vol = squeeze(vol); size(vol), %figure, hist(double(vol(:)),100)

rv = 2; [x, y, z, vol] = reducevolume(vol, [rv rv rv]); size(vol) % redukcja objętości danych

% Wygładzanie danych
vol = smooth3(vol, 'gaussian', 3);

% Przekształcanie danych do formatu binarnego
I = find(vol < 315); % TUTAJ ZMIENIAM WARTOSC PROGU, default 200, dla 317 pokazuje sie płuco, dla 335 oba 
vol = zeros(size(vol)); 
vol(I) = 1; % ustawienie znalezionych pikseli na wartość 1

% Segmentacja danych używając funkcji bwlabeln
% 6,18,26
[vol_obj, liczba_obj] = bwlabeln(vol, 26); liczba_obj, %figure, hist(vol_obj(:), liczba_obj)
% Wybór drzewa oskrzelowego na podstawie pierwszego slajdu
% Wymagana INTERAKCJA użytkownika do wybrania wlasciwego obiektu

imshow(vol_obj(:, :, 1))
clear vol;
toc
%return

I = find(round(vol_obj) == 2); % uwaga ta wartość podana przez użytkownika
vol = zeros(size(vol_obj)); vol(I) = 1;
% clear vol_obj;
%%%%%%%%%%%%%%%%%% Przegladanie danych CT %%%%%%%%%%%%%%
KK = size(vol, 3);
for k = 1:KK
    A = vol(:, :, k);
    imshow(A, [])
end
KK = size(vol, 1);
for k = 1:KK, k
    A = squeeze(vol(k, :, :));
    imshow((A'), []'),
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
figure
hiso = patch(isosurface(abs(vol-1), 0), 'FaceColor', [1, .75, .65], 'EdgeColor', 'none');
% hiso = patch(isosurface(vol, 1), 'FaceColor', [1, .75, .65], 'EdgeColor', 'none');
axis tight; box on
camproj p;
daspect([1 1 1]);
lighting phong, axis off
view([0, -45])
camlight;
% alpha(0.5)
toc
% vol_s=vol; save('vol_s', 'vol_s'), beep

