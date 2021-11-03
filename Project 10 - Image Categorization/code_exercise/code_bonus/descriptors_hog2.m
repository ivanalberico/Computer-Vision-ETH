function [descriptors,patches] = descriptors_hog2(img,vPoints,cellWidth,cellHeight)

    nBins = 4;
    nCellsW = 2; 
    nCellsH = 2; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(0,nBins*nCellsW*nCellsH); % one histogram for each of the cells
    patches = zeros(0,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
   
    
    for i = [1:size(vPoints,1)] % for all local feature points
        
        % Extract the image patch for each local feature descriptor
        image_patch = img((vPoints(i,2) - h):(vPoints(i,2) + h - 1), ...
                          (vPoints(i,1) - w):(vPoints(i,1) + w - 1));
        
        num_pixels_descriptor = nCellsW * nCellsH * cellWidth * cellHeight;
        
        patches(i,:) = reshape(image_patch, 1, num_pixels_descriptor);
        
        
        % Compute the histogram over the orientation for each cell of the descriptor
        idx = 1;
        
        for j = -2:1
            for k = -2:1
                patch_orientation = Gdir( (vPoints(i,2) + k*h):(vPoints(i,2) + (k+1) * h-1), ...
                                          (vPoints(i,1) + j*w):(vPoints(i,1) + (j+1) * w-1));                   
                descriptors(i, idx:idx+3) = histcounts(patch_orientation,nBins,'BinLimits',[-pi,pi]); 
                idx = idx + 4 ;
            end
        end
 
    end % for all local feature points
    
end
