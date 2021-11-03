% PROJMATRIX - computes projection matrix from 6 or more 3D-2D points
%
% Function computes the projection matrix from 6 or more 3D-2D matching points in
% a stereo pair of images.  The normalised 6 point algorithm given by
% Hartley and Zisserman is used.  To achieve accurate results it is
% recommended that 12 or more points are used
%
% Usage:   [P] = projmatrix(x1, x2)
%
% Arguments:
%          x1, x2 - Two sets of corresponding 3xN and 4xN set of homogeneous
%          points.
% Returns:
%          P      - The 3x4 projection matrix.

function [P] = projmatrix(varargin)

    [x1, x2, npts] = checkargs(varargin(:));

    Octave = exist('OCTAVE_VERSION') ~= 0;  % Are we running under Octave?    
    
    % Normalise each set of points so that the origin 
    % is at centroid and mean distance from origin is sqrt(2). 
    % normalise2dpts also ensures the scale parameter is 1.
    [xy, T1] = normalise2dpts(x1);
    [XYZ, T2] = normalise3dpts(x2);
    
    % Build the constraint matrix
    A = [XYZ(1,:)' XYZ(2,:)' XYZ(3,:)' ones(npts,1) zeros(npts,1) zeros(npts,1) zeros(npts,1) zeros(npts,1) -xy(1,:)'.*XYZ(1,:)' -xy(1,:)'.*XYZ(2,:)' -xy(1,:)'.*XYZ(3,:)' -xy(1,:)';
         zeros(npts,1) zeros(npts,1) zeros(npts,1) zeros(npts,1) XYZ(1,:)' XYZ(2,:)' XYZ(3,:)' ones(npts,1) -xy(2,:)'.*XYZ(1,:)' -xy(2,:)'.*XYZ(2,:)' -xy(2,:)'.*XYZ(3,:)' -xy(2,:)'];

    if Octave
	[U,D,V] = svd(A);   % Don't seem to be able to use the economy
                            % decomposition under Octave here
    else
	[U,D,V] = svd(A,0); % Under MATLAB use the economy decomposition
    end

    Pvec = V(:, end);
    P =  [Pvec(1) Pvec(2)  Pvec(3)  Pvec(4) ;
         Pvec(5) Pvec(6)  Pvec(7)  Pvec(8) ;
         Pvec(9) Pvec(10) Pvec(11) Pvec(12)];
    
    % Denormalise
    P = inv(T1)*P*T2;
    
function [x1, x2, npts] = checkargs(arg);
    
    if length(arg) == 2
        x1 = arg{1};
        x2 = arg{2};
        
    elseif length(arg) == 1
            x1 = arg{1}(1:3,:);
            x2 = arg{1}(4:7,:);
    else
        error('Wrong number of arguments supplied');
    end
    
    npts = size(x1,2);
