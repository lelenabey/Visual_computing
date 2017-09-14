filenames = dir('./hotel/*.png');
names = struct2cell(filenames);
names = names(1,:);
mid = size(names,2)/2;
middle = imread(strcat('./hotel/',char(names(mid))));
current = middle;
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
    
    %use top k correspondeces to compute homography
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
    %this is for use later to stitch the panorama
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
%create list of transformations from the middle out
tforms(size(names)) = projective2d(eye(3));
for i = mid+1:size(Homos,2)
    H = Homos(:,i);
    H_s = [H(1:3)';H(4:6)';H(7:9)'];
    tforms(i) = projective2d(H_s');
    tforms(i).T = tforms(i-1).T * tforms(i).T;
end
for i = mid-1:-1:1
    H = Homos(:,i);
    H_s = [H(1:3)';H(4:6)';H(7:9)'];
    tforms(i) = projective2d(H_s');
    tforms(i).T = tforms(i+1).T * tforms(i).T;
end

figure, axis ij, hold on
for i = 1:size(corners,2)/2
    plot(corners(:,i*2-1), corners(:,i*2));
end
hold off;

 xvals = corners(:,1:2:15);
 yvals = corners(:,2:2:16);
% panorama = zeros(ceil(max(yvals(:))+abs(min(yvals(:)))), ceil(max(xvals(:))+abs(min(xvals(:)))));

xLimits = [floor(min(xvals(:))) ceil(max(xvals(:)))];
yLimits = [floor(min(yvals(:))) ceil(max(yvals(:)))];
width  = round(xLimits(2) - xLimits(1));
height = round(yLimits(2) - yLimits(1));
panoramaView = imref2d([height width], xLimits, yLimits);
panorama = zeros([height width], 'like', middle);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');


%figure, axis ij, hold on
    %imagesc(imread(strcat('./hotel/',char(names(mid)))));
% for i = 1:mid-1
%     I = imread(strcat('./hotel/',char(names(i))));
%     mask = true(size(I,1),size(I,2));
%     for j = i:mid-2
%         H = Homos(:,j);
%         H_s = [H(1:3)';H(4:6)';H(7:9)'];
%         tform = projective2d(H_s');
%         mask = imwarp(mask, tform);
%         I = imwarp(I, tform);   
%         imagesc(I)
%     end
%         H = Homos(:,mid-1);
%         H_s = [H(1:3)';H(4:6)';H(7:9)'];
%         tform = projective2d(H_s');
%         
%         warpedImage = imwarp(I, tform, 'OutputView', panoramaView);
% 
%         % Generate a binary mask.
%         mask = imwarp(mask, tform, 'OutputView', panoramaView);
% 
%         % Overlay the warpedImage onto the panorama.
%         panorama = step(blender, panorama, warpedImage, mask);
% %         figure
% %         imshow(panorama)
% 
% %     J = imtranslate(I, corners(1, (i*2)-1:i*2), 'FillValues',255, 'OutputView', 'Full');
% %     
% %     imagesc(J);
%     
% end
% 
% for i = size(Homos,2):-1:mid+1
%     I = imread(strcat('./hotel/',char(names(i))));
%     mask = true(size(I,1),size(I,2));
%     for j = i:-1:mid+2
%         H = Homos(:,j);
%         H_s = [H(1:3)';H(4:6)';H(7:9)'];
%         tform = projective2d(H_s');
%         mask = imwarp(mask, tform);
%         I = imwarp(I, tform);   
%     end
%         H = Homos(:,mid+1);
%         H_s = [H(1:3)';H(4:6)';H(7:9)'];
%         tform = projective2d(H_s');
%         
%         warpedImage = imwarp(I, tform, 'OutputView', panoramaView);
% 
%         % Generate a binary mask.
%         mask = imwarp(mask, tform, 'OutputView', panoramaView);
% 
%         % Overlay the warpedImage onto the panorama.
%         panorama = step(blender, panorama, warpedImage, mask);
% %         figure
% %         imshow(panorama)
% 
% %     J = imtranslate(I, corners(1, (i*2)-1:i*2), 'FillValues',255, 'OutputView', 'Full');
% %     
% %     imagesc(J);
%     
% end

for i = 1:size(names,2)
    I = imread(strcat('./hotel/',char(names(i))));
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

figure, imagesc(panorama), axis ij, colormap(gray)

%hold off;