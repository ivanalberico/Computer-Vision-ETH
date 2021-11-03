function [img1Points, img2Points] = getClickedPoints(img1, img2)

notDone = 1;
img1Points = []; 
img2Points = [];

% Show both images
x_shift = size(img1, 2);
img_both = cat(2, img1, img2);

imshow(img_both), hold on
% Get corresponding points
while(notDone)
   
  disp('Click image coordinates (rigth click to finish).');   
  
  % Get new input
  [x, y, button] = ginput(1);
  if(isempty(button))
      disp('Invalid key')
  else
      switch(button)
        case {1} 
            plot(x,y,'*r');        
            if (x < x_shift)
                img1Points = [img1Points, [x y 1]'];
            else
                img2Points = [img2Points, [x-x_shift y 1]'];
            end
        case {2,3}
            disp('Finished clicking...');
            notDone = 0;      
        otherwise
            disp('no influence'); 
      end
  end
end

end