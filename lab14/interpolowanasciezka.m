% Załaduj dane z pliku PTHd.mat
data = load('PTHd.mat');
points = data.PTHd;

% Przekształć punkty do formatu odpowiedniego dla funkcji scatteredInterpolant
x = points(:, 1);
y = points(:, 2);
z = points(:, 3);

% Użyj funkcji scatteredInterpolant do interpolacji dla każdej współrzędnej
F = scatteredInterpolant(x, y, z, 'natural', 'linear');

% Tworzenie drobniejszej siatki dla interpolacji

x_fine = linspace(min(x), max(x), 1000);
y_fine = linspace(min(y), max(y), 1000);

[X_fine, Y_fine] = meshgrid(x_fine, y_fine);
Z_fine = F(X_fine, Y_fine);

% Rysowanie oryginalnych punktów i wygładzonej linii
figure;
hold on;
plot3(x, y, z, 'bo', 'DisplayName', 'Points');
mesh(X_fine, Y_fine, Z_fine, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
title('Smoothed Curve Representing the Center of the Bronchus');
hold off;

% Ustawienia dla lepszej wizualizacji
axis equal;
view(3); % Ustawienie widoku 3D
rotate3d on; % Włączenie interaktywnej rotacji
