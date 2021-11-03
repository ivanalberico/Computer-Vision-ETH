%depth image in double
%img - rgb image in double

function create3DModel(depth, img, fig)
    skip = 1;
    img = img(1:skip:end, 1:skip:end, :);
    depth = (depth(1:skip:end, 1:skip:end));

    [sx, sy] = size(depth);
    
    K = [1 0 sx/2;
         0 1 sy/2;
         0 0    1];
    Kinv = inv(K);
            
    % Get 3d points.
    [Xp Yp] = meshgrid(1:size(depth,2), 1:size(depth,1));
    Zp = depth;

    figure(fig);   
    imgR = img(:,:,1);
    imgG = img(:,:,2);
    imgB = img(:,:,3);
    col = [imgR(:), imgG(:), imgB(:)];
    
    %chose either scatter3 or trisurf method to plot
    if (false)
        Xp = depth .* (Xp*Kinv(1,1) + Yp*Kinv(1,2) + Kinv(1,3));
        Yp = depth .* (Yp*Kinv(2,2) + Kinv(2,3));
        scatter3(Xp(:), Yp(:), Zp(:), 1, col);
    else
        tri = delaunay(Xp(:), Yp(:));
        trisurf(tri, Xp(:), Yp(:), Zp(:));
        trisurf(tri, Xp(:), Yp(:), Zp(:),'FaceVertexCData', col, 'LineStyle', 'none', 'FaceColor', 'interp');                  
    end
end