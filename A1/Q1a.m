clear all;close all;
img = imread('waldoNoise.png');

%filter = double(rgb2gray(imread('templateNoise.png')));
%this should work^ but takes eons
%Create a seperable filter
hx =[1 2 1];
hy = [1 2 1]';
H = hy*hx;
hx = hx/sum(hx(:));
hy = hy/sum(hy(:));
H = H/sum(H(:));%normalize the filter

filter = H;

img = rgb2gray(img);
img = double(img);
[n,m] = size(filter);
[x,y] = size(img);
padded = padarray(img, [floor(n/2) floor(m/2)]);
flipped = flip(flip(filter,1),2);
flipped_array = reshape(flipped, 1, n*m);

for i = 1:(x)
    for j= 1:(y)
        patch = padded(i:i+(n-1), j:j+(m-1));
        patch_array = reshape(patch, 1, n*m);
        G(i,j)= dot(flipped_array, patch_array);
    end
end

figure;imagesc(G);