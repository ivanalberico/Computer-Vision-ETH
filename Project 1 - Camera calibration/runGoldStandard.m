%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);


%minimize geometric error to refine P_normalized
% TODO fill the gaps in fminGoldstandard.m
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];

for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

P_normalized = reshape(pn,4,3)';


% TODO: denormalize projection matrix
P = inv(T)*P_normalized*U;


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


reprojection_error_vector = xy - xy_projected;
for i = 1 : numPoints
    error = error + norm(reprojection_error_vector(:,i));
end

error = error/numPoints;



end