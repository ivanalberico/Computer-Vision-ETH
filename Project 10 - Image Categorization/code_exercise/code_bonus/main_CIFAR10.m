dogs_airplanes_classification = true;
dogs_cats_classification = ~ dogs_airplanes_classification;


nn_results = [];
bay_results = [];


if dogs_airplanes_classification
    
    for i=1:10
        %training
        disp('creating codebook');
        sizeCodebook = 30;
        vCenters = create_codebook2('../data(bonus)/dogs-training', '../data(bonus)/airplanes-training', sizeCodebook);

        disp('processing dogs training images');
        vBoWPos = create_bow_histograms2('../data(bonus)/dogs-training',vCenters);
        disp('processing airplanes training images');
        vBoWNeg = create_bow_histograms2('../data(bonus)/airplanes-training',vCenters);


        disp('processing dogs testing images');
        vBoWPos_test = create_bow_histograms2('../data(bonus)/dogs-testing',vCenters);
        disp('processing airplanes testing images');
        vBoWNeg_test = create_bow_histograms2('../data(bonus)/airplanes-testing',vCenters);

        nrPos = size(vBoWPos_test,1);
        nrNeg = size(vBoWNeg_test,1);

        test_histograms = [vBoWPos_test;vBoWNeg_test];
        labels = [ones(nrPos,1);zeros(nrNeg,1)];

        disp('______________________________________')
        disp('Nearest Neighbor classifier')
        accuracy_nn = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
        nn_results = [nn_results; accuracy_nn];
        disp('______________________________________')

        disp('Bayesian classifier')
        accuracy_bay = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
        bay_results = [bay_results; accuracy_bay];
        disp('______________________________________')
    end

else
    
    for i=1:10
        %training
        disp('creating codebook');
        sizeCodebook = 30;
        vCenters = create_codebook2('../data(bonus)/dogs-training', '../data(bonus)/cats-training', sizeCodebook);

        disp('processing dogs training images');
        vBoWPos = create_bow_histograms2('../data(bonus)/dogs-training',vCenters);
        disp('processing cats training images');
        vBoWNeg = create_bow_histograms2('../data(bonus)/cats-training',vCenters);


        disp('processing dogs testing images');
        vBoWPos_test = create_bow_histograms2('../data(bonus)/dogs-testing',vCenters);
        disp('processing cats testing images');
        vBoWNeg_test = create_bow_histograms2('../data(bonus)/cats-testing',vCenters);

        nrPos = size(vBoWPos_test,1);
        nrNeg = size(vBoWNeg_test,1);

        test_histograms = [vBoWPos_test;vBoWNeg_test];
        labels = [ones(nrPos,1);zeros(nrNeg,1)];

        disp('______________________________________')
        disp('Nearest Neighbor classifier')
        accuracy_nn = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
        nn_results = [nn_results; accuracy_nn];
        disp('______________________________________')

        disp('Bayesian classifier')
        accuracy_bay = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
        bay_results = [bay_results; accuracy_bay];
        disp('______________________________________')
    end
    
end


mean_nn = mean(nn_results)
mean_bay = mean(bay_results)
