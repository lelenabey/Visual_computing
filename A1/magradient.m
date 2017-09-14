function out = magradient(im, sigma)

im = rgb2gray(im);
im = double(im);


k = 2*sigma+mod(sigma, 2);%The filter support
x = [-k:k];%for a [kxk] filter
y = x';
c = 1/(sqrt(2*pi)*sigma);%The normalization constant
gx = c* exp(-(x.^2)/(2*sigma^2));
gy = c* exp(-(y.^2)/(2*sigma^2));
g = gy*gx;
g_x = (-x/(sigma^2)).*g; %The partial derivative of g w.r.t. x
g_y = (-y/(sigma^2)).*g'; %The partial derivative of g w.r.t. x

grd_x = conv2(im,g_x,'same');
grd_y = conv2(im,g_y,'same');

moe = sqrt((grd_x.^2) + (grd_y.^2));
out = moe;
figure;
imagesc(moe);

