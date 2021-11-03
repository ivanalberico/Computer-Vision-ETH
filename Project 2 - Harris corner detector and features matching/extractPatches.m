% Extract patches from an image around specific points.
% 
% Input:
%   img          - n x m image
%   keypoints    - 2 x q points of interest
%   patch_size   - integer
function patches = extractPatches(img, keypoints, patch_size)
    keypoints = double(keypoints);

    patch_size = int32(patch_size);
    half_patch_size = idivide(patch_size, 2);

    % Generic grid centered in (0, 0)
    [x, y] = meshgrid(-half_patch_size : half_patch_size, -half_patch_size : half_patch_size);
    grid = [x(:), y(:)]';
    grid = double(grid);

    % Add the grid to each of the keypoints.
    grid_keypoints = bsxfun( ...
        @plus, ...
        repmat(grid, [1, size(keypoints, 2)]), ...
        reshape(repmat(keypoints, [size(grid, 2), 1]), 2, []) ...
    );
    
    % Transform from 2D indices to 1D indices.
    ids = squeeze(sub2ind(size(img), grid_keypoints(1, :), grid_keypoints(2, :)));
    
    % Recover the final patches.
    patches = reshape(img(ids), patch_size * patch_size, []);
end 