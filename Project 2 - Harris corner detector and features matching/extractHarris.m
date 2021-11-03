% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength

function [corners, C] = extractHarris(img, sigma, k, thresh)


% STEP 1:  Compute the image gradients Ix and Iy with conv2() function

dx = (1/2)*[1 0 -1];
dy = (1/2)*[1; 0; -1];

Ix = conv2(img, dx, 'same');
Iy = conv2(img, dy, 'same');

Ix2 = Ix .* Ix;
Iy2 = Iy .* Iy;
Ixy = Ix .* Iy;


% STEP 2: Blur the image using imgaussfilt()

g_Ix2 = imgaussfilt(Ix2, sigma);
g_Iy2 = imgaussfilt(Iy2, sigma);
g_Ixy = imgaussfilt(Ixy, sigma);

M = [g_Ix2 g_Ixy;
     g_Ixy g_Iy2];

 
% STEP 3: Compute Harris response function


% Compact matrix expression
det_M = g_Ix2 .* g_Iy2 - g_Ixy.*g_Ixy;
trace_M = g_Ix2 + g_Iy2;

C = det_M - k * (trace_M).^2;


% Alternative way 1 (Pixel-wise matrices)

[x_length, y_length] = size(img);
C_1 = zeros(x_length, y_length);

for i = 1 : x_length
    for j = 1 : y_length
 
        M = [g_Ix2(i,j), g_Ixy(i,j)
             g_Ixy(i,j), g_Iy2(i,j)];
         
        det_M = g_Ix2(i,j).*g_Iy2(i,j) - g_Ixy(i,j).*g_Ixy(i,j);
        trace_M = g_Ix2(i,j) + g_Iy2(i,j);
        
        C_1(i,j) = det_M - k * (trace_M).^2;
    end
end



% Alternative way 2 (eigenvalues)

C_2 = zeros(x_length, y_length);
for i = 1 : x_length
    for j = 1 : y_length
        
        M = [g_Ix2(i,j), g_Ixy(i,j)
             g_Ixy(i,j), g_Iy2(i,j)];
         
        eigen_M = eig(M);
        
        det_M = eigen_M(1)*eigen_M(2);
        trace_M = eigen_M(1)+eigen_M(2);
        
        C_2(i,j) = det_M - k * (trace_M).^2;
    end
end







% STEP 4: Detection criteria

C_pad = zeros(x_length + 2, y_length + 2);
C_pad(2:(end-1),2:(end-1)) = C;

corners = [];

for i= 2 : (x_length - 1)
    for j= 2 : (y_length - 1)
        
        C_ij = C_pad(i,j);
         
        if C_ij > thresh 
            
            W = C_pad(i-1:i+1, j-1:j+1); 
            max_mask = imregionalmax(W);
            max_matrix = W .* max_mask; 
            
            if max_matrix(2,2) ~= 0
                corners = [corners; i j];
            end
        end
    end
end


corners = corners';

 
end