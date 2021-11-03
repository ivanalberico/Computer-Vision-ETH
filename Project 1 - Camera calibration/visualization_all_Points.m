function visualization_all_Points(P,xy) 

IMG_NAME = 'images/image001.jpg';
img = imread(IMG_NAME);

imshow(img); hold on ;

num_x_squares = 7; 
num_y_squares = 6; 
num_z_squares = 9;

%xz plane
for i = 0 : num_x_squares
    for z = 0 : num_z_squares
        X = i*0.027;
        Y = 0;
        Z= z*0.027; 
        
        XYZ = [X Y Z 1]';
        xy_projected = P * XYZ;
        xy_projected = xy_projected/xy_projected(3);
        xy_projected = xy_projected(1:2)';
        plot(xy_projected(1), xy_projected(2), 'ro', 'MarkerSize', 6, 'linewidth', 2.3) ; hold on;
    end
end


%yz plane
for j = 0 : num_y_squares
    for z = 0 : num_z_squares
        X = 0;
        Y = j * 0.027;
        Z= z * 0.027 ; 
        
        XYZ = [X Y Z 1]';
        xy_projected = P * XYZ;
        xy_projected = xy_projected/xy_projected(3);
        xy_projected = xy_projected(1:2)';
        plot(xy_projected(1), xy_projected(2), 'ro', 'MarkerSize', 6, 'linewidth', 2.3);
        hold on;
    end  
end


% reference points
numPoints = size(xy,2);

for i = 1 : numPoints
    plot(xy(1,i), xy(2,i) , 'g+', 'MarkerSize', 13, 'linewidth', 2);
    hold on;
end

end