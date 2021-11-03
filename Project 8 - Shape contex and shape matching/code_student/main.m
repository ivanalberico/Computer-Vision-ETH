close all;
clear all;



matching_type = 'heart';      % choose between 'heart', 'watch' and 'fork'

if strcmp(matching_type, 'heart')
    X_index = 1;
    Y_index = 2;

elseif strcmp(matching_type, 'fork')
    X_index = 9;
    Y_index = 8;

elseif strcmp(matching_type, 'watch')
    X_index = 11;
    Y_index = 15;
end

% Loading the dataset and the chosen images (template and target)
dataset = load('dataset.mat');

X = dataset.objects(X_index).X;
Y = dataset.objects(Y_index).X;

X_img = dataset.objects(X_index).img;
Y_img = dataset.objects(Y_index).img;

% Showing the selected images

subplot(1,2,1)
imshow(X_img);
title('X_img (template)')

subplot(1,2,2)
imshow(Y_img);
title('Y_img (target)')


% Sampling from the two images
nsamp = 300;

X = get_samples(X, nsamp);
Y = get_samples(Y, nsamp);


display_flag = 1;
matchingCost = shape_matching(X, Y, display_flag);

