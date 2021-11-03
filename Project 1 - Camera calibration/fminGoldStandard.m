%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];


% TODO compute reprojection errors
xy_normalized = homogenization(xy_normalized);
XYZ_normalized = homogenization(XYZ_normalized);

numPoints = size(xy_normalized,2);

xy_projected = P * XYZ_normalized;
for i = 1 : numPoints
    xy_projected(:,i) = xy_projected(:,i)/xy_projected(3,i);
end

reprojection_error_vector = xy_normalized - xy_projected;


% TODO compute cost function value

f = 0;

for i=1:numPoints
    f = f + norm(reprojection_error_vector(:,i))^2;
end



end