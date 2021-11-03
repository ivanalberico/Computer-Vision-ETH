function dispRange = setRange_clickPoints(img1,img2)

[x1s, x2s] = getClickedPoints(img1, img2);

% min_dist = min(vecnorm(x1s - x2s)) ;
% max_dist = max(vecnorm(x1s - x2s)) ;

min_dist = min(x1s(1,:) - x2s(1,:)) ;
max_dist = max(x1s(1,:) - x2s(1,:)) ;

range_size = ceil(max(abs(min_dist),abs(max_dist)));
dispRange = -range_size:range_size;


end

