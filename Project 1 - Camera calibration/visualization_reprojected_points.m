function visualization_reprojected_points (xy, XYZ, P, IMG_NAME)

% Apply projection matrix P
XYZ_homogeneous=homogenization(XYZ);
xyz_projected=P*XYZ_homogeneous;

% Compute Inhomogeneous projected points 
NB_PTS=size(XYZ,2);
xy_projected=zeros(2,NB_PTS);
for i=1:NB_PTS
    xy_projected(1,i)=xyz_projected(1,i)./xyz_projected(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected(2,i)=xyz_projected(2,i)./xyz_projected(3,i); % compute inhomogeneous coordinates y=y/z 
end

% Display on the calibration image
figure();
img = imread(IMG_NAME);
image(img);
hold on;
for n=1:NB_PTS
    plot(xy(1,n), xy(2,n), 'g+', 'MarkerSize', 12, 'linewidth', 1.3) % clicked points 
    plot(xy_projected(1,n), xy_projected(2,n), 'ro', 'MarkerSize', 10, 'linewidth', 1.3) % reprojected points
end
hold off;



% Visualize all points



end