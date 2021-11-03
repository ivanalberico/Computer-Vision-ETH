% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)

function [nxs, T] = normalizePoints2d(xs)


% The points' coordinates are already in the homogeneous representation


xs_centroid = mean(xs, 2);


T0 = [1   0   -xs_centroid(1) ; 
      0   1   -xs_centroid(2) ; 
      0   0        1     ];
  
xs_shifted = T0*xs; 




xs_std = std(xs_shifted,0,2);


T_inv = [xs_std(1)     0      xs_centroid(1);
            0      xs_std(2)  xs_centroid(2);
            0          0            1       ];

T = inv(T_inv);


nxs = T * xs;



% The same result could have been reached also in a more compact way, as
% shown below:

% m = mean(xs');
% s = std(xs');
% nxs = (xs - m') ./ s';



end
