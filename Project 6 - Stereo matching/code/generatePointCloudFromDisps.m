function [coords, coords2] = generatePointCloudFromDisps(disps,H1,H2,P1,P2)

coords = zeros([size(disps) 3]);

for y=1:size(disps,1)
    for x=1:size(disps,2)
        pt1 = [x;y;1];
        pt2 = [x-disps(y,x);y;1];
        pt1 = H1^-1*pt1;
        pt1 = pt1/pt1(3);
        pt2 = H2^-1*pt2;
        pt2 = pt2/pt2(3);
        X = linTriang(pt1,pt2,P1,P2);
        coords(y,x,1:3) = X;
    end
end

coords2 = zeros([size(disps) 3]);
