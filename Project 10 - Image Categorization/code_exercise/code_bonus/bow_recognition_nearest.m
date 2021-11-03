function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor (using knnsearch) in the positive and negative sets
  % and decide based on this neighbor
  [idxPos, DistPos] = knnsearch(vBoWPos, histogram);
  [idxNeg, DistNeg] = knnsearch(vBoWNeg, histogram);
  
  if (DistPos<DistNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
