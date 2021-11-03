function [ K, R, C ] = decompose(P)
%decompose P into K, R and t

%compute camera center t
[u s v] = svd(P);
C = v(:,4)/v(4,4);

[Rinv, Kinv] = qr(inv(P(:,1:3)));
K = inv(Kinv);
K = K/K(3,3);
R = inv(Rinv);
C = C(1:3);

if K(1,1) < 0
    K = K * [-1 0 0;0 1 0;0 0 1];
    R = [-1 0 0;0 1 0;0 0 1] * R;
end
if K(2,2) < 0
    K = K * [1 0 0;0 -1 0;0 0 1];
    R = [1 0 0;0 -1 0;0 0 1] * R;
end