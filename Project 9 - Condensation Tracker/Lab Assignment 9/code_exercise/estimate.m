function meanState = estimate(particles,particles_w)

state_length = size(particles,2);
particles_w = repmat(particles_w, 1, state_length);

meanState = sum(particles .* particles_w);

end

