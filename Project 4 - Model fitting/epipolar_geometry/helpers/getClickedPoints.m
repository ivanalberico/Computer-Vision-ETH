function [img1Points, img2Points] = getClickedPoints(img1, img2)

notDone = 1;
img1Points = [];
img2Points = [];

% Show all images
fig_handler{1} = figure; imshow(img1);
fig_handler{2} = figure; imshow(img2);


currFig = 1;

% Get corresponding points
while(notDone)

  disp('Click image coordinates: [press other mouse button when done]');

  figure(fig_handler{currFig}); hold on;

  % Get new input
  [x, y, button] = ginput(1);

  switch(button)
    case {1}

        if (currFig == 1)
            plot(x,y,'*r');
            img1Points = [img1Points, [x y 1]'];
            currFig = 2;
        else
            plot(x,y,'*r');
            img2Points = [img2Points, [x y 1]'];
            currFig = 1;
        end
    case {2,3}
        disp('Finished clicking...');
        notDone = 0;
    otherwise
        disp('no influence');
  end
end

end
