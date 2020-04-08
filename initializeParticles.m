function particles = initializeParticles(num_particles, map)
    % weight of each particle must be the same
    weight = 1/num_particles;

    particles = zeros(num_particles, 4);

    particles(:,4) = weight;

    % -1 one is considered to not be a valid location
    valid_indices = find(map+1==1);

    [row, col] = ind2sub(size(map), valid_indices);

    row = row(row >= 350 & row <= 500);
    col = col(col >= 350 & col <= 450);

    for i = 1:num_particles
        rand_idx = randi(size(row)(1));
        particles(i,1) = row(rand_idx) * 10;
        particles(i,2) = col(rand_idx) * 10;
    end
end