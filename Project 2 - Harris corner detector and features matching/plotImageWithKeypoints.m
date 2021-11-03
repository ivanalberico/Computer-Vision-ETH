% Plot image with keypoints.
%
% Input:
%   img        - n x m color image 
%   keypoints  - 2 x q matrix, holding keypoint positions
%   fig        - figure id


function plotImageWithKeypoints(img, keypoints, fig)
    figure(fig);
    imshow(img, []);
    hold on;
    plot(keypoints(2, :), keypoints(1, :), '+r');
    hold off;
end


% function plotImageWithKeypoints(img, keypoints, fig)
%     figure(fig);
%     imshow(img, []);
%     hold on;
%     [num1 num2] = size(keypoints);
%     for i = 1:num1
%         plot(keypoints(i, 2), keypoints(i, 1), '+r');
%         hold on;
%     end
% end