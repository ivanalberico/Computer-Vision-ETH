function d = distPointLine( point, line )
% d = distPointLine( point, line )
% point: inhomogeneous 2d point (2-vector)
% line: 2d homogeneous line equation (3-vector)

line = line./norm(line(1:2));
d = abs(dot([point 1],line));
