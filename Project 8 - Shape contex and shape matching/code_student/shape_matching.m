function matchingCost = shape_matching(X,Y,display_flag)

%computes the matching cost between template contour points X and target contour points Y  

%%%
%%%Define flags and parameters:
%%%

if nargin < 3
    display_flag = 0;
end

nbSamples = size(X,1);
nbBins_theta = 12;      % 12
nbBins_r = 5;           % 5
smallest_r = 1/8;       %length of the smallest radius (assuming normalized distances)
biggest_r = 3;          %length of the biggest radius (assuming normalized distances)
maxIterations = 6;


if display_flag
   subplot(1,2,1)
   plot(X(:,1),X(:,2),'b+')
   axis('ij'), title('X');
   subplot(1,2,2)
   plot(Y(:,1),Y(:,2),'ro')
   axis('ij'), title('Y');
   drawnow	
end

if display_flag
   [x,y] = meshgrid(linspace(min(X(:,1))-10,max(X(:,1))+10,36),...
                    linspace(min(X(:,2))-10,max(X(:,2))+10,36));
   x = x(:);
   y = y(:);
   M = length(x);
end

%%%
%%% compute correspondences
%%%
currentX = X;
currentIteration = 1;


while currentIteration <= maxIterations

   disp(['iter=' int2str(currentIteration)]);

   %write the sc_compute.m function
   disp('computing shape contexts for (deformed) model...')
   ShapeDescriptors1 = sc_compute(currentX', nbBins_theta, nbBins_r, smallest_r, biggest_r);
   disp('done.')
      
   disp('computing shape contexts for target...')
   ShapeDescriptors2 = sc_compute(Y', nbBins_theta, nbBins_r, smallest_r, biggest_r);
   disp('done.')

   %set lambda here      
   mean_dist = mean(mean(sqrt(dist2(Y,Y))));  
   lambda = mean_dist^2;  
   
   %write the chi2_cost.m function
   costMatrixC = chi2_cost(ShapeDescriptors1,ShapeDescriptors2);   
   corespondencesIndex = hungarian(costMatrixC);   
       
   Xwarped = currentX(corespondencesIndex,:);   
   Xunwarped = X(corespondencesIndex,:);         

   if display_flag       
      figure(2)
      plot(Xwarped(:,1),Xwarped(:,2),'b+',Y(:,1),Y(:,2),'ro')
      hold on
      plot([Xwarped(:,1) Y(:,1)]',[Xwarped(:,2) Y(:,2)]','k-');      
      hold off
      axis('ij')
      title(' correspondences (warped X)')
      drawnow	
   end
   
   if display_flag
      % show the correspondences between the untransformed images
      figure(3)
      plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro')      
      hold on
      plot([Xunwarped(:,1) Y(:,1)]',[Xunwarped(:,2) Y(:,2)]','k-')
      hold off
      axis('ij')
      title(' correspondences (unwarped X)')
      drawnow	
   end
  
   
   [w_x,w_y,E] = tps_model(Xunwarped,Y,lambda);
   
   
   % warp each coordinate   
   fx_aff = w_x(nbSamples+1:nbSamples+3)'*[ones(1,nbSamples); X'];
   d2 = max(dist2(Xunwarped,X),0);  
   U = d2.*log(d2+eps);
   fx_wrp = w_x(1:nbSamples)'*U;
   fx = fx_aff+fx_wrp;   
   
   fy_aff = w_y(nbSamples+1:nbSamples+3)'*[ones(1,nbSamples); X'];
   fy_wrp = w_y(1:nbSamples)'*U;
   fy = fy_aff+fy_wrp;

   % update currentX for the next iteration
   currentX = [fx; fy]';   

   if display_flag
      figure(4)
      plot(currentX(:,1),currentX(:,2),'b+',Y(:,1),Y(:,2),'ro');
      axis('ij')
      title(['iteration=' int2str(currentIteration) ',  I_f=' num2str(E) ])
      % show warped coordinate grid
      fx_aff=w_x(nbSamples+1:nbSamples+3)'*[ones(1,M); x'; y'];
      d2 = dist2(Xunwarped,[x y]);
      fx_wrp = w_x(1:nbSamples)'*(d2.*log(d2+eps));
      fx = fx_aff+fx_wrp;
      fy_aff = w_y(nbSamples+1:nbSamples+3)'*[ones(1,M); x'; y'];
      fy_wrp = w_y(1:nbSamples)'*(d2.*log(d2+eps));
      fy = fy_aff+fy_wrp;
      hold on
      plot(fx,fy,'k.','markersize',1)
      hold off
      drawnow
   end         

   %update currentIteration
   currentIteration = currentIteration + 1;
   
end

matchingCost = E;