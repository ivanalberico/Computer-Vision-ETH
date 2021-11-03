%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)


% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);


%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);


% % TODO denormalize projection matrix
P = inv(T)*Pn*U;

 
%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

 
% TODO compute average reprojection error
numPoints = size(xy,2);

error = 0;
xy_projected = [];
XYZ = homogenization(XYZ);
xy = homogenization(xy);


xy_projected = P * XYZ;
for i = 1 : numPoints
    xy_projected(:,i) = xy_projected(:,i)/xy_projected(3,i);
end

xy_projected = inhomogenization(xy_projected);
xy = inhomogenization(xy);

reprojection_error_vector = xy - xy_projected;
for i = 1 : numPoints
    error = error + norm(reprojection_error_vector(:,i));
end

error = error/numPoints;


end