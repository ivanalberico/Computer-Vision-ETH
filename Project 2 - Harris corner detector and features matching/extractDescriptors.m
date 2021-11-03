% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector

function [keypoints, descriptors] = extractDescriptors(img, keypoints)

[num1, num2] = size(img);

[num_corners, dim] = size(keypoints');
filt_corners = [];
keypoints = keypoints'

for i = 1 : num_corners
    if (keypoints(i,1)>4) && (keypoints(i,2)>4) && (num1-keypoints(i,1)>4) && (num2-keypoints(i,2)>4)
        filt_corners = [filt_corners; keypoints(i,:)];
    end
end


        
keypoints = filt_corners';

descriptors = extractPatches(img, keypoints, 9);
        
 
end