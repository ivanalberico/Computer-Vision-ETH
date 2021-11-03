function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);


% Bayesian classification
num_words = size(vBoWPos,2);  
log_likelihood_car = 0; log_likelihood_nocar = 0;

for i=1:num_words

    % Probability of observing histogram(i) in the set of positive training images
    prob_pos = normpdf(histogram(i),muPos(i),sigmaPos(i));
    
    if isnan(prob_pos)
        prob_pos = 1;
    end
    
    log_prob_pos = log(prob_pos);
    log_likelihood_car = log_likelihood_car + log_prob_pos;
    
   
    % Probability of observing histogram(i) in the set of negative training images
    prob_neg = normpdf(histogram(i),muNeg(i),sigmaNeg(i));
    
    if isnan(prob_neg)
        prob_neg = 1;
    end
    
    log_prob_neg = log(prob_neg);
    log_likelihood_nocar = log_likelihood_nocar + log_prob_neg;
      
end

likelihood_car = exp(log_likelihood_car);          % P(hist|car)
likelihood_nocar = exp(log_likelihood_nocar);      % P(hist|!car)


prior_car = 0.5; 
prior_nocar = 0.5;

posterior_car = likelihood_car * prior_car;
posterior_nocar = likelihood_nocar * prior_nocar;


if posterior_car > posterior_nocar
    label = 1;
else
    label = 0;
end


end