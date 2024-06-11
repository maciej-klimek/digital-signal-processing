% Load path data
load('PTHd.mat'); % Load PTHd which contains the path points

% Ensure PTHd is a matrix with 3 columns
if size(PTHd, 2) ~= 3
    error('PTHd should have 3 columns representing X, Y, Z coordinates');
end

% Set the distance threshold for segmenting
threshold = 15; % Adjust this value based on your data

% Get the segments and their start/end indices
[segments, segment_indices] = split_path_into_segments(PTHd, threshold);

% Display start and end indices of each segment
disp('Segment start and end indices:');
disp(segment_indices);

% Create a new figure
figure;
hold on;

% Plot the original points
plot3(PTHd(:,1), PTHd(:,2), PTHd(:,3), 'r.', 'MarkerSize', 15);

% Interpolate and plot each segment
for i = 1:length(segments)
    segment = segments{i};
    if size(segment, 1) > 2
        path_spline = cscvn(segment');
        fnplt(path_spline, 'b-', 2);
    else
        plot3(segment(:,1), segment(:,2), segment(:,3), 'b-', 'LineWidth', 2);
    end
end

% Draw an additional line between the 13th point and the 28th point
plot3([PTHd(13, 1), PTHd(28, 1)], [PTHd(13, 2), PTHd(28, 2)], [PTHd(13, 3), PTHd(28, 3)], 'g-', 'LineWidth', 2);

% Adjust plot settings
title('Interpolowana ścieżka środka oskrzela');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
axis equal;
view(3);
legend({'Original Points', 'Interpolated Path', 'Additional Line'}, 'Location', 'Best');
hold on;

% Wizualizacja 3D skanu CT i interpolowanej ścieżki
hold on;

% Wizualizacja obiektu skanu CT
hiso = patch(isosurface(abs(vol_final - 1), 0), 'FaceColor', [1, .75, .65], 'EdgeColor', 'none');
axis tight; box on;
camproj p;
daspect([1 1 1]);
lighting phong;
axis off;
view([0, -45]);
camlight;
alpha(0.5);
grid on;

function [segments, segment_indices] = split_path_into_segments(path, threshold)
    % This function splits a path into segments based on a distance threshold
    % and returns the segments along with their start and end indices
    segments = {};
    segment_indices = [];
    current_segment = path(1, :);
    start_index = 1;

    for i = 2:size(path, 1)
        % Check if the distance to the next point exceeds the threshold
        if norm(path(i, :) - path(i-1, :)) > threshold
            % Save the current segment
            segments{end+1} = current_segment;
            segment_indices = [segment_indices; start_index, i-1];
            % Start a new segment
            current_segment = path(i, :);
            start_index = i;
        else
            % Append the current point to the segment
            current_segment = [current_segment; path(i, :)];
        end
    end
    % Add the last segment
    segments{end+1} = current_segment;
    segment_indices = [segment_indices; start_index, size(path, 1)];
end