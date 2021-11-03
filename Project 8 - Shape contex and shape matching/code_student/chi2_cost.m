function C = chi2_cost(s1,s2)

num1 = numel(s1);
num2 = numel(s2);

C = zeros(num1,num2);

for i=1:num1
    for j=1:num2
       cost = 1/2 * (s1{i} - s2{j}).^2 ./ (s1{i} + s2{j});
       % cost = 1/2 * (s1{i} - s2{j}).^2 ./ (s1{i} + s2{j} + eps);
       
       cost_size = size(cost);
       
       cost = cost(:);
       
       for k=1:size(cost,1)
           if isnan(cost(k))
               cost(k) = 0;
           end
       end
       
       cost = reshape(cost, cost_size);

       C(i,j) = sum(sum(cost));
    end
end

end