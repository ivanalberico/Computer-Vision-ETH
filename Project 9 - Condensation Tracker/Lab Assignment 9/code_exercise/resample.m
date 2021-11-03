function [particles, particles_w] = resample(particles, particles_w)


num_particles = size(particles, 1);
state_length = size(particles, 2);


% LOW VARIANCE SAMPLING METHOD
r = rand()*(1/num_particles);
w = particles_w(1);
i = 1;

particles_resampled = zeros(num_particles, state_length);
particles_w_resampled = zeros(num_particles, 1);


for m = 1:num_particles
    U = r + (m-1)*(1/num_particles);

    while U > w
        i = i + 1;

        if i > num_particles
           i = 1; 
        end

        w = w + particles_w(i);
    end

particles_resampled(m,:) = particles(i,:);
particles_w_resampled(m) = particles_w(i);

end 


particles_w_resampled = particles_w_resampled/sum(particles_w_resampled);

particles = particles_resampled;
particles_w = particles_w_resampled;

end
