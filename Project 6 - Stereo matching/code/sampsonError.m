function error = sampsonError(F, x1s, x2s)
                                 
    Fx1s  = F*x1s;
    Ftx2s = F'*x2s;

    x2stFx1s = zeros(1,size(x1s,2));
    for n = 1:size(x1s,2)
         x2stFx1s(n) = x2s(:,n)'*F*x1s(:,n);
    end

    error = x2stFx1s.^2 ./ ...
            (Fx1s(1,:).^2 + Fx1s(2,:).^2 + Ftx2s(1,:).^2 + Ftx2s(2,:).^2);
end