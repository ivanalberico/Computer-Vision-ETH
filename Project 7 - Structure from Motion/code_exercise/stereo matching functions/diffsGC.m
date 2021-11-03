function diffs = diffsGC(img1, img2, dispRange)

% get data costs for graph cut

m = size(img1, 1);
n = size(img1, 2);
r = dispRange(end) - dispRange(1);
diffs = zeros(m, n, r);


filter_size = 10;
avg_filter = fspecial('average', filter_size);

for i=0:r
    
    img2_shifted = shiftImage(img2, i-ceil(r/2));
    img_difference = (img1 - img2_shifted).^2; 
    
    diffs(:,:,i+1) = conv2(img_difference, avg_filter, 'same');
    
end


end