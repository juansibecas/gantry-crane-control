% Animation of an overhead crane moving containers
clear bayContainerHandles shipContainerHandles
% Define animation parameters
DS = 100;
timeDS = downsample(time, DS);
xlDS = downsample(xl_log.Data, DS);
ylDS = downsample(yl_log.Data, DS);
xtDS = downsample(xt_real_log.Data, DS);
massDS = downsample(real_mass_log.Data, DS);

% Calculate the downsampling ratio (discrete signal vectors different size)
size1 = length(timeDS);  % Target size (number of elements)
size2 = length(mode_log.Data);  % Original size

% Resample v1 to have the same length as v2
modeDS = int8(resample(double(mode_log.Data), size1, size2));
est_massDS = resample(est_mass_log.Data, size1, size2);
tlkDS = int8(resample(double(tlk_log.Data), size1, size2));

numSteps = length(timeDS);      % Number of time steps

% Create figure for animation
fig = figure;
hold on;
title('STS Gantry Crane - Ship 4 to Bay 1');
ax = gca;
ax.YAxisLocation = 'right';

% Initialize static plot objects
floorHandle = rectangle('Position', [-30 -20 30 20], 'FaceColor', 'black');
craneColumn1Handle = rectangle('Position', [-30 0 2 47], 'FaceColor', 'yellow');
craneColumn2Handle = rectangle('Position', [-2 0 2 47], 'FaceColor', 'yellow');
craneBeamHandle = rectangle('Position', [-30 Yt0 80 2], 'FaceColor', 'yellow');
bay1Handle = rectangle('Position', [-23.25 0 Hc 1], 'FaceColor', 'black');
bay2Handle = rectangle('Position', [-16.25 0 Hc 1], 'FaceColor', 'black');
bay3Handle = rectangle('Position', [-9.25 0 Hc 1], 'FaceColor', 'black');
sillBeamHandle = rectangle('Position', [-2 0 2 15], 'FaceColor', 'black');
shipWall1Handle = rectangle('Position', [0.5 -20 1 25], 'FaceColor', 'blue');
shipWall2Handle = rectangle('Position', [24 -20 1 25], 'FaceColor', 'blue');
shipFloorHandle = rectangle('Position', [1.5 -20 23.5 1], 'FaceColor', 'blue');

% Initialize dynamic plot objects
cartHandle = rectangle('Position', [xtd0-1.5 Yt0 3 2], 'FaceColor', 'red');
spreaderHandle = rectangle('Position', [xl0-Hc/2 yl0 Hc 1], 'FaceColor', 'red');

cable1Handle = plot([xtd0-Hc/2, xl0-Hc/2], [Yt0, yl0], 'black', 'lineWidth', 2);
cable2Handle = plot([xtd0+Hc/2, xl0+Hc/2], [Yt0, yl0], 'black', 'lineWidth', 2);

% Text objects

textMode = text(30, 40, 'Mode: ');
displayMsg = {'Exit Manual', 'Automatic', 'Manual Pick Up', 'Manual Drop', 'Manual', 'Standby', 'Homing', 'Mass Estimation'};
textMass = text(30, 35, 'Mass: ');
textEstMass = text(30, 30, 'Est Mass: ');
textTLK = text(30, 25, 'TLK: ');
tlkMsg = {'OFF', 'ON'};

textY = annotation('textbox',[0.02, 0.025, 0.05, 0.05], 'String', strcat('yl= ', yl0), 'EdgeColor', 'None');
textX = annotation('textbox',[0.1, 0.02, 0.05, 0.05], 'String', strcat('xl= ', xl0), 'EdgeColor', 'None');

% Initialize ship lower containers

colors = ['#0072BD'; '#D95319'; '#EDB120'; '#7E2F8E'; '#77AC30'; '#4DBEEE'; '#A2142F'];
n_container = 1;

for i = 1:length(containerLayout)
    x_container = 1.5 + (i-1)*Hc;
    for j = 1:containerLayout(i)-1
       y_container = -19 + (j-1)*Hc;
       container_color = colors(n_container,:);
       rectangle('Position', [x_container y_container Hc Hc], 'FaceColor', container_color);
       n_container = n_container + 1;
       if n_container > 6
           n_container = 1;
       end
    end
end

% Initialize ship top containers
shipContainerHandles = [];
for i = 1:length(containerLayout)
    x_container = 1.5 + (i-1)*Hc;
    y_container = -19 + (containerLayout(i)-1)*Hc;
    container_color = colors(n_container,:);
    shipContainerHandles = [shipContainerHandles rectangle('Position', [x_container y_container Hc Hc], 'FaceColor', container_color)];
    n_container = n_container + 1;
    if n_container > 6
           n_container = 1;
    end
end

% Initialize shore containers
bayContainerHandles = [];
for i = 1:length(bayLayout)
    if bayLayout(i) == 0
        bayContainerHandles = [bayContainerHandles rectangle('Position', [0 0 0 0])];
        continue
    end
    for j = 1:bayLayout(i)
        x_container = -23.25 + (i-1)*7;
        y_container = 1 + Hc*(j-1);
        container_color = colors(n_container,:);
        if j == bayLayout(i)
            bayContainerHandles = [bayContainerHandles rectangle('Position', [x_container y_container Hc Hc], 'FaceColor', container_color)];
        else
            rectangle('Position', [x_container y_container Hc Hc], 'FaceColor', container_color)
        end
        n_container = n_container + 1;
        if n_container > 6
               n_container = 1;
        end
    end
end


% Define video file name and parameters
videoFileName = 'output_video.mp4';  % Output video file name
frameRate = 50;                      % Frame rate (e.g., 30 frames per second)

% Create a VideoWriter object
vid = VideoWriter(videoFileName);
vid.FrameRate = frameRate;  % Set the frame rate

% Open the VideoWriter object
open(vid);

% Animation loop
TLK_prev = 0;
for i = 1:numSteps - 1
    % Update cart position
    set(cartHandle, 'Position', [xtDS(i)-1.5, Yt0, 3 2]);
    
    % Update spreader position
    set(spreaderHandle, 'Position', [xlDS(i)-Hc/2 ylDS(i) Hc 1]);
    
    % Update cables
    set(cable1Handle, 'XData', [xtDS(i)-Hc/2, xlDS(i)-Hc/2], 'YData', [Yt0, ylDS(i)]);
    set(cable2Handle, 'XData', [xtDS(i)+Hc/2, xlDS(i)+Hc/2], 'YData', [Yt0, ylDS(i)]);
    
    % Update text
    set(textMode, 'String', strcat('Mode: ', displayMsg{modeDS(i)+1}));
    set(textMass, 'String', strcat('Mass: ', num2str(massDS(i))));
    set(textEstMass, 'String', strcat('Est Mass: ', num2str(round(est_massDS(i)))));
    set(textTLK, 'String', strcat('TLK: ', tlkMsg{tlkDS(i)+1}));
    textXPos = 0.1 + 0.8*(xlDS(i)+30)/80;
    set(textX, 'String', strcat('xl=', num2str(round(xlDS(i), 2)), 'm'), 'Position', [textXPos , 0.02, 0.05, 0.05]);
    textYPos = 0.1 + 0.8*(ylDS(i)+20)/70;
    set(textY, 'String', strcat('yl=', num2str(round(ylDS(i), 2)), 'm'), 'Position', [0.02, textYPos, 0.05, 0.05]);
    
    %%%%%%% CONTAINER PICK UP AND DROP LOGIC TODO
    if TLK_prev == 0
        if tlkDS(i) == 1  % container picked up
            % select container handle
            % function that picks container based on the xl position
            % from bayContainerHandles and shipContainerHandles
            if xlDS(i) > 0
                [~, idx] = min(abs(X_container - xlDS(i)));
                pickedContainerHandle = shipContainerHandles(idx);
            else
                [~, idx] = min(abs(X_bay - xlDS(i)));
                pickedContainerHandle = bayContainerHandles(idx);
            end
        end
    else
        % update container position
        set(pickedContainerHandle, 'Position', [xlDS(i)-Hc/2 ylDS(i)-Hc Hc Hc]);
        if tlkDS(i) == 0  % container dropped
            % drop container handle
            if xlDS(i) > 0
                [~, idx] = min(abs(X_container - xlDS(i)));
                set(pickedContainerHandle, 'Position', [1.5 + (idx-1)*Hc (-19 + containerLayout(idx)*Hc) Hc Hc]);
            else
                [~, idx] = min(abs(X_bay - xlDS(i)));
                set(pickedContainerHandle, 'Position', [-23.25 + (idx-1)*7 (1 + bayLayout(idx)*Hc) Hc Hc]);
            end
            pickedContainerHandle = 0;
        end
    end
    TLK_prev = tlkDS(i);
    % Update title
    titl = strcat('STS Gantry Crane - Ship 4 to Bay 1, time= ', num2str(timeDS(i)), 's');
    title(titl);
    time_elapsed = timeDS(i+1) - timeDS(i);
    %pause(time_elapsed); % Adjust pause for desired animation speed
    
    % Capture the plot as a frame for a video or GIF (if desired)
    frame = getframe(gcf);
    writeVideo(vid, frame);
end

% Close the VideoWriter object
close(vid);

disp(['Video saved as ', videoFileName]);