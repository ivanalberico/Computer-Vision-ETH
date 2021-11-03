function [nxs, T] = normalizePoints2d(x1s)
    
    c = mean(x1s(1:2, :),2);
    
    d = (x1s(1:2, :) - repmat(c, [1, size(x1s, 2)]));
    d = 1/mean(sqrt(sum(d.*d, 1)));
           
    T = [d,         0,      -d*c(1);
         0,         d,      -d*c(2);
         0,         0,          1];

    nxs = T*x1s;
   
end