function [] = compare_ash1(centX,centY,A)

 
%% Calculating Euclidean Distance of detected point from centroids of Keys
x2=centX;
y2=centY;
dis=zeros(27,1);  %pre-allocating distance array to save time and space. (Suggested by MATLAB HELP)


for p=1:27
    x1=(A(p,3)); % display all rows and their 3rd 4th column (centroids) using a loop
    y1=(A(p,4));
    fprintf('x1=%8.4f y1=%8.4f x2=%8.4f y2=%8.4f',x1,y1,x2,y2)
    dis(p)=(sqrt((x2-x1).^2+(y2-y1).^2));
    %distance(p)=dis.^(1/2);
  
end

disp(dis);  %storing distance in array 'distance'
   
%% Search to find shortest distance, Linear Search

num=0;
short=dis(1);  %assuming
for i=1:27
    if(dis(i)<short)
        short=dis(i);
        num=i;
    end
end

fprintf('Serial Number=%g Centroid number= %g Shortest Distance= %g',A(num,1),A(num,2),short); 
    
%% Compare the key pressed and show it
       % SNo. KeyValue
keyMap ={1,'Q';    
        2,'A';     %we are using cell ie, {} instead of char array [] to put strings in this array
        3,'Z';        % char array[] allows only for identical sized matrix.
        4,'W';
        5,'S';
        6,'X';
        7,' ';
        8,'E';
        9,'D';
        10,'C';
        11,'R';
        12,'F';
        13,'V';
        14,'T';
        15,'G';
        16,'Y';
        17,'B';
        18,'H';
        19,'U';
        20,'N';
        21,'J';
        22,'I';
        23,'K';
        24,'M';
        25,'O';
        26,'L';
        27,'P';};
    
 keypress=keyMap(num,2);  %this returns a cell that is the Key Name as specified aboce
 fprintf('\nKey Pressed is');
 fileID = fopen('output.txt','a');
 fprintf(fileID,'%s',keypress{1});  %keypress{1} to access contents of the 1-D cell
 disp(keypress);
end

