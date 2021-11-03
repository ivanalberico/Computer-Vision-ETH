function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = realmax;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;

sample_count = 0;

% Variables for adaptive RANSAC
adaptive_ransac = true;
p = 0.9999;


while sample_count < iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    random_indices = randperm(num_pts,8);
    x1_ransac = x1(:,random_indices);
    x2_ransac = x2(:,random_indices);
    
    % Compute the error.
    [Fh,F] = fundamentalMatrix(x1_ransac,x2_ransac);
    
    
    error = 0;
    error = (1/2)*(distPointsLines(x2, F*x1) + distPointsLines(x1, (F')*x2));
    inliers = [];    
    
    % Compute the inliers with errors smaller than the threshold.
    for j=1:num_pts
        if error(:,j) < threshold
            inliers = [inliers j];
        end
    end
        
    % Update the number of inliers and fitting model if the current model
    % is better.
    
    num_inliers = size(inliers,2);

    
    if num_inliers > best_num_inliers
        best_num_inliers = num_inliers;
        best_inliers = inliers;
        best_F = F;
        
        if adaptive_ransac
            M = sample_count;     % number of iterations
            r = num_inliers/num_pts;
            p_current = 1-(1-r^8)^M;

            if p_current > p
                sample_count = iter;
                fprintf('Adaptive RANSAC - Number of iterations: %i \n', M);
            end
        end
        
    end
    
    sample_count = sample_count + 1;
       
end



end
