% RANSACFITPROJMATRIX - fits projection matrix using RANSAC
%
% Usage:   [P, inliers] = ransacfitprojmatrix(x1, x2, t)
%
% Arguments:
%          x1  - 2xN or 3xN set of homogeneous points.  If the data is
%                2xN it is assumed the homogeneous scale factor is 1.
%          x2  - 3xN or 4xN set of homogeneous points such that x1<->x2.
%          t   - The distance threshold between data point and the model
%                used to decide whether a point is an inlier or not
%                (reprojection error in pixels). 
%                
%
% Note that it is assumed that the matching of x1 and x2 are putative and it
% is expected that a percentage of matches will be wrong.
%
% Returns:
%          P       - The 4x4 projection matrix
%          inliers - An array of indices of the elements of x1, x2 that were
%                    the inliers for the best model.
%
% See Also: RANSAC, PROJMATRIX

function [P, inliers] = ransacfitprojmatrix(x1, x2, t, feedback)

    if nargin == 3
	feedback = 0;
    end
    
    [rows,npts] = size(x1);
    if rows~=2 & rows~=3
        error('x1 must have 2 or 3 rows');
    end
    
    if rows == 2    % Pad data with homogeneous scale factor of 1
        x1 = [x1; ones(1,npts)];       
    end
    
    [rows,npts] = size(x2);
    if rows~=3 & rows~=4
        error('x2 must have 3 or 4 rows');
    end
    
    if rows == 3    % Pad data with homogeneous scale factor of 1
        x2 = [x2; ones(1,npts)];        
    end
    
    [x1, T1] = normalise2dpts(x1);
    [x2, T2] = normalise3dpts(x2);

    s = 6;
    
    fittingfn = @projmatrix;
    distfn    = @reprojectiondist;
    degenfn   = @isdegenerate;
    maxDataTrials = 100;
    maxTrials = 2000;
    % x1 and x2 are 'stacked' to create a 6xN array for ransac
    [P, inliers] = ransac([x1; x2], fittingfn, distfn, degenfn, s, t, feedback, maxDataTrials, maxTrials);

    % Now do a final least squares fit on the data points considered to
    % be inliers.
    P = projmatrix(x1(:,inliers), x2(:,inliers));
    
    % Denormalise
    P = inv(T1)*P*T2;
    
    % make sure the projection matrix fits together with the projection
    % matrices computed with the essential matrix
    P = ([P./norm(P(1:3,1:3)); 0 0 0 1]);
    
%--------------------------------------------------------------------------

function [bestInliers, bestP] = reprojectiondist(P, x, t);
    
    x1 = x(1:3,:);    % Extract x1 and x2 from x
    x2 = x(4:7,:);
    
    
    if iscell(P)  % We have several solutions each of which must be tested
		  
        nP = length(P);   % Number of solutions to test
        bestP = P{1};     % Initial allocation of best solution
        ninliers = 0;     % Number of inliers

        for k = 1:nP
            proj = zeros(3,length(x1));
            for n = 1:length(x1)
                proj(:,n) = P{k}*x2(:,n);
                proj(1:3,n) = proj(1:3,n)./proj(3,n);
            end
            error = sqrt(sum((x1(1:2,:) - proj(1:2,:)).^2,1));

            inliers = find(abs(error) < t);     % Indices of inlying points

            if length(inliers) > ninliers   % Record best solution
            ninliers = length(inliers);
            bestP = P{k};
            bestInliers = inliers;
            end
        end
    
    else     % We just have one solution
        
        proj = zeros(3,length(x1));
        for n = 1:length(x1)
            proj(:,n) = P*x2(:,n);
            proj(1:3,n) = proj(1:3,n)./proj(3,n);
        end
        error = sqrt(sum((x1(1:2,:) - proj(1:2,:)).^2,1));

        bestInliers = find(abs(error) < t);     % Indices of inlying points
        bestP = P;                          % Copy F directly to bestF
        
    end

%----------------------------------------------------------------------
% (Degenerate!) function to determine if a set of matched points will result
% in a degeneracy in the calculation of a projection matrix as needed by
% RANSAC.  This function assumes this cannot happen...
     
function r = isdegenerate(x)
    r = 0;    
    
