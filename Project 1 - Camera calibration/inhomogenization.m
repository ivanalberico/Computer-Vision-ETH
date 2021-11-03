function [coord_inhomogeneous]=inhomogenization(coord_homogeneous)
% This function assumes that coordinates are given in a column vector -->
% it divides coordinates by the last one w

[r,c]=size(coord_homogeneous);

coord_inhomogeneous=zeros(r-1,c);
for i=1:r-1
    for j=1:c
        coord_inhomogeneous(i,j)=coord_homogeneous(i,j)./coord_homogeneous(r,j); % compute inhomogeneous coordinates x=x/w or y=y/w or z=z/w 
    end
end

end