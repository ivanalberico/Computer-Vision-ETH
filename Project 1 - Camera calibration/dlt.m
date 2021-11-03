%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function

% TODO 1. For each correspondence xi <-> Xi, computes matrix Ai

xy = homogenization(xy);
XYZ = homogenization(XYZ);

numPoints = size(xy,2);

A = [];
x = xy(1,:);
y = xy(2,:);
w = xy(3,:);   % w = 1

for i=1:numPoints
    A_11 = XYZ(:,i)';
    A_12 = zeros(1,4);
    A_13 = -x(i) * XYZ(:,i)';
    
    A_21 = zeros(1,4);
    A_22 = -XYZ(:,i)';
    A_23 = y(i) * XYZ(:,i)';
    
    A = [      A; 
        A_11 A_12 A_13; 
        A_21 A_22 A_23];
end


% TODO 2. Compute the Singular Value Decomposition of Usvd*S*V' = A

[U,S,V] = svd(A);


% TODO 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)


P_normalized_column = V(:,end);

P_normalized = reshape(P_normalized_column,4,3)';


end
