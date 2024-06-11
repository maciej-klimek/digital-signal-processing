close all
clear all

% Load data
load vol_sc; vol = squeeze(vol_sc); clear vol_sc;
load PTH;
load PTHs;
load('lok_tab_ct'); % geometric distortions of the camera

% Parameters
LineWidth = 3;
is_tr = 0.5; % threshold for isosurface

% Structuring element
SE = strel('ball', 1, 1);
N = 3; SE = ones(N, N, N);

% Volume dilation
vol = imdilate(vol, SE);

% Smooth volume
tic, vol = smooth3(vol, 'box', 3); toc

% Generate isosurface
FV = isosurface(vol, is_tr);

% Visualization setup
figure(2);
set(gcf, 'Position', [5 315 369 382]);
hiso = patch(FV, 'FaceColor', [1, .75, .65], 'EdgeColor', 'none');
axis tight; box on
camproj perspective;
daspect([1 1 1]);
lighting phong;
view([0, -83])
hlight = camlight('headlight');
material DULL
camva(45);

% Create video writer
outputVideo = VideoWriter('bronchial_tree_flight.avi');
outputVideo.FrameRate = 10;
open(outputVideo);

% Camera flight through the bronchial tree
ofset = 5;
for k = 1:1:154 %size(PTHs,1)-ofset-1
    campos([PTHs(k, 2), PTHs(k, 1), PTHs(k, 3)]);
    camtarget([PTHs(k + ofset, 2), PTHs(k + ofset, 1), PTHs(k + ofset, 3)]);
    camlight(hlight, 'headlight');
    drawnow
    F = getframe(gcf);
    writeVideo(outputVideo, F);
end

% External rotation around the thickest bronchus
numFrames = 360; % Number of frames for a full rotation
theta = linspace(0, 2*pi, numFrames);
radius = 50; % Radius for the circular path around the thickest bronchus

for t = 1:numFrames
    campos([radius * cos(theta(t)) + PTHs(1, 2), radius * sin(theta(t)) + PTHs(1, 1), PTHs(1, 3)]);
    camtarget([PTHs(1, 2), PTHs(1, 1), PTHs(1, 3)]);
    camlight(hlight, 'headlight');
    drawnow
    F = getframe(gcf);
    writeVideo(outputVideo, F);
end

% Close video writer
close(outputVideo);

disp('Video saved as bronchial_tree_flight.avi');
