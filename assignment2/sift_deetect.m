I = imread('book.jpg');
I = single(rgb2gray(I)) ;
Ib = imread('findbook.jpg');
Ib = single(rgb2gray(Ib)) ;
[f,d] = vl_sift(I) ;

[fb, db] = vl_sift(Ib) ;


figure, imagesc(I), axis image, colormap(gray),hold on
vl_plotframe(f(:, perm));
hold off;
figure, imagesc(I), axis image, colormap(gray),hold on
vl_plotsiftdescriptor(d(:,sel),f(:,sel));
hold off;

figure, imagesc(Ib), axis image, colormap(gray),hold on
vl_plotframe(fb(:,selb));
hold off;
figure, imagesc(Ib), axis image, colormap(gray),hold on
vl_plotsiftdescriptor(db(:,selb),fb(:,selb));
hold off;
%set(h2,'color','y','linewidth',2) ;

%h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
%set(h3,'color','g') ;
% matches = zeros(128, 2, size(d,2));
% for i = 1:size(d,2)
%     for j = 1:size(db,2)
%         if abs(d(:,i) - db(:,j)) <= abs(matches(:,1,i))
%             matches(:,2,i) = matches(:,1,i);
%             matches(:,1,i) = d(:,i) - db(:,j);
%         elseif abs(d(:,i) - db(:,j)) <= abs(matches(:,2,i))
%             matches(:,2,i) = d(:,i) - db(:,j);
%         end
%     end
%     
% end

d = double(d);
db = double(db);
euc= pdist2(d', db', 'euclidean');
sorted = sort(euc, 2);
ratios=sorted(:,1)./sorted(:,2);

%copy_f(:,129)= ratios';
%matches = sortrows(copy_f', 129)';

threshold = 0.6;
matches = zeros(size(find(ratios<=threshold),1), 3);
for i = 1:size(euc,1)
    if ratios(i) < threshold
        matches(i,1) = ratios(i);
        matches(i,2)= i;
        matches(i,3)=find(euc(i,:)==sorted(i,1));
    end
end

matches( ~any(matches,2), : ) = [];
matching_points = zeros(size(matches,1), 5);

for i = 1:size(matches,1)
    matching_points(i,1) = matches(i,1);
    matching_points(i,2:3) = [f(1,matches(i,2)) f(2,matches(i,2))];
    matching_points(i,4:5) = [fb(1,matches(i,3)) fb(2,matches(i,3))];
    
end

mmk = matching_points';
figure, imagesc(I), axis image, colormap(gray),hold on
plot(mmk(2,:),mmk(3,:),'g.') ;
hold off;
figure, imagesc(Ib), axis image, colormap(gray),hold on
plot(mmk(4,:),mmk(5,:),'g.') ;
hold off;

matching_pointss = sortrows(matching_points, 1);
k = 1;

fg = figure;imagesc(I);axis image;hold on;colormap gray;
drawnow;
[x,y] = ginput(4);
    
while (k)
    k = size(matching_pointss, 1);
    k = input(sprintf('Enter a value for k between 1 and %d\n',k));

    P = [];
    Pp = [];

    for i = 1:k
        x1 = matching_pointss(i,2);
        y1 = matching_pointss(i,3);
        x2 = matching_pointss(i,4);
        y2 = matching_pointss(i,5);


        P(size(P,1)+1,:) = [x1 y1 0 0 1 0];
        P(size(P,1)+1,:) = [0 0 x1 y1 0 1];

        Pp(size(Pp,1)+1,:) = x2;
        Pp(size(Pp,1)+1,:) = y2;


    end
    penny = (P'*P)'*inv((P'*P)*(P'*P)');
    affine = penny*P'*Pp;
    
    O = [];
    for i = 1:size(x)
        O(size(O,1)+1,:) = [x(i) y(i) 0 0 1 0];
        O(size(O,1)+1,:) = [0 0 x(i) y(i) 0 1];
    end
    
    transform = O*affine;
    yr = transform(2:2:length(transform));
    xr = transform(1:2:length(transform));
    xr= [xr' xr(1)];
    yr= [yr' yr(1)];
    
    figure, imagesc(Ib), axis image, colormap(gray),hold on
    plot(xr,yr);
    hold off;
    
end

