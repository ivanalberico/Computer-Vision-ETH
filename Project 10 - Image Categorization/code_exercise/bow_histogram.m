function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
  
  N = size(vCenters,1);
  histo = zeros(1,N);
  
  for i=1:size(vFeatures,1)
      vFeatures_matrix = repmat(vFeatures(i,:),[N,1]);
      dist = sum((vCenters - vFeatures_matrix).^2, 2);
      
      [min_dist, cluster_idx] = min(dist);
      
      histo(cluster_idx) = histo(cluster_idx) + 1;
  end
 

end
