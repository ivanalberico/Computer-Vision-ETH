function [mu, var, alpha] = maximization(P, X)


K = size(P, 2);
L = size(X, 1);

alpha = zeros(1, K);
mu = zeros(K, 3);
var = zeros(3, 3, K);

for k = 1:K
    sum_I_ik = sum(P(:,k));
    
    alpha(k) = sum_I_ik / L;
    
    mu(k,:) = sum(X .* P(:,k)) / sum_I_ik;
      
    for i = 1:L
        var(:,:,k) = var(:,:,k) + P(i,k)* ( (X(i,:) - mu(k,:))' * (X(i,:) - mu(k,:)) );
    end
    
    var(:,:,k) = var(:,:,k) / sum_I_ik;
end

alpha = alpha / sum(alpha);

end