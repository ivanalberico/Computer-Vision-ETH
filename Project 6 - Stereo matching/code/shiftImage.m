function out = shiftImage( im, dx )
% Shifts image horizontally by dx.

out = zeros(size(im),class(im));
if dx<0
    out(:,1:end+dx,:) = im(:,-dx+1:end,:);
else
    out(:,dx+1:end,:) = im(:,1:end-dx,:);
end
