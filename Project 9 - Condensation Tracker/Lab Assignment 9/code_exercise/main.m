close all;

params = load('../data/params.mat');

params.params.draw_plots = 1;
params.params.hist_bin = 3;
params.params.alpha = 0;
params.params.sigma_observe = 0.05;
params.params.model = 1;
params.params.num_particles = 20;
params.params.sigma_position = 7;
params.params.sigma_velocity = 1;
params.params.initial_velocity = [1 -3];

parameters = params.params;

% default values: 1, 16, 0, 0.1, 0, 300, 15, 1, [1 10]
% best parameters for 'video1': 1, 3, 0.3, 0.05, 1, 300, 5, 1, [-3 -15]
% best parameters for 'video2': 1, 15, 0, 0.1, 0, 100, 5, 1, [1 0]
% best parameters for 'video3': 1, 15, 0.5, 0.1, 0, 300, 15, 1, [0 0]

% best parameters for 'myOwnVideo1': 1, 16, 0.8, 0.05, 1, 200, 10, 1, [5 -5]
% best parameters for 'myOwnVideo2': 1, 5, 0.2, 0.1, 1, 300, 5, 1, [-5 -5]
% best parameters fo 'myOwnVideo3': 1, 3, 0, 0.05, 1, 20, 7, 1, [1 -3]

videoName = 'myOwnVideo3';
condensationTracker(videoName, parameters);