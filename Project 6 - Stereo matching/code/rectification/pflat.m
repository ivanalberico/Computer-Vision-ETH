function [y,alpha]=pflat(x);
% [y,alpha]=pflat(x) - normalization of projective points.
% Do a normalization on the projective
% points in x. Each column is considered to
% be a point in homogeneous coordinates.
% Normalize so that the last coordinate becomes 1.
% WARNING! This is not good if the last coordinate is 0.
% INPUT :
%  x     - matrix in which each column is a point.
% OUTPUT :
%  y     - result after normalization.
%  alpha - depth

[a,n]=size(x);
alpha=x(a,:);
y=x./(ones(a,1)*alpha);
