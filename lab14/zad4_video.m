close all
clear all

% Jazda kamery w drzewie oskrzelowym po ścieżce
load vol_sc; vol = squeeze(vol_sc); clear vol_sc; size(vol),
load PTH;
load PTHs;
load('lok_tab_ct'); % zniekształcenia geometryczne kamery
LineWidth = 3;
is_tr = 0.5; % próg do izosurfice

SE = strel('ball', 1, 1);
N = 3; SE = ones(N, N, N);
SE
vol = imdilate(vol, SE); % pogrubienie drzewa

% Wygładzenie 3-D
tic, vol = smooth3(vol, 'box', 3); toc

FV = isosurface(vol, is_tr);

% Przygotowanie figury do wizualizacji zewnętrznej
figure(1);
hiso = patch(FV, 'FaceColor', [1, .75, .65], 'EdgeColor', 'none');
axis tight; box on
camproj perspective;
daspect([1 1 1]);
lighting phong;
view([0, -83])
hlight = camlight('headlight');
material DULL;

% Przygotowanie do nagrywania wideo
v = VideoWriter('bronchus_animation.avi');
v.FrameRate = 60;
open(v);

% Animacja z rotacją wokół osi najgrubszego oskrzela
for angle = 0:360
    view(angle, 30);
    camlight(hlight, 'headlight');
    drawnow;
    frame = getframe(gcf);
    writeVideo(v, frame);
end


% Jazda kamery w drzewie oskrzelowym - wolniej
ofset = 5;
num_frames = 1000;
step_size = 0.1; % zmniejszenie kroku ruchu kamery
camva(45)
for k = 1:step_size:num_frames
    idx = round(k);
    if (idx + ofset) <= size(PTHs, 1)
        campos([PTHs(idx, 2), PTHs(idx, 1), PTHs(idx, 3)]);
        camtarget([PTHs(idx + ofset, 2), PTHs(idx + ofset, 1), PTHs(idx + ofset, 3)]);
        camlight(hlight, 'headlight');
        drawnow;
        frame = getframe(gcf);
        writeVideo(v, frame);
    end
end

% Zamknięcie pliku wideo
close(v);

disp('Animacja zapisana do pliku bronchus_animation.avi');
