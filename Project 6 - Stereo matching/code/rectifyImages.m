function [imLeftR imRightR Hleft Hright maskL maskR] = rectifyImages( imLeft, imRight, inlierMatches, F )
% Inputs
%  imLeft,imRight:  color or grayscale
%  inlierMatches:  in the form [x1 y1 x2 y2; ...]
%  F:  in the form x2'*F*x1 = 0
% Outputs
%  imLeftR,imRightR:  rectified images
%  Hleft:  maps a point in imLeft to imLeftR, i.e. xR = H*x
%  Hright:  maps a point in imRight to imRightR, i.e. xR = H*x

x1 = inlierMatches(:,1:2)';
x1(3,:) = 1;
x2 = inlierMatches(:,3:4)';
x2(3,:) = 1;

T = [1 0 -size(imLeft,2)/2; 0 -1 size(imLeft,1)/2; 0 0 1];
%T = eye(3);
x1 = T*x1;
x2 = T*x2;
F = inv(T)'*F*inv(T);

cd rectification;
[imLeftR imRightR b Hleft Hright] = rectify_images(imLeft,imRight,x1,x2,F);
[maskL maskR b Hleft Hright] = rectify_images(ones(size(imLeft,1),size(imLeft,2)),ones(size(imRight,1),size(imRight,2)),x1,x2,F);
cd ..

c0 = inv(T)*[b(1) b(4) 1]';
T2 = [1 0 -c0(1); 0 1 -c0(2); 0 0 1];

Hleft = T2*inv(T)*Hleft*T;
Hright = T2*inv(T)*Hright*T;
