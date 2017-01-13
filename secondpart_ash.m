function [] = secondpart_ash()

%% Initialization
redThresh = 0.25; % Threshold for red detection
vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ... % Acquire input video stream
                    'ROI', [1 1 640 480], ...         %ROI is region of interest specified in [x y width height], width height being the resolution of cam
                    'ReturnedColorSpace', 'rgb');               % rgb colour format required, by default it is Ycbr
vidInfo = imaqhwinfo(vidDevice); % Acquire input video property
%vidInfo.FramesPerTrigger = 40*45;

%Setting properties
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... %  Returns blob of area if set default. we don't require it
                                'CentroidOutputPort', true, ...    % returns centroids of blobs
                                'BoundingBoxOutputPort', true', ...  %returns coordinates of bounding box
                                'MinimumBlobArea', 800, ...
                                'MaximumBlobArea', 3000, ...
                                'MaximumCount', 10);
hshapeinsRedBox = vision.ShapeInserter('BorderColor', 'Custom', ... % Set Red box handling
                                        'CustomBorderColor', [1 0 0], ...
                                        'Fill', true, ...
                                        'FillColor', 'Custom', ...
                                        'CustomFillColor', [1 0 0], ...
                                        'Opacity', 0.4);
htextins = vision.TextInserter('Text', 'Number of Red Object: %2d', ... % Set text for number of blobs
                                    'Location',  [7 2], ...
                                    'Color', [1 0 0], ... // red color
                                    'FontSize', 12);
htextinsCent = vision.TextInserter('Text', '+      X:%4d, Y:%4d', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ... // yellow color
                                    'FontSize', 14);
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ... % Output video player
                                'Position', [100 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);
nFrame = 0; % Frame number initialization

LB = 150;   %upper lower limit for red area detected
UB = 1000;
%% Processing Loop
while(nFrame < 300)
     rgbFrame = step(vidDevice); % Acquire single frame
     
  %  rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    diffFrame = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red component of the image
    diffFrame = medfilt2(diffFrame, [3 3]); % Filter out the noise by using median filter
    binFrame = im2bw(diffFrame, redThresh); % Convert the image into binary image with the red objects as white 
    binFrame = xor(bwareaopen(binFrame,LB),  bwareaopen(binFrame,UB));  % NEW CHANGE. CHECK scrapcolor.m
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    centroid = (centroid); % Convert the centroids into Integer for further steps 
    rgbFrame(1:20,1:165,:) = 0; % put a black region on the output stream, size of the black region
    vidIn = step(hshapeinsRedBox, rgbFrame, bbox); % Instert the red box
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        centX = centroid(object,1); 
        centY = centroid(object,2);
        disp(centX);
        disp(centY);
        vidIn = step(htextinsCent, vidIn, [uint16(centX) uint16(centY)], [uint16(centX-6) uint16(centY-9)]);  %required to convert in this format for next step
        compare_ash(centX,centY)
    end
    vidIn = step(htextins, vidIn, uint8(length(bbox(:,1)))); % Count the number of blobs
    step(hVideoIn, vidIn); % Output video stream
    
    nFrame = nFrame+1;
end
%% Clearing Memory
release(hVideoIn); % Release all memory and buffer used
release(vidDevice);
% clear all;
%clc;
end
