I = rgb2gray(imread('book.jpg'));
Ib = rgb2gray(imread('findBook.jpg'));

[good_points, good_affine] = affine_t(I, Ib, 0.6);

mmk = good_points';
figure, imagesc(I), axis image, colormap(gray),hold on
plot(mmk(2,:),mmk(3,:),'g.') ;
hold off;
figure, imagesc(Ib), axis image, colormap(gray),hold on
plot(mmk(4,:),mmk(5,:),'g.') ;
hold off;

O = [];
Op = [];
corners = [1 1; size(I,2) 1; size(I,2) size(I,1);1 size(I,1)];
for i = 1:size(corners, 1);
    x1 = corners(i,1);
    y1 = corners(i,2);

    O(size(O,1)+1,:) = [x1 y1 0 0 1 0];
    O(size(O,1)+1,:) = [0 0 x1 y1 0 1];

end

transform = O*good_affine;

yr = transform(2:2:length(transform));
xr = transform(1:2:length(transform));
xr= [xr' xr(1)];
yr= [yr' yr(1)];

figure, imagesc(Ib), axis image, colormap(gray),hold on
plot(xr,yr);
hold off;