function particles_w = observe(particles, frame, H, W, hist_bin, hist_target, sigma_observe)


num_particles = size(particles, 1);
particles_w = zeros(size(particles,1),1);


xMin = particles(:,1) - W/2;  xMax = particles(:,1) + W/2;
yMin = particles(:,2) - H/2;  yMax = particles(:,2) + H/2;


for i=1:num_particles
    
    hist_i = color_histogram(xMin(i),yMin(i),xMax(i),yMax(i),frame,hist_bin);
    
    chi_dist = chi2_cost(hist_target, hist_i);

    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe) * exp(-0.5*chi_dist^2/(sigma_observe^2));
    
end

particles_w = particles_w/sum(particles_w);


end

