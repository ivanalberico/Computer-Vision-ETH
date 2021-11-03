% Plot feature matches between two images.
%
% Input:
%   img1        - n x m color image 
%   keypoints1  - 2 x q matrix, holding keypoint positions for the first image
%   img2        - n' x m' color image 
%   keypoints2  - 2 x q' matrix, holding keypoint positions for the second image
%   fig         - figure id
function plotMatches(img1, keypoints1, img2, keypoints2, fig)
    [~, w] = size(img1);
    img = [img1, img2];
    
    keypoints2 = keypoints2 + repmat([0, w]', [1, size(keypoints2, 2)]);
    
    figure(fig);
    imshow(img);
    hold on;
    plot(keypoints1(2, :), keypoints1(1, :), '+r');
    plot(keypoints2(2, :), keypoints2(1, :), '+r');
    plot([keypoints1(2, :); keypoints2(2, :)], [keypoints1(1, :); keypoints2(1, :)], 'b');
    hold off;
end