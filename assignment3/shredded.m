filenames = dir('./shredded/*.png');
reconstruction = [];
nulls = 0;
max_points = 0;
two_combo = repmat([0 {'1'} {'1'}], 6, 1);
Ib = imread('mugShot.jpg');
Ib = rgb2gray(Ib);

%computes best pairs of shredded peices by comparing all possible
%permutations of 2 images with mugshot and ranking them by number of
%matches
for i = 1:size(filenames,1)
    max_points = 0;
    for j = 1:size(filenames,1)
        if ~strcmp(filenames(i).name, filenames(j).name)
            I = [imread(strcat('./shredded/',filenames(i).name)) imread(strcat('./shredded/',filenames(j).name))];
            I = rgb2gray(I);

            [good_points, good_affine] = affine_t(I, Ib, 0.75)

            
            if max_points < size(good_points, 1)
                max_points = size(good_points, 1)
                two_combo(i,:) = [max_points {strcat('./shredded/',filenames(i).name)} {strcat('./shredded/',filenames(j).name)}];
            end
        end
    end
    
end

%takes the two image matche with the highest rank and attemps to append
%other matches onto it using the rank and shred name
two_combo = sortrows(two_combo, 1);
two_combo = flipud(two_combo);
best = two_combo(1,2:3);
points =0;
for i = 2:size(two_combo,1)
    %left side
    if ~strcmp(two_combo{i,2}, best{size(best,2)})
        if strcmp(two_combo{i,3}, best{1})
            if points < two_combo{i,1}
                points = two_combo{i,1};
                left = two_combo(i,2);
            end
        end
    end
end
for i =1:size(best,2)
    if strcmp(best{i}, left)
        left = [];
    end
end
best = [left best];

points =0;
for i = 2:size(two_combo,1)
    %right side
    if ~strcmp(two_combo{i,3}, best{1})
        if strcmp(two_combo{i,2}, best{size(best,2)})
            if points < two_combo{i,1}
                points = two_combo{i,1};
                right = two_combo(i,3);
            end
        end
    end
end
for i =1:size(best, 2)
    if strcmp(best{i}, right)
        right = [];
    end
end
best = [best right];
I = [];
for i =1:size(best, 2)
    I = [I imread(best{i})];
end
imagesc(I)

% Ib = imresize(Ib,0.5);
% four_combo = repmat([0 {'1'} {'1'} {'1'} {'1'}], 6, 1);
% for i = 1:size(two_combo, 1)
%     for j = 1:size(two_combo, 1)
%         if ~strcmp(strcat(char(two_combo(i, 2)), char(two_combo(i, 3))), strcat(char(two_combo(j, 2)), char(two_combo(j, 3))))
%             I = [imread(char(two_combo(i, 2))) imread(char(two_combo(i, 3))) imread(char(two_combo(j, 2))) imread(char(two_combo(j, 3)))];
%             I = imresize(I,0.5);
%             I = rgb2gray(I);  
%             [good_points, good_affine] = affine_t(I, Ib, 0.75)
%             
%             if max_points < size(good_points, 1)
%                 max_points = size(good_points, 1)
%                 four_combo(i,:) = [max_points {char(two_combo(i, 2))} {char(two_combo(i, 3))} {char(two_combo(j, 2))} {char(two_combo(j, 3))}];
%             end
%         end
%     end
% end    