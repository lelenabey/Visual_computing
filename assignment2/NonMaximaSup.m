function [r,c] = NonMaximaSup(cornerness, radius, threshold)
% perform non-maximal suppression using ordfilt
    n = ordfilt2(cornerness, radius*2, strel('disk', radius).Neighborhood);

        % set threshold of the maximum value
    t = threshold*max(n(:));

        % find local maxima greater than threshold
    [r,c] = find(n>=t);

end