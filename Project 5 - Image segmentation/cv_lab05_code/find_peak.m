function peak = find_peak(X, xl, radius)


threshold = 1; 
mean_shift = threshold + eps;
L = size(X,1);


while mean_shift > threshold
    
    xl_matrix = repmat(xl, [L, 1]);
    distance = sqrt(sum((X - xl_matrix).^2, 2));
    
    window = X(distance < radius, :);
    mode = mean(window,1);
  
    mean_shift = sqrt(sum((xl - mode).^2,2));
    xl = mode;
    
end

peak = mode;


end

