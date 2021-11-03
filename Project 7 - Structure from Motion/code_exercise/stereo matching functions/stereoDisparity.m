function disp = stereodisp(img1, img2, dispRange)

% dispRange: range of possible disp values
% --> not all values need to be checked

img1 = double(img1);
img2 = double(img2);
size_img = size(img1);


filter_size = 5;
avg_filter = fspecial('average', filter_size);



for i = dispRange
    
    img2_shifted = shiftImage(img2, i);
    
    % SSD
%     img_difference = (img1 - img2_shifted).^2;
    
    % SAD
    img_difference = abs(img1 - img2_shifted); 
    
    Idiff = conv2(img_difference, avg_filter, 'same');
    

    if i == dispRange(1)
        disp = i * ones(size_img);
        bestDiff = Idiff;
    else
        mask = Idiff < bestDiff;
        
        bestDiff = bestDiff.*(~mask) + Idiff.*mask;
        disp = disp.*(~mask) + i.*mask;
    end
    
end

end