function P = decomposeE(E, x1s, x2s)
    
    W = [0 -1 0;
         1  0 0;
         0  0 1];
     
    [U, S, V] = svd(E);
    
    % extract translation
    t = U*[0,0,1]';
        
    % extract rotation
    R1 = U*W*V';
    R2 = U*W'*V';
    
    if (det(R1) < 0 )
        R1 = -R1;
    end
    
    if (det(R2) < 0 )
        R2 = -R2;
    end
    
    P1 = eye(4);
    
    % four possible solutions
    Ps = {[R1, t; 0, 0, 0, 1], [R1, -t; 0, 0, 0, 1], ...
          [R2, t; 0, 0, 0, 1], [R2, -t; 0, 0, 0, 1]};

    %showCameras({P1, Ps{:}}, 20);
    P = [];
    c(1:4) = 0;
    for k = 1:size(Ps,2)
        X = linearTriangulation(P1, x1s, Ps{k}, x2s);
        
        p1X = P1*X;
        p2X = Ps{k}*X;

        count = length(find(p1X(3,:) >= 0 & p2X(3,:) >= 0));
        c(k) = count;               
    end
    [m,i] = max(c);
    P = Ps{i};
end