function P = expectation(mu, var, alpha, X)


K = length(alpha);
L = size(X,1);

P = zeros(L,K);


for i = 1:L
    for k = 1:K
        
        normalization_const = 1/((2*pi)^(3/2)*(det(var(:,:,k)))^(1/2));
        argument_exp = -0.5 * (X(i,:) - mu(k,:)) * pinv(var(:,:,k)) * (X(i,:) - mu(k,:))';
        
        P(i,k) = alpha(k) * normalization_const * exp(argument_exp);
    end
    P(i,:) = P(i,:)/sum(P(i,:));
end


end