function [map peak] = meanshiftSeg(img)


% DENSITY FUNCTION X (L*a*b)

img = double(img);

heigth_img = size(img, 1);
width_img = size(img, 2);
L = heigth_img * width_img;

X_L = reshape(img(:,:,1), L, 1);
X_a = reshape(img(:,:,2), L, 1);
X_b = reshape(img(:,:,3), L, 1);

X = [X_L, X_a, X_b];


% MEAN SHIFT ALGORITHM

map = zeros([heigth_img, width_img]);

peak = [];
num_peaks = 0;
radius = 15;

for i=1:L

    peak_i = find_peak(X, X(i,:), radius);
    
    % For the first pixel we do not have to perform any check on the
    % distance from other peaks (since there are not any yet). Hence, we
    % just add this new peak and id in the list.
    if i==1
        peak = [peak; peak_i];
        num_peaks = 1;
        map(i) = 1;
        
    % From the second to the last pixel, once we get the peak, we have to
    % check whether its distance to the other peaks is bigger or smaller
    % than a certain threshold r/2, to see whether they belong to the same
    % cluster or not.
    else
        peak_matrix_i = repmat(peak_i, [size(peak,1), 1]);
        distances_peaks = sqrt(sum((peak - peak_matrix_i).^2, 2));
        
        index = find(distances_peaks < radius/2);
        
        num_peaks_cluster = size(index, 1);
        
        % If the peak related to the specific pixel has a distance larger
        % than r/2 with respect to the previous peaks, it means that it 
        % belongs to a new cluster, so we add a new peak and id in the list.
        
        if num_peaks_cluster == 0
            peak = [peak; peak_i];
            num_peaks = num_peaks + 1;
            map(i) = num_peaks;
            
        % If the peak has a distance smaller than r/2 with respect to only 
        % another peak, it means they belong to the same cluster and so they
        % have the same id (we do not add a new peak)
        
        elseif num_peaks_cluster == 1
            map(i) = index;
            
        
        % If we have that a peak has a distance smaller than r/2 with more 
        % than one of the previous peaks, we merge it to the closest peak 
        % (the one with the smallest distance).
        
        elseif num_peaks_cluster > 1
            
            distances = distances_peaks(index);
            [~, min_index] = min(distances);
            map(i) = index(min_index);
            
        end
    end
end

str = [num2str(num_peaks), ' clusters have been detected with a radius of ', num2str(radius)];
disp(str);


end