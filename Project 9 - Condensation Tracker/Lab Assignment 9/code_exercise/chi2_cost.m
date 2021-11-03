function dist = chi2_cost(hist1, hist2)

dist = sum((hist1(:) - hist2(:)).^2 ./ (hist1(:) + hist2(:) + eps));