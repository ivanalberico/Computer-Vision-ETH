function [newim1, newim2, b, H1, H2, newe] = rectify_images(im1, im2, x1, x2, F12)

%RECTIFY_IMAGES rectifies two images to achieve correspondences of scanlines.
%
%   [newim1, newim2] = rectify_images(im1, im2, x1, x2, F12)
%   [newim1, newim2, b, H1, H2] = rectify_images(im1, im2, x1, x2, F12)
%   [newim1, newim2, b, H1, H2, newe] = rectify_images(im1, im2, x1, x2, F12)
%   rectifies two images, im1 and im2, using the fundamental matrix, F12, which
%   must satisfy the epipolar equation:
%                          (x1)
%      (x2, y2, 1) * F12 * (y1) = 0
%                          ( 1)
% 
%   The input arguments are:
%   - im1 and im2 should both be an m-by-n array of doubles (or uint8) for some
%     values m and n
%   - x1 and x2 should both be 3-by-n matrix, where each column of the matrix
%     is an image point in homogeneous coordinates.  Corresponding columns in
%     the two matrices contain corresponding points in the two images.
%   - F12 must be a 3-by-3 rank-2 matrix.  Fundamental matrices can be computed
%     using one of Torr's routines (available for download on his Microsoft home
%     page) or Zhang's home page.
%
%     ***Note: the fundamental matrix is assumed to be computed with the following
%              image coordinate systems in both images being adopted: the origins
%              of the image coordinate systems are at the centres of the images;
%              the x-axes point to the right, y-axes up.
%
%   The output arguments are:
%   - the two new rectified images, newim1 and newim2.
%   - (optional) the bounding box, b, of the form [minx,miny,maxx,maxy] which bound
%     the new images newim1 and newim2.
%   - (optional) H1 and H2 are the computed rectification transformations.
%   - (optional) newe is the new epipole in the second image after the rectification.
%     On return, newe is always set [1;0;0] if the horizontal scanlines correspond
%     or [0;1;0] if the vertical scanlines correspond.
%
%   The implementation here is based on that described in the paper:
%   Richard I. Hartley, "Theory and Practice of Projective Rectification"
%   International Journal of Computer Vision, vol 35, no 2, pages 115-127, 1999.
%
%Created July 2002
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% the epipole e1 is the projection of optical centre C2 onto image 1
% the epipole e2 is the projection of optical centre C1 onto image 2
% compute the two epipoles
e1 = null(F12);
e2 = null(F12');

% Check that both epipoles are outside the image boundary (a condition for
% Hartley's method)
pe1 = pflat(e1);  pe2 = pflat(e2);
nx = size(im1,2)/2;  ny = size(im1,1)/2;
if (in_range(pe1(1), -nx, nx) & in_range(pe1(2), -ny, ny)) | ...
      (in_range(pe2(1), -nx, nx) & in_range(pe2(2), -ny, ny))
   error('rectify_images: rectification not possible if the epipole(s) is(are) inside the image(s)');
end

% compute the two 3-by-4 projection matrices
P1 = [eye(3) zeros(3,1)];
% note that for projective reconstruction we can choose the 3-by-4
% projection matrix P2 to have the form [ skew(e2)*F12+e2*alpha'  beta*e2 ], where
% alpha is an arbitrary 3-column vector and beta is an arbitrary scalar.  Here, for the rectification
% to work, the 3-by-3 submatrix of P2 (ie. the 1st three columns of P2) must be
% non-singular.  So, we adjust the vector alpha to make this submatrix non-singular.
% Since beta is also arbitrary, we can set beta to 1.
P2 = [skew(e2)*F12+e2*rand(1,3)  e2]; 

if nargout == 2
   [H1,H2] = rectification_transf(P1, P2, e1, e2, x1, x2);
elseif nargout == 5
   [H1,H2,newe,G2,R2] = rectification_transf(P1, P2, e1, e2, x1, x2);
end
   

nx = size(im1,2)/2;  ny = size(im1,1)/2;
% look for the smallest image size that encloses all the mapped corners
corners1 = pflat(H1*[-nx -ny 1; nx -ny 1; -nx ny 1; nx ny 1]');

nx = size(im2,2)/2;  ny = size(im2,1)/2;
corners2 = pflat(H2*[-nx -ny 1; nx -ny 1; -nx ny 1; nx ny 1]');

corners = [corners1 corners2];
minx = floor(min(corners(1,:))-1);
miny = floor(min(corners(2,:))-1);
maxx = ceil(max(corners(1,:))+1);
maxy = ceil(max(corners(2,:))+1);

b = [minx,miny,maxx,maxy];
newim1 = rectify_im(im1, H1, b);
newim2 = rectify_im(im2, H2, b);

return

