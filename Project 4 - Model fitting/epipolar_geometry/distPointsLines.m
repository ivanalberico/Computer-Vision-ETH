% Compute the distance for pairs of points and lines
% Input
%   points    Homogeneous 2D points 3xN
%   lines     2D homogeneous line equation 3xN
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(points, lines)

d = abs(points(1,:).*lines(1,:) + points(2,:).*lines(2,:) + lines(3,:))./(sqrt((lines(1,:)).^2 + (lines(2,:)).^2));

end

