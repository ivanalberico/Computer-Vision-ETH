% =========================================================================
% Line fitting with RANSAC
% =========================================================================

clear, close all
addpath helpers
figure(1); clf; hold on;

% Generate noisy points for the real model
num = 200; % number of points
X = -num/2:num/2;
outlr_ratio = .5;
inlr_std = 4;
k = .5;
b = 10;
pts = genRansacTestPoints(num, outlr_ratio, inlr_std, [k b]);
plot(pts(1,:), pts(2,:),'.');


%% (BLACK LINE) Real model of the line:  y = kx + b
plot(X, k*X+b, 'k');
err_real = sqr_error(k, b, pts(:,1:num*(1-outlr_ratio)))


%% (GREEN LINE) least square fitting
coef2 = polyfit(pts(1,:), pts(2,:), 1);
k1 = coef2(1);
b2 = coef2(2);
plot(X,k1*X+b2,'g')

% measure error on "true" inliers
err_ls = sqr_error(k1, b2, pts(:,1:num*(1-outlr_ratio)))


%% (RED LINE) RANSAC
iter = 5000;
thresh_dist = 2;

% TODO: implement ransacLine
[k2, b2] = ransacLine(pts, iter, thresh_dist);
plot(X, k2*X+b2,'r');

% measure error on "true" inliers
err_ransac = sqr_error(k2, b2, pts(:,1:num*(1-outlr_ratio)))


%% Show inliers
% Calculate distance from points to a line
distance = (-pts(2,:)+k2*pts(1,:)+b2) / (sqrt(1+k2*k2));
inlier_idx = find(abs(distance) <= thresh_dist);
plot(pts(1,inlier_idx), pts(2,inlier_idx),'or');
