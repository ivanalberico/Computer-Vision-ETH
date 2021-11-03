function ids = visualizeMostLikelySegments(I,alpha,mu,cov)

% you may use this function to visualize the currently
% most likely segments memberships (e.g. for debugging)
% I contains the features and is of size m x n x d, where m x n is the size of the image
% and d is the dimension of the features (3 for Lab color)

% use imagesc to draw the image

I = im2double(I);
K = length(alpha);

scores = zeros(size(I,1),size(I,2),K);

for i=1:K
   Imat = reshape(I,[size(I,1)*size(I,2),size(I,3)]);
   muMat = repmat(mu(:,i),[1,size(I,1)*size(I,2)]);
   Imu = Imat'-muMat;
   covMat = cov(:,:,i)^-1;
   covMatImu = covMat*Imu;
   covMatImucovMat = sum(covMatImu.*Imu,1);
   lik = 1/((2*pi)^(0.5*K))*(det(covMat))^0.5 * exp(-0.5*covMatImucovMat);
   scores(:,:,i) = alpha(i) * reshape(lik,[size(I,1),size(I,2)]);
end

[s ids] = max(scores,[],3);
% figure;
% imagesc(ids);

end