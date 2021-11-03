function drawEpipolarLines( line, im, style )
% Plots a line in the image.
% Style is optional.

if nargin == 2
    style = 'b-';
end

% Intersect line with lines representing image borders.
X1 = cross(line,[1 0 -1]);
X1 = X1(1:2)/X1(3);
X2 = cross(line,[1 0 -size(im,2)]);
X2 = X2(1:2)/X2(3);
X3 = cross(line,[0 1 -1]);
X3 = X3(1:2)/X3(3);
X4 = cross(line,[0 1 -size(im,1)]);
X4 = X4(1:2)/X4(3);

% Find intersections which are not outside the image,
% which will therefore be on the image border.
Xs = [X1; X2; X3; X4];numFound = 0;

for p = 1:4
    X = Xs(p,:);
    if X(1) > 0 && X(1) <= size(im,2)+1e-6 && X(2) > 0 && X(2) <= size(im,1)+1e-6
        numFound = numFound + 1;
        if numFound==1
            P1 = X;
        else
            P2 = X;
            break;
        end
    end
end

% Plot line, if it's visible in the image.
if numFound == 2
    plot([P1(1) P2(1)],[P1(2) P2(2)],style);
end
