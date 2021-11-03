function err = sqr_error(k,b,pts)
% Calculate the square error of the fit
    n = [k -1]; 
    n = n/norm(n);
    pt1 = [0;b];
    err = sqrt(sum((n*(pts-pt1*ones(1,size(pts,2)))).^2));
end