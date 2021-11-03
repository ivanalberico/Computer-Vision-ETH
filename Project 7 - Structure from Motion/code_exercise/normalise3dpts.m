% NORMALISE3DPTS - normalises 3D homogeneous points
%
% Function translates and normalises a set of 3D homogeneous points 
% so that their centroid is at the origin and their mean distance from 
% the origin is sqrt(3).  This process typically improves the
% conditioning of any equations used to solve homographies, fundamental
% matrices etc.
%
% Usage:   [newpts, T] = normalise3dpts(pts)
%
% Argument:
%   pts -  4xN array of 4D homogeneous coordinates
%
% Returns:
%   newpts -  4xN array of transformed 3D homogeneous coordinates.  The
%             scaling parameter is normalised to 1 unless the point is at
%             infinity. 
%   T      -  The 4x4 transformation matrix, newpts = T*pts
%           
% If there are some points at infinity the normalisation transform
% is calculated using just the finite points.  Being a scaling and
% translating transform this will not affect the points at infinity.


function [newpts, T] = normalise3dpts(pts)

    if size(pts,1) ~= 4
        error('pts must be 4xN');
    end
    
    % Find the indices of the points that are not at infinity
    finiteind = find(abs(pts(4,:)) > eps);
    
    if length(finiteind) ~= size(pts,2)
        warning('Some points are at infinity');
    end
    
    % For the finite points ensure homogeneous coords have scale of 1
    pts(1,finiteind) = pts(1,finiteind)./pts(4,finiteind);
    pts(2,finiteind) = pts(2,finiteind)./pts(4,finiteind);
    pts(3,finiteind) = pts(3,finiteind)./pts(4,finiteind);
    pts(4,finiteind) = 1;
    
    c = mean(pts(1:3,finiteind)')';            % Centroid of finite points
    newp(1,finiteind) = pts(1,finiteind)-c(1); % Shift origin to centroid.
    newp(2,finiteind) = pts(2,finiteind)-c(2);
    newp(3,finiteind) = pts(3,finiteind)-c(3);
    
    dist = sqrt(newp(1,finiteind).^2 + newp(2,finiteind).^2 + newp(3,finiteind).^2);
    meandist = mean(dist(:));  % Ensure dist is a column vector for Octave 3.0.1
    
    scale = sqrt(3)/meandist;
    
    T = [scale   0      0   -scale*c(1);
         0     scale    0   -scale*c(2);
         0       0    scale -scale*c(3);
         0       0      0       1      ];
    
    newpts = T*pts;
    
    
    