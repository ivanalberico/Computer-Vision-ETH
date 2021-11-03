function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here
    
    indices = randperm(num_pts , 2);
    
    first_point = data(:, indices(1));
    second_point = data(:, indices(2));
    
    
    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    
    coefficients = polyfit( [first_point(1) second_point(1)], [first_point(2) second_point(2)], 1 );
    k_line = coefficients(1);
    b_line = coefficients(2);
    
    
    % Compute the distances between all points with the fitting line
    distance = (-data(2,:) + k_line * data(1,:) + b_line) / (sqrt(1 + k_line * k_line));
    
    
    % Compute the inliers with distances smaller than the threshold
    inlier_idx = find(abs(distance) <= threshold);
    
    
    % Update the number of inliers and fitting model if the current model
    % is better.
    
    num_inliers = size(inlier_idx, 2);
    
    inliers = data(:,inlier_idx);
    
    if (num_inliers > best_num_inliers)
       best_num_inliers = num_inliers;
       
       coefficients = polyfit(inliers(1,:), inliers(2,:), 1);
      
       best_k = coefficients(1);
       best_b = coefficients(2);
       
    end
end


end
