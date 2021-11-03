function vPoints = grid_points(img,nPointsX,nPointsY,border)


[height , width] = size(img) ;

x_points = int32(linspace(border + 1, width - border, nPointsX));
y_points = int32(linspace(border + 1, height - border, nPointsY));


[x_points_grid, y_points_grid] = meshgrid(x_points, y_points) ;

x_points_grid = reshape(x_points_grid, nPointsX*nPointsY, 1) ;
y_points_grid = reshape(y_points_grid, nPointsY*nPointsX, 1) ;


vPoints = [x_points_grid, y_points_grid] ; 



end
