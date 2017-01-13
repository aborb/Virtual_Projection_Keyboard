%creating a "videoinput" object 'v'
v=videoinput('winvideo', 1, 'YUY2_640x480');
%Setting the "FramesPerTrigger" value to '1'
v.FramesPerTrigger=1;
%for previewing window of the "videoinput" object 'v'
preview(v);
%start capturing
start(v);
%for warming up of webcam
pause(2.0);

% Get image data from webcam
I=getdata(v);
%displaying the captured image
%writing/storing the captured image in the hard-disk of computer
imwrite(I,'C:\Users\Ashmita\Downloads\Major Project\image.jpg');


%% Convert to grayscale image
%I=imread('keyboard final.jpg'); 

Igray = rgb2gray(I);
   
 
%% Convert to binary image
 
BW = im2bw(Igray,0.567);
 %BW = ~BW;   %complemented the Black&White colour for bounding box. As bounding box detects white boxes 
 imshow(BW);

%% Feature Extraction
st = regionprops(not(BW), 'BoundingBox', 'Area', 'Centroid' );  %notBW for detecting black boxes as bounding box typically detects white boxes. Inverting clr
disp(st);
disp(length(st)); % =86 out of which actual number of keys are 53
x=0;              % x is the serial number of centroid
fileID = fopen('centroid.txt','w');

for k = 1 : length(st)
    if(st(k).Area>500&&st(k).Area<15000)   %condition given to select only boxes with above 500pixels in the region and neglect smaller boxes
        thisBB = st(k).BoundingBox;
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...     % st(k).Bounding Box = X Y W H
            'EdgeColor','r','LineWidth',2 )
        centroids=st(k).Centroid;
        hold on
        plot(centroids(:,1),centroids(:,2), 'b*') %  blue color
        x=x+1;
        fprintf('Centroid number= %g ',k)
        fprintf('Sno= %g',x);
        disp(st(k).Centroid);   % 53 centroids, X Y
        
        x_centroid(k) = st(k).Centroid(1);  %extracting coordiantes and saving in a text file
        y_centroid(k) = st(k).Centroid(2);
        fprintf(fileID,'%d %d %8.4f %8.4f\r\n',x,k,x_centroid(k),y_centroid(k));
        hold off
    end
end
fclose(fileID);

delete(v); %deleting the "videoinput" object to avoid filling up of memory


prompt = 'Proceed to Step 2? [Y/N] Check the output. Number of detected centroids should be 53 \n';
str = input(prompt,'s');
if (str=='Y')
    secondpart_ash()
end

% Coordinates of Centroids are stored in centroid.txt in the
% format --: k, X, Y  (k is the centroid number representing areas above 1000 pixels.
% Orginally 86 were detected out of which only 53 are revelant. k shows
% which ones are relevant)





%Bounding Box help--  Returns the smallest 
%rectangle containing the region, specified 
%as a 1-by-Q*2 vector, where Q is the number of image dimensions, 
%for example, [ul_corner width]. ul_corner specifies the upper-left
% corner of the bounding box in the form [x y z ...]. width specifies 
% the width of the bounding box along each dimension in the form [x_width y_width ...]. 
% regionprops uses ndims to get the dimensions of label matrix or binary image, ndims(L),
% and numel to get the dimensions of connected components, numel(CC.ImageSize).

