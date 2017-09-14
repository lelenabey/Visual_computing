img = double(rgb2gray(imread('building.jpg')));
figure; imagesc(img); axis image; colormap(gray);

[Ix,Iy] = imgradientxy(img);

g = fspecial('gaussian', 3, 0.6);
    
Ix2 = conv2(Ix.^2, g, 'same'); 
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');
R = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2);

figure; imagesc(Ix2); axis image; colormap(gray);
figure; imagesc(Iy2); axis image; colormap(gray);
figure; imagesc(Ixy); axis image; colormap(gray);
%figure; imagesc(M); axis image; colormap(gray);
figure; imagesc(R); axis image; colormap(gray);
[r,c] = NonMaximaSup(R, 80, 0.2);
figure, imagesc(img), axis image, colormap(gray),hold on
plot(c, r, 'ro'), title('Corners detected');
hold off;