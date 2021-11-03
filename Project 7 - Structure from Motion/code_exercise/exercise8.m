% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 22);






threshold_RANSAC_F = 0.00001;
threshold_RANSAC_P = 0.01;

%% Compute essential matrix and projection matrices and triangulate matched points (image 0 - image 4)

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices



x1 = makehomogeneous(fa(1:2, matches(1,:)));
x2 = makehomogeneous(fb(1:2, matches(2,:)));

% Compute the inliers with RANSAC algorithm and plot them
[F, inliers] = ransacfitfundmatrix(x1, x2, threshold_RANSAC_F);

x1_inliers = x1(:, inliers);
x2_inliers = x2(:, inliers);
showFeatureMatches(img1, x1_inliers(1:2,:), img2, x2_inliers(1:2,:), 5);

% Compute outliers
num_matches = size(matches, 2);
x1_outliers = [];
x2_outliers = [];

for i = 1:num_matches
    is_inlier = 0;
    
    for j = 1:size(x1_inliers,2)
        if x1(1:2,i) == x1_inliers(1:2,j)
            is_inlier = 1;
        end
    end
    
    if is_inlier == 0
        x1_outliers = [x1_outliers, x1(:,i)];
        x2_outliers = [x2_outliers, x2(:,i)];
    end
   
end


showFeatureMatches(img1, x1_outliers(1:2,:), img2, x2_outliers(1:2,:), 6);



% Essential matrix
E = (K') * F * K;

% draw epipolar lines and epipoles in img 1 

figure(7);

imshow(img1, []);
hold on;
plot(x1_inliers(1,:), x1_inliers(2,:), '*r');

for k = 1:size(x1_inliers,2)
    drawEpipolarLines(F' * x2_inliers(:,k), img1); hold on;
end


% draw epipolar lines and epipoles in img 2

figure(8);

imshow(img2, []);
hold on;
plot(x2_inliers(1,:), x2_inliers(2,:), '*r');

for k = 1:size(x2_inliers,2)
    drawEpipolarLines(F * x1_inliers(:,k), img2); hold on;
end



x1_calibrated = inv(K) * x1_inliers;
x2_calibrated = inv(K) * x2_inliers;

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches with the computed projection matrix

[X_3d, error] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);


%% Add an addtional view of the scene (image 0 - image 1) 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);


threshold_RANSAC_F = 0.000001;

%match against the features from image 1 that where triangulated
fa_triangulated = fa(:, matches(1, inliers));
da_triangulated = da(:, matches(1, inliers));

[matches_ac, scores_ac] = vl_ubcmatch(da_triangulated, dc);

x1_ac = makehomogeneous(fa_triangulated(1:2, matches_ac(1,:)));
x3 = makehomogeneous(fc(1:2, matches_ac(2,:)));

x3_calibrated = inv(K) * x3; 
X_3d_matches_ac = X_3d(:, matches_ac(1,:));

%run 6-point ransac
[Ps{3}, inliers_ac] = ransacfitprojmatrix(x3_calibrated(1:2,:), X_3d_matches_ac, threshold_RANSAC_P);

if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3} = -Ps{3};
    Ps{3}(4, 4) = 1;
end


x1_inliers_ac = x1_ac(:, inliers_ac);
x3_inliers = x3(:, inliers_ac);

showFeatureMatches(img1, x1_inliers_ac(1:2,:), img3, x3_inliers(1:2,:), 15);

% Compute outliers
num_matches = size(matches_ac, 2);
x1_outliers_ac = [];
x3_outliers = [];

for i = 1:num_matches
    is_inlier = 0;
    
    for j = 1:size(x1_inliers_ac,2)
        if x1_ac(1:2,i) == x1_inliers_ac(1:2,j)
            is_inlier = 1;
        end
    end
    
    if is_inlier == 0
        x1_outliers_ac = [x1_outliers_ac, x1_ac(:,i)];
        x3_outliers = [x3_outliers, x3(:,i)];
    end
   
end


showFeatureMatches(img1, x1_outliers_ac(1:2,:), img3, x3_outliers(1:2,:), 16);



%triangulate the inlier matches with the computed projection matrix
x1_calibrated_ac = inv(K) * x1_inliers_ac;                   
x3_calibrated = inv(K) * x3_inliers;  

[X_3d_ac, error_ac] = linearTriangulation(Ps{1}, x1_calibrated_ac, Ps{3}, x3_calibrated);


%% Add more views (image 0 - image 2)
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

threshold_RANSAC_F = 0.000001;

%match against the features from image 1 that where triangulated
fa_triangulated = fa(:, matches(1, inliers));
da_triangulated = da(:, matches(1, inliers));

[matches_ad, scores_ad] = vl_ubcmatch(da_triangulated, dd);

x1_ad = makehomogeneous(fa_triangulated(1:2, matches_ad(1,:)));
x4 = makehomogeneous(fd(1:2, matches_ad(2,:)));

x4_calibrated = inv(K) * x4; 
X_3d_matches_ad = X_3d(:, matches_ad(1,:));

%run 6-point ransac
[Ps{4}, inliers_ad] = ransacfitprojmatrix(x4_calibrated(1:2,:), X_3d_matches_ad, threshold_RANSAC_P);

if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4} = -Ps{4};
    Ps{4}(4, 4) = 1;
end


x1_inliers_ad = x1_ad(:, inliers_ad);
x4_inliers = x4(:, inliers_ad);

showFeatureMatches(img1, x1_inliers_ad(1:2,:), img4, x4_inliers(1:2,:), 17);

% Compute outliers
num_matches = size(matches_ad, 2);
x1_outliers_ad = [];
x4_outliers = [];

for i = 1:num_matches
    is_inlier = 0;
    
    for j = 1:size(x1_inliers_ad,2)
        if x1_ad(1:2,i) == x1_inliers_ad(1:2,j)
            is_inlier = 1;
        end
    end
    
    if is_inlier == 0
        x1_outliers_ad = [x1_outliers_ad, x1_ad(:,i)];
        x4_outliers = [x4_outliers, x4(:,i)];
    end
   
end


showFeatureMatches(img1, x1_outliers_ad(1:2,:), img4, x4_outliers(1:2,:), 18);



%triangulate the inlier matches with the computed projection matrix
x1_calibrated_ad = inv(K) * x1_inliers_ad;                   
x4_calibrated = inv(K) * x4_inliers;  

[X_3d_ad, error_ad] = linearTriangulation(Ps{1}, x1_calibrated_ad, Ps{4}, x4_calibrated);


%% Adding more views (image 0 - image 3)
imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img4);

threshold_RANSAC_F = 0.000001;

%match against the features from image 1 that where triangulated
fa_triangulated = fa(:, matches(1, inliers));
da_triangulated = da(:, matches(1, inliers));

[matches_ae, scores_ae] = vl_ubcmatch(da_triangulated, de);

x1_ae = makehomogeneous(fa_triangulated(1:2, matches_ae(1,:)));
x5 = makehomogeneous(fe(1:2, matches_ae(2,:)));

x5_calibrated = inv(K) * x5; 
X_3d_matches_ae = X_3d(:, matches_ae(1,:));

%run 6-point ransac
[Ps{5}, inliers_ae] = ransacfitprojmatrix(x5_calibrated(1:2,:), X_3d_matches_ae, threshold_RANSAC_P);

if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5} = -Ps{5};
    Ps{5}(4, 4) = 1;
end


x1_inliers_ae = x1_ae(:, inliers_ae);
x5_inliers = x5(:, inliers_ae);

showFeatureMatches(img1, x1_inliers_ae(1:2,:), img5, x5_inliers(1:2,:), 19);

% Compute outliers
num_matches = size(matches_ae, 2);
x1_outliers_ae = [];
x5_outliers = [];

for i = 1:num_matches
    is_inlier = 0;
    
    for j = 1:size(x1_inliers_ae,2)
        if x1_ae(1:2,i) == x1_inliers_ae(1:2,j)
            is_inlier = 1;
        end
    end
    
    if is_inlier == 0
        x1_outliers_ae = [x1_outliers_ae, x1_ae(:,i)];
        x5_outliers = [x5_outliers, x5(:,i)];
    end
   
end


showFeatureMatches(img1, x1_outliers_ae(1:2,:), img5, x5_outliers(1:2,:), 20);



%triangulate the inlier matches with the computed projection matrix
x1_calibrated_ae = inv(K) * x1_inliers_ae;                   
x5_calibrated = inv(K) * x5_inliers;  

[X_3d_ae, error_ae] = linearTriangulation(Ps{1}, x1_calibrated_ae, Ps{5}, x5_calibrated);


%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
plot3(X_3d(1,:), X_3d(2,:), X_3d(3,:), 'b.'); hold on;
plot3(X_3d_ac(1,:), X_3d_ac(2,:), X_3d_ac(3,:), 'r.'); hold on;
plot3(X_3d_ad(1,:), X_3d_ad(2,:), X_3d_ad(3,:), 'y.'); hold on;
plot3(X_3d_ae(1,:), X_3d_ae(2,:), X_3d_ae(3,:),'g.'); hold on;

%draw cameras
drawCameras(Ps, fig);
 

%% Dense reconstruction (bonus)

dense_reconstruction = false;

if dense_reconstruction
    
    close all;

    % We take the first two images as views to compute the 3D dense
    % reconstruction
    imgNameL = '../data/house.000.pgm';     % view1
    imgNameR = '../data/house.001.pgm';     % view2

    scale = 1;
    % scale = 0.5;

    imgL = imresize(single(imread(imgNameL)), scale);
    imgR = imresize(single(imread(imgNameR)), scale);


    PL = K * Ps{1}(1:3,:);
    PR = K * Ps{3}(1:3,:);  % Ps{3} is the projection matrix of image 1

    [imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
        getRectifiedImages(imgL, imgR);

    figure(30);
    subplot(121); imshow(imgRectL,[]);
    subplot(122); imshow(imgRectR,[]);


    dispRange = -18:18;


    %Compute disparities using graphcut
    %(exercise 5.2)
    Labels = gcDisparity(imgRectL, imgRectR, dispRange);
    dispsGCL = double(Labels + dispRange(1));
    
    Labels = gcDisparity(imgRectR, imgRectL, dispRange);
    dispsGCR = double(Labels + dispRange(1));

    figure(63);
    subplot(121); imshow(dispsGCL, [dispRange(1) dispRange(end)]);
    subplot(122); imshow(dispsGCR, [dispRange(1) dispRange(end)]);



    [coords ~] = generatePointCloudFromDisps(dispsGCL, Hleft, Hright, PL, PR);
    % depth_map = coords(:, :, 3);

    thresh = 8;
    maskLRcheck = leftRightCheck(dispsGCL, dispsGCR, thresh);
    maskRLcheck = leftRightCheck(dispsGCR, dispsGCL, thresh);

    maskGCL = double(maskL).*maskLRcheck;
    maskGCR = double(maskR).*maskRLcheck;

    imwrite(imgRectL, 'imgRectL.png');
    imwrite(imgRectR, 'imgRectR.png');

    % Use meshlab to open generated textured model, i.e. modelGC.obj
    generateObjFile('modelGC', 'imgRectL.png', ...
        coords, maskGCL.*maskGCR);
    
    
    
    
    % ALTERNATIVE WAY: Compute the depth map from the disparity map
    camera_position1 = Ps{1}(:,4);
    camera_position2 = Ps{3}(:,4);

    baseline = norm(camera_position1 - camera_position2);

    focal_length = K(1,1);

    depth = (baseline * focal_length)./dispsGCL;
    
    imgRectL_RGB = cat(3, imgRectL, imgRectL, imgRectL);

    % Get 3D model
    % create3DModel(depth, imgRectL_RGB, 40);
    
end

