% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    
    distances = ssd(descr1, descr2);
    
    num_descr1 = size(descr1, 2);
    num_descr2 = size(descr2, 2);
    
    matches = [];
    
    if strcmp(matching, 'one-way')
        for i = 1 : num_descr1
            min_val = min(distances(i,:));
            [x_min, y_min] = find(distances == min_val);
            matches = [matches; x_min y_min];
        end

        
        
    elseif strcmp(matching, 'mutual')
        for i = 1 : num_descr1
            min_val = min(distances(i,:));
            [x_min, y_min] = find(distances == min_val);
            
            for j = 1 : num_descr2
                min_val_mut = min(distances(:,j));
                [x_min_m, y_min_m] = find(distances == min_val_mut);
                
                if [x_min, y_min] == [x_min_m, y_min_m]
                    matches = [matches; x_min y_min];
                end  
            end
        end
           
        
        
    elseif strcmp(matching, 'ratio')
        for i = 1 : num_descr1
            min_two = mink(distances(i,:),2);
            
            min_val = min_two(1,1);
            [x_min, y_min] = find(distances == min_val);
            
            if (min_two(1,1)/min_two(1,2)) < 0.5
                matches = [matches; x_min y_min];
            end
        end
          
        
    else
        error('Unknown matching type.');
    end
    
matches = matches';

end

function distances = ssd(descr1, descr2)
    distances = pdist2(descr1',descr2').^2;
end