%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition


% TODO Compute R, K with QR decomposition such M=K*R 

M = P(1:3,1:3);

M_inv = inv(M);
[R_inv, K_inv] = qr(M_inv);

R = inv(R_inv);
K = inv(K_inv);



% TODO Compute camera center C=(cx,cy,cz) such P*C=0 

[U,S,V] = svd(P);

C = V(:,end);
C = C/C(end);

C = C(1:3);


% % TODO normalize K such K(3,3)=1

K = K./K(3,3);


% TODO Adjust matrices R and Q so that the diagonal elements of K (= intrinsic matrix) are non-negative values and R (= rotation matrix = orthogonal) has det(R)=1

for i = 1 : 3
    if K(i,i) < 0
        K(:,i) = -K(:,i);
        R(i,:) = -R(i,:);
    end
end


if det(R) == -1
    R = -R;
end



% TODO Compute translation t=-R*C

t = -R*C;



end