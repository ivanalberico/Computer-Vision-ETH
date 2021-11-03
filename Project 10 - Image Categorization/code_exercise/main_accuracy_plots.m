K = [10, 25, 50, 100, 150, 200, 250, 300, 400, 500, 600, 750, 850, 1000, 1500];

NN_results = [0.9616, 0.9212, 0.9313, 0.9343, 0.9111, 0.8989, ... % (200)
              0.9051, 0.8798, 0.8758, 0.8747, 0.8737, 0.8455, ...
              0.8646, 0.8646, 0.8152];
Bayes_results = [0.9293, 0.9111, 0.9051, 0.9172, 0.9253, 0.9212, ... 
                 0.9061, 0.8737, 0.8485, 0.7828, 0.7515, 0.6768, ...
                 0.6394, 0.5929, 0.5182];


plot(K, NN_results); hold on;
plot(K, Bayes_results);
legend("Nearest-neighbor", "Bayesian");
xlim([0 1000]);
ylim([0 1]);



% NN_coefficients = polyfit(K, NN_results, 5);
% 
% a_NN = NN_coefficients(1);
% b_NN = NN_coefficients(2);
% c_NN = NN_coefficients(3);
% d_NN = NN_coefficients(4);
% e_NN = NN_coefficients(5);
% f_NN = NN_coefficients(6);
% 
% Bay_coefficients = polyfit(K, Bayes_results, 5);
% 
% a_Bay = Bay_coefficients(1);
% b_Bay = Bay_coefficients(2);
% c_Bay = Bay_coefficients(3);
% d_Bay = Bay_coefficients(4);
% e_Bay = Bay_coefficients(5);
% f_Bay = Bay_coefficients(6);
% 
% 
% k = K;
% plot(k, a_NN.*k.^5 + b_NN.*k.^4 + c_NN.*k.^3 + d_NN.*k.^2 + e_NN.*k + f_NN); hold on;
% plot(k, a_Bay.*k.^5 + b_Bay.*k.^4 + c_Bay.*k.^3 + d_Bay.*k.^2 + e_Bay.*k + f_Bay);
% 
% legend("Nearest-neighbor", "Bayesian");
% ylim([0 1]);
% xlim([0 1000]);




