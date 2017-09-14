data = getData([], 'test','list');
ids = data.ids(1:3);
col = {'r', 'b', 'c'};
for i = 1:3
    data = getData(ids{i}, 'test', 'ds');
    imdata = getData(ids{i}, 'test', 'left');
    im = imdata.im;
    figure; axis ij; hold on
    imagesc(im);
    for c = 1:3
        showboxesMy(im, data.dss{c}.ds(:,1:4), col{c});
        text(data.dss{c}.ds(:,1), data.dss{c}.ds(:,2), data.class{c},'Color',col{c},'FontSize',12);
    end
    hold off;
end