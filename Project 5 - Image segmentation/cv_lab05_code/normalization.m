function [XYZn, T] = normalization(XYZ)

XYZ = [         XYZ'           ;
        ones(1, size(XYZ, 1)) ];


%first compute centroid
XYZ_centroid = mean(XYZ,2) ;

%create T transformation matrices
TXYZ_centroid =  [1 0 0 -XYZ_centroid(1)  ;
                  0 1 0 -XYZ_centroid(2)  ;
                  0 0 1 -XYZ_centroid(3)  ;
                  0 0 0         1        ];

              
total_XYZ = 0 ;
XYZ_center = TXYZ_centroid*XYZ ;

num_points = size(XYZ, 2);

for i = 1:num_points
    total_XYZ = total_XYZ + norm(XYZ_center(1:3,i)) ;
end

scale_XYZ = num_points/total_XYZ  ;

%and normalize the points according to the transformations
T = scale_XYZ * TXYZ_centroid ;
T(4,4) = 1 ;
XYZn = T * XYZ ;

XYZn = XYZn(1:3, 1:end)';

end