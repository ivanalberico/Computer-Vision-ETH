function [frames, descr] = extractSIFT(img)
    img = img - min(img(:)) ;
    img = img/max(img(:)) ;

    [frames, descr] = vl_sift(single(img));
end