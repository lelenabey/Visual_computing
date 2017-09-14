function screen_reader(annotate_pts)
% by Sanja Fidler, UofT
% annotate_pts ... 0 or 1 depending if you want to annotate the points
% yourself

if nargin < 1
    annotate_pts = 0;
end;
im = imread('shoe.jpg');

if annotate_pts
   imshow(im);
   disp('click on the four corners of the screen. Double click the last point');
   [x,y] = getpts();
   close all;
   x
   y
   imshow(im);
else
    %set the corners of the $5 bill
   x = [775.5 1067.5 1367.5 1159.5]';
   y = [985.5 509.5 587.5 1147.5]';
end;

% display the image and picked points
figure('position', [100,100,size(im,2)*0.3,size(im,1)*0.3]);
subplot('position', [0,0,1,1]);
imshow(im);
hold on;
plot([x(:); x(1)],[y(:); y(1)],'-o','linewidth',2,'color', [1,0.1,0.1], 'Markersize',10,'markeredgecolor',[0,0,0],'markerfacecolor',[0.5,0.0,1])

%actual size of $5 in pixels as mm
x2 = [1, 1524, 1524, 1]';
y2 = [1, 1, 699, 699]';

% compute homography
tform = maketform('projective',[x,y],[x2,y2]);

% warp the image according to homography
[imrec] = imtransform(im, tform, 'bicubic', 'XYScale',1);
% [imrec] = imtransform(im, tform, 'bicubic',...
%     'xdata', [1,max(x2)],...
%     'ydata', [1,max(y2)],...
%     'size', [max(y2), max(x2)],...
%     'fill', 0);
figure('position', [150,150,size(imrec,2)*0.6,size(imrec,1)*0.6]);
subplot('position', [0,0,1,1]);
imshow(imrec)
disp('pick two points for length, double click on second point');
[lx,ly] = getpts();
disp('pick two points for width, double click on second point');
[wx,wy] = getpts();
close all;
imshow(imrec);
lx
ly
wx
wy
length = sqrt((lx(1) - lx(2))^2 + (ly(1) - ly(2))^2)/100;
width = sqrt((wx(1) - wx(2))^2 + (wy(1) - wy(2))^2)/100;
length
width
end