% Exercise 1
%
% clear all;
% close all;

IMG_NAME = 'images/image001.jpg';

%This function displays the calibration image and allows the user to click
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You can also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as input for your algorithms.

[xy, XYZ] = getpoints(IMG_NAME);

% === Task 1 Data normalization ===
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% === Task 2 DLT algorithm ===
[P, K, R, t, error] = runDLT(xy, XYZ);
visualization_reprojected_points(xy, XYZ, P, IMG_NAME);

% === Task 3 Gold Standard algorithm ===
[P, K, R, t, error] = runGoldStandard(xy, XYZ);
visualization_reprojected_points(xy, XYZ, P, IMG_NAME);
