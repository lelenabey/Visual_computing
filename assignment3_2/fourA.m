function fourA(H_s, matching_pointss, current)

    out = zeros(size(matching_pointss,1),3);
    for i = 1:size(matching_pointss,1)
        out(i,:) = (H_s*[matching_pointss(i,2);matching_pointss(i,3);1])';
        out(i,:) = out(i,:)./out(i,3);
    end

    figure, imagesc(current), axis image, colormap(gray),hold on
        plot(matching_pointss(:,4),matching_pointss(:,5), 'y.');
        plot(out(:,1),out(:,2), 'r.');
        hold off;
    
end