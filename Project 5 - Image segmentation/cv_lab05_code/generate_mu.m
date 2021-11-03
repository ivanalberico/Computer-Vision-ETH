% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)

mu = zeros(K,3);

for i = 1:3
    mu(:,i) = linspace(min(X(:,i)), max(X(:,i)), K)'; 
end

end





