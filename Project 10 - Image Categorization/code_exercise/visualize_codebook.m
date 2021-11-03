function vCenters = visualize_codebook(vCenters,vFeatures,vPatches,cellWidth,cellHeight)

  patchWidth = 4*cellWidth;
  patchHeight = 4*cellHeight;  

  clusterPatches = zeros(patchHeight,patchWidth,1,0);
  scores = zeros(0,0);
  
  % assign all features to its nearest center
  [idx,dist] = knnsearch(vCenters, vFeatures);

   % for each center
  for i = 1:size(vCenters,1)
    % count matching features
    matching = find(idx==i);

    if (matching)

	  % find nearest feature to this center
      [d,smallest] = min(dist(matching));
      closestIdx = matching(smallest);

	  % get patch to this feature and store score
      p = reshape(vPatches(closestIdx,:),patchHeight,patchWidth,1);
      clusterPatches(:,:,:,end+1) = p;
      scores(end+1)=length(matching);
      
    end

  end
    
  [sortedScores,scoreOrder] = sort(scores,'descend');
  clusterPatches=clusterPatches(:,:,:,scoreOrder);
  
  montage(clusterPatches, 'DisplayRange', []);
    
end
