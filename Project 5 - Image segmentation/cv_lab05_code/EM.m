function [map, cluster] = EM(img)

normalize_points = true;
K = 4;   % number of clusters
convergence_value = 0.05;



img = double(img);

heigth_img = size(img, 1);
width_img = size(img, 2);
L = heigth_img * width_img;

X_L = reshape(img(:,:,1), L, 1);
X_a = reshape(img(:,:,2), L, 1);
X_b = reshape(img(:,:,3), L, 1);

X = [X_L, X_a, X_b];

if normalize_points
    [X, T] = normalization(X);
end




% Initializing alpha
alpha_k = 1/K;
alpha = [];

for i=1:K
    alpha = [alpha, alpha_k];
end

mean = generate_mu(X,K);
covariance = generate_cov(X,K);




mean_shift = realmax;

while mean_shift > convergence_value
    P = expectation(mean, covariance, alpha, X);
    
    [mean_updated, covariance_updated, alpha_updated] = maximization(P, X);
    
    mean_shift = norm(mean(:) - mean_updated(:));
    
    mean = mean_updated;
    covariance = covariance_updated;
    alpha = alpha_updated;

end

% To each pixel we assign the cluster that shows the highest probability
% (the max among the K values associated to each pixel)

cluster_idx = [];

for i=1:L
    [ ~ , cluster_idx_i] = max(P(i,:));
    cluster_idx = [cluster_idx, cluster_idx_i];
end

map = reshape(cluster_idx, [heigth_img, width_img, 1]);

cluster = mean;


% Unnormalize the peak
if normalize_points
    cluster = denormalization(cluster, T);
end


% report values for report
cluster_peaks = cluster
cov = covariance
weight = alpha

end