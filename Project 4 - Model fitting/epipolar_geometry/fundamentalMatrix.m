% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)


[n_x1s, T1] = normalizePoints2d(x1s);
[n_x2s, T2] = normalizePoints2d(x2s);


num_points = size(n_x1s, 2);

x_1 = n_x1s(1,:);
y_1 = n_x1s(2,:);

x_2 = n_x2s(1,:);
y_2 = n_x2s(2,:);


A = [x_1 .* x_2   ;
     x_2 .* y_1   ;
     x_2          ;
     y_2 .* x_1   ;
     y_1 .* y_2   ;
     y_2          ;
     x_1          ;
     y_1          ;
     ones(1,num_points)]';

[U,S,V_t] = svd(A);
F_vector = V_t(:,end);
F_normalized = [F_vector(1:3,1)'; F_vector(4:6,1)'; F_vector(7:9,1)'];



F = (T2') * F_normalized * (T1);

% To impose the det(F) = 0 constraint, we apply the svd to F and then we
% set the smallest singular value to 0 (element in position (3,3) of matrix S)

[U,S,V_t] = svd(F);

S(3,3) = 0;

Fh = U * S * (V_t)';



end