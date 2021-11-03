function dispRange = automate_disparity_range(img1,img2)


img1_gray = single(rgb2gray(img1));
img2_gray = single(rgb2gray(img2));

% We first extract the SIFT features of both left and right images
thresh_features = 0.001;
filter_size = 7;
[features_L, descriptors_L] = vl_sift(img1_gray, 'PeakThresh', thresh_features, 'WindowSize', filter_size);
[features_R, descriptors_R] = vl_sift(img2_gray, 'PeakThresh', thresh_features, 'WindowSize', filter_size);

% Then we compute the matches between the two images, given a certain threshold value 
thresh_matches = 2;
[matches, ~] = vl_ubcmatch(descriptors_L, descriptors_R, thresh_matches);
num_matches = size(matches, 2);

x1s = [features_L(1:2, matches(1,:));
       ones(1, num_matches)];
x2s = [features_R(1:2, matches(2,:));
       ones(1, num_matches)];
   


% It is also very important to filter out the outliers, hence we apply
% adaptive RANSAC to our features
thresh_RANSAC = 3;
[inliers, F] = ransac8pF(x1s, x2s, thresh_RANSAC);

x1s = x1s(1:2, inliers);
x2s = x2s(1:2, inliers);



disp = x1s(1,:) - x2s(1,:);


use_percentile = true;

if use_percentile
    percentile_1 = prctile(disp,1);
    percentile_99 = prctile(disp,99);
    
    range = ceil(max(abs(percentile_1),abs(percentile_99)));
else
    [min_disp, min_index] = min(disp);
    [max_disp, max_index] = max(disp);
    
    showFeatureMatches(img1, x1s(1:2,[min_index max_index]), img2, x2s(1:2,[min_index max_index]), 1);
    
    range = ceil(max(abs(min_disp),abs(max_disp)));
end
    

dispRange = - range : range;




end

