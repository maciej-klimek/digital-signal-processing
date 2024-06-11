% Załadowanie danych z pliku vol.mat
data = load('vol.mat'); % trójwymiarowa macierz
vol = data.vol;  

% Wybór przecięć do wizualizacji
slice_x = round(size(vol, 1) / 2); % Środkowy przekrój w osi x
slice_y = round(size(vol, 2) / 2); % Środkowy przekrój w osi y
slice_z = round(size(vol, 3) / 2); % Środkowy przekrój w osi z

% Wyświetlenie przecięć
% squeeze usuwa jeden wymiar aby można było zrobić 2D
figure;
subplot(1, 3, 1);
imagesc(squeeze(vol(slice_x, :, :))); 
colormap(gray);
title('Przekrój w osi X');

subplot(1, 3, 2);
imagesc(squeeze(vol(:, slice_y, :)));
colormap(gray);
title('Przekrój w osi Y');

subplot(1, 3, 3);
imagesc(squeeze(vol(:, :, slice_z)));
colormap(gray);
title('Przekrój w osi Z');
