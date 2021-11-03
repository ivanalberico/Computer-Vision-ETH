function particles = propagate(particles, sizeFrame, params)

num_particles = params.num_particles;
state_length = size(particles,2);

height_frame = sizeFrame(1);
width_frame = sizeFrame(2);
dt = 1;

sigma_p = params.sigma_position;
sigma_v = params.sigma_velocity;

particles = particles';



if params.model == 0          % no-motion model
    
    A = [1  0  ;
         0  1] ;
     
    noise = [sigma_p  sigma_p];
    
end


if params.model == 1          % constant velocity motion model
    
    A = [1 0 dt 0;
         0 1 0  dt;
         0 0 1  0;
         0 0 0  1];
     
    noise = [sigma_p  sigma_p  sigma_v  sigma_v];
    
end


for i=1:num_particles
    
    w = noise .* randn(1, state_length);
    particles(:,i) = A*particles(:,i) + w';
    
    
    center_particle_x = particles(1,i);
    center_particle_y = particles(2,i);
    
    if center_particle_x > width_frame
        particles(1,i) = width_frame;
    elseif center_particle_x < 1
        particles(1,i) = 1;
    end
    
    if center_particle_y > height_frame
        particles(2,i) = height_frame;
    elseif center_particle_y < 1
        particles(2,i) = 1;
    end
       
end

 
particles = particles';


end



