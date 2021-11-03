function mask = leftRightCheck(dispL,dispR,thresh)

% check if two disparity maps agree up to "thresh"

mask = ones(size(dispL));

for y=1:size(dispL,1)
    for x=1:size(dispL,2)
        x2 = x+dispL(y,x);
        if x2 < 1 || x2 > size(dispR,2)
            mask(y,x) = 0;
            continue;
        end
        xcheck = x2+dispR(y,x2);
        if abs(x-xcheck) > thresh
            mask(y,x) = 0;
        end
    end
end

end