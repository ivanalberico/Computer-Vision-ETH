%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn
% T: 3x3
% U: 4x4

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)



%data normalization

% TODO 1. compute centroids

xy = homogenization(xy);
XYZ = homogenization(XYZ);

xy_centroid = [0, 0];
XYZ_centroid = [0, 0, 0];

[numCoordinates, numPoints] = size(xy);

for i=1:numPoints
    xy_centroid(1) = xy_centroid(1) + xy(1,i); 
    xy_centroid(2) = xy_centroid(2) + xy(2,i);
    
    XYZ_centroid(1) = XYZ_centroid(1) + XYZ(1,i);
    XYZ_centroid(2) = XYZ_centroid(2) + XYZ(2,i);
    XYZ_centroid(3) = XYZ_centroid(3) + XYZ(3,i);
end

xy_centroid = xy_centroid./numPoints;
XYZ_centroid = XYZ_centroid./numPoints;

% TODO 2. shift the points to have the centroid at the origin

T1 = [1   0   -xy_centroid(1) ; 
      0   1   -xy_centroid(2) ; 
      0   0        1     ];
  
U1 = [1   0   0   -XYZ_centroid(1) ; 
      0   1   0   -XYZ_centroid(2) ; 
      0   0   1   -XYZ_centroid(3) ; 
      0   0   0       1];

xy_zero_mean = T1*xy; 
XYZ_zero_mean = U1*XYZ;



xy_sum_norm = 0; 
XYZ_sum_norm = 0;

for i=1:numPoints
    xy_sum_norm = xy_sum_norm + norm(xy_zero_mean(1:2,i));
    XYZ_sum_norm = XYZ_sum_norm + norm(XYZ_zero_mean(1:3,i));
end

xy_average_norm = xy_sum_norm/numPoints; 
XYZ_average_norm = XYZ_sum_norm/numPoints;


% TODO 3. compute scale

scale_T = 1/xy_average_norm;
scale_U = 1/XYZ_average_norm;


% TODO 4. create T and U transformation matrices (similarity transformation)

T = scale_T * T1;
T(3,3) = 1;

U = scale_U * U1;
U(4,4) = 1;

% TODO 5. normalize the points according to the transformations

xy_normalized = T * xy;
xy_normalized = inhomogenization(xy_normalized);

XYZ_normalized = U * XYZ;
XYZ_normalized = inhomogenization(XYZ_normalized);


end