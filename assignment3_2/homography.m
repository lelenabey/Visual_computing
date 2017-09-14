filenames = dir('./hotel/*.png');
names = struct2cell(filenames);
names = names(1,:);
mid = size(names,2)/2;
% middle = imread(strcat('./hotel/',char(names(mid))));
% current = middle;
corners = repmat([1 1; 1024 1; 1024 768;1 768],size(names));
Homos = zeros(9, size(names,2));
for i = 1:mid-1
    
    next = imread(strcat('./hotel/',char(names(i))));
    current = imread(strcat('./hotel/',char(names(i+1))));
    
    matching_points = get_matches(next, current, 0.7);
    matching_pointss = sortrows(matching_points, 1);
    %k = size(matching_pointss, 1);
    points = matching_pointss(1:15,:);
    
    xI = points(:,2);
    yI = points(:,3);
    xB = points(:,4);
    yB = points(:,5);
    
%     figure, imagesc(next), axis image, colormap(gray),hold on
%         plot(xI,yI, 'r.');
%         hold off;
% 
%     figure, imagesc(current), axis image, colormap(gray),hold on
%         plot(xB,yB, 'g.');
%         hold off;
        
    H = compute_homography([points(:,2) points(:,3)], [points(:,4) points(:,5)]);
    Homos(:,i) = H;
    H_s = [H(1:3)';H(4:6)';H(7:9)'];
    
    %4a
    fourA(H_s, matching_pointss, current);
    
    out = zeros(size(corners,1),3);
    for x = 1:i
        for j = 1:size(corners,1)
            out(j,:) = (H_s*[corners(j,(x*2)-1);corners(j,x*2);1])';
            out(j,:) = out(j,:)./out(j,3);
        end
        corners(:,(x*2)-1:x*2) = out(:,1:2);
    end
%     tform = projective2d(H_s');
%     current = imwarp(next, tform);
end

for i = size(names,2):-1:mid+1
    
    next = imread(strcat('./hotel/',char(names(i))));
    current = imread(strcat('./hotel/',char(names(i-1))));
    
    matching_points = get_matches(next, current, 0.7);
    matching_pointss = sortrows(matching_points, 1);
    %k = size(matching_pointss, 1);
    points = matching_pointss(1:15,:);
    
    xI = points(:,2);
    yI = points(:,3);
    xB = points(:,4);
    yB = points(:,5);
    
%     figure, imagesc(next), axis image, colormap(gray),hold on
%         plot(xI,yI, 'r.');
%         hold off;
% 
%     figure, imagesc(current), axis image, colormap(gray),hold on
%         plot(xB,yB, 'g.');
%         hold off;
%         
    H = compute_homography([points(:,2) points(:,3)], [points(:,4) points(:,5)]);
    Homos(:,i) = H;
    
    H_s = [H(1:3)';H(4:6)';H(7:9)'];
    
    %4a
    fourA(H_s, matching_pointss, current);
    
    out = zeros(size(corners,1),3);
    for x = size(names,2):-1:i
        for j = 1:size(corners,1)
            out(j,:) = (H_s*[corners(j,(x*2)-1);corners(j,x*2);1])';
            out(j,:) = out(j,:)./out(j,3);
        end
        corners(:,(x*2)-1:x*2) = out(:,1:2);
    end
%     tform = projective2d(H_s');
%     current = imwarp(next, tform);
end


figure, axis image, hold on
for i = 1:size(corners,2)/2
    plot(corners(:,i*2-1), corners(:,i*2));
end
hold off;

H = Homos(:,i);
H_s = [H(1:3)';H(4:6)';H(7:9)'];
tform = projective2d(H_s');
I = imread(strcat('./hotel/',char(names(i))));
