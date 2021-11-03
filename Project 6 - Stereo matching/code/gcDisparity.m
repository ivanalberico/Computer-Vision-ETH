function L = gcDisparity(imgL, imgR, dispRange)

    imgL = im2single(imgL);
    imgR = im2single(imgR);

    % find data costs
    %% <<< ----------
    Dc = diffsGC(imgL, imgR, dispRange);

    k = size(Dc,3);
    Sc = ones(k) - eye(k);

    % spatial variation cost. You may tune the size and sigma of filter to
    % improve performance
    [Hc Vc] = gradient(imfilter(imgL,fspecial('gauss', 3, 5),'symmetric'));

    gch = GraphCut('open', 1000*Dc, 5*Sc, exp(-Vc*5), exp(-Hc*5));

    [gch L] = GraphCut('expand',gch);
    gch = GraphCut('close', gch);
end
