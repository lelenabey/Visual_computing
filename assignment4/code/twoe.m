data = getData([], 'test','list');
ids = data.ids(1:3);
col = {'r', 'b', 'c'};
for i = 1:3
    data = getData(ids{i}, 'test', 'ds');
    imdata = getData(ids{i}, 'test', 'left');
    im = imdata.im;
    depth = getDepth(ids{i});
    plx = repmat((1:size(depth,1))', 1, size(depth,2));
    ply = repmat((1:size(depth,2)), size(depth,1), 1);
    Xmat = (depth.*(plx - calib.K(1,3)))/calib.f;
    Ymat = (depth.*(ply - calib.K(2,3)))/calib.f;
    segmask = uint8(zeros(size(depth)));
    segim = uint8(zeros(size(im)));
    for c = 1:3
        
        X = data.dss{c}.ds(:,7);
        Y = data.dss{c}.ds(:,8);
        Z = data.dss{c}.ds(:,9);
        data.dss{c}.ds(:,1:4)=floor(data.dss{c}.ds(:,1:4));
        for j = 1:size(Z)
            [rowz, colz] = find(depth>=Z(j)-3 & depth<=Z(j)+3);
            [rowx, colx] = find(Xmat>=X(j)-3 & Xmat<=X(j)+3);
            [rowy, coly] = find(Ymat>=Y(j)-3 & Ymat<=Y(j)+3);
            indices = sub2ind(size(segmask), rowz, colz);
            segmask(indices) = 1;
            indices = sub2ind(size(segmask), rowx, colx);
            segmask(indices) = 1;
            indices = sub2ind(size(segmask), rowy, coly);
            segmask(indices) = 1;
            x1 = data.dss{c}.ds(j,2):data.dss{c}.ds(j,4);
            y1 = data.dss{c}.ds(j,1):data.dss{c}.ds(j,3);
            x1 = x1(x1<=375);
            y1 = y1(y1<=1242);
            for dim = 1:3
                segim(x1 ,y1 ,dim)= im(x1 ,y1,dim).*segmask(x1,y1);
            end

            
        end
        
        
    end
    figure; axis ij; hold on
    imagesc(segim);
    for c = 1:3
        showboxesMy(im, data.dss{c}.ds(:,1:4), col{c});
        text(data.dss{c}.ds(:,1), data.dss{c}.ds(:,2), data.class{c},'Color',col{c},'FontSize',12);
    end
    hold off;
    
    
end