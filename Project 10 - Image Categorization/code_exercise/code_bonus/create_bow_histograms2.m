function vBoW = create_bow_histograms2(nameDir, vCenters)

  vImgNames = dir(fullfile(nameDir,'*.jpg'));
  nImgs = length(vImgNames);  
  vBoW  = [];
  
  cellWidth = 4;
  cellHeight = 4;
  nPointsX = 10;
  nPointsY = 10;
  border = 8;
  
  
  % Extract features for all images in the given directory
  for i=1:nImgs
    disp(strcat('  Processing image ', num2str(i),'...'));
    
    % load the image
    img = double(rgb2gray(imread(fullfile(nameDir,vImgNames(i).name))));

    % Collect local feature points for each image
    % and compute a descriptor for each local feature point
    vPoints = grid_points(img, nPointsX, nPointsY, border) ;
    [descriptor, patch] = descriptors_hog2(img, vPoints, cellWidth, cellHeight);
    

    % Create a BoW activation histogram for this image
    histogram = bow_histogram(descriptor, vCenters);
    vBoW = [vBoW; histogram] ;
    
  end
    
end