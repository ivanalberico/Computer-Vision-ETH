function d = sc_compute(X, nbBins_theta, nbBins_r, smallest_r, biggest_r)


X = X';         % size of X: [nsamp, 2]

nsamp = size(X,1);
d = cell(nsamp,1);                 



% I first compute an equally spaced range (though linspace)and then I take
% the log of its values (log is taken afterwards because the bins in the
% radial dimension do not need to have the same length.

r = log(linspace(smallest_r, biggest_r, nbBins_r + 1));

theta = linspace(0, 2*pi, nbBins_theta + 1);


distance_pairs_X = sqrt(dist2(X,X));
mean_dist = mean2(distance_pairs_X);


for i=1:nsamp

    point_i = X(i,:);
    
    point_i_vector = repmat(point_i, nsamp ,1);
    distance = X - point_i_vector;
    distance(i,:) = [];
    
    [X_theta, X_r] = cart2pol(distance(:,1), distance(:,2));
    
    X_r_normalized = X_r / mean_dist;
    

    d{i} = hist3([X_theta, log(X_r_normalized)], 'Edges', {theta, r});
    
    
end


end
