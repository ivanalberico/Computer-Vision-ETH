function hist = color_histogram(xMin, yMin, xMax, yMax, frame, hist_bin)


xMin = max(1, xMin);     xMax = min(xMax, size(frame,2));
yMin = max(1, yMin);     yMax = min(yMax, size(frame,1));

xMin = round(xMin);      xMax = round(xMax);
yMin = round(yMin);      yMax = round(yMax);


bounding_box_img = frame(yMin:yMax, xMin:xMax, :);

hist_R = imhist(bounding_box_img(:, :, 1), hist_bin);
hist_G = imhist(bounding_box_img(:, :, 2), hist_bin);
hist_B = imhist(bounding_box_img(:, :, 3), hist_bin);

hist = [hist_R; hist_G; hist_B];
hist = hist/sum(hist);


end

