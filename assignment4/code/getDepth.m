function depth = getDepth(name)
    calib = getData(name, 'test', 'calib');
    image = getData(name, 'test', 'disp');
    disparity = image.disparity;
    %figure;imagesc(disparity);
    fT = calib.f*calib.baseline;
    depth = fT./disparity;
    dfosho = depth;
    dfosho(dfosho>255)=255;
    figure;imagesc(dfosho);
end