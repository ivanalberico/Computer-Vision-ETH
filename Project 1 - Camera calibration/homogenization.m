function [coord_homogeneous]=homogenization(coord_inhomogeneous)
% This function assumes that coordinates are given in a column vector -->
% it adds a "1" as a new row

[r,c]=size(coord_inhomogeneous);
array_homogeneous = ones(1,c); % array of 1 with size 1*Nb_points
 
coord_homogeneous = [coord_inhomogeneous; array_homogeneous]; % concatenate vertically to add a last row of ones

end