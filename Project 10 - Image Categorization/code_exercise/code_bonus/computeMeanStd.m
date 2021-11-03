function [mu sigma] = computeMeanStd(vBoW)

numWords = size(vBoW, 2);
mu = zeros(1,numWords);
sigma = zeros(1,numWords);

for i=1:numWords
    mu(i) = mean(vBoW(:,i));
    sigma(i) = std(vBoW(:,i));
end


end