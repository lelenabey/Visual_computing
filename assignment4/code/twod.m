data = getData([], 'test','list');
ids = data.ids(1:3);
col = {'r', 'b', 'c'};
for i = 1:3
    data = getData(ids{i}, 'test', 'ds');
    imdata = getData(ids{i}, 'test', 'left');
    calib = getData(ids{i}, 'test', 'calib');
    im = imdata.im;
    depth = getDepth(ids{i});
    for c = 1:3
        for j = 1:size(data.dss{c}.ds,1)
            x1 = round(data.dss{c}.ds(j,2):data.dss{c}.ds(j,4));
            y1 = round(data.dss{c}.ds(j,1):data.dss{c}.ds(j,3));
            x1 = x1(x1<=375);
            y1 = y1(y1<=1242);
            segmentdepth = depth(x1,y1);
            Z = mode(round(segmentdepth(:)));
            centers = [data.dss{c}.ds(j,1)+(data.dss{c}.ds(j,3)-data.dss{c}.ds(j,1))/2 data.dss{c}.ds(j,2)+(data.dss{c}.ds(j,4)-data.dss{c}.ds(j,2))/2];

            X = (Z.*(centers(1) - calib.K(1,3)))/calib.f;
            Y = (Z.*(centers(2) - calib.K(2,3)))/calib.f;
            data.dss{c}.ds(j,7) = X;
            data.dss{c}.ds(j,8) = Y;
            data.dss{c}.ds(j,9) = Z;

        end
        ds = data.dss{c}.ds;
        fname=sprintf('../data/test/results/%s-%s',ids{i}, data.class{c});
        save(fname, 'ds');
    end
    
    
    
end