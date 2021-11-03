% Generate initial values for the K covariance matrices

function cov = generate_cov(X, K)

cov = zeros(3, 3, K);

range_L = max(X(:,1)) - min(X(:,1));
range_a = max(X(:,2)) - min(X(:,2));
range_b = max(X(:,3)) - min(X(:,3));


for i=1:K
    cov(:,:,i) = diag([range_L, range_a, range_b]);
end

end


