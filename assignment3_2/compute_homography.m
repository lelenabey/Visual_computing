function H = compute_homography(points1, points2)
    A =[];
    for i = 1:size(points1);
        x1 = points1(i,1);
        y1 = points1(i,2);
        x2 = points2(i,1);
        y2 = points2(i,2);
        
        A(size(A,1)+1,:) = [x1 y1 1 0 0 0 -x2*x1 -x2*y1 -x2];
        A(size(A,1)+1,:) = [0 0 0 x1 y1 1 -y2*x1 -y2*y1 -y2];
    
    end
    [U, S, V] = svd(A);
    H = V(:,9);
end