function newParticles = updateBelief(particles)
    numParticles = size(particles,1);
    totalWeight = sum(particles,1)(4);
    newParticles = particles;

    if totalWeight ~= 0
        particles(:,4) = numParticles * (particles(:,4)/totalWeight);


        for i = 1:numParticles
            r = numParticles * rand();
            sumOfWeights = 0;
            idx = 1;

            while sumOfWeights < r
                sumOfWeights = sumOfWeights + particles(idx, 4);
                idx = idx + 1;
            end

            if idx > numParticles
                newParticles(i,:) = particles(numParticles, :);
            else    
                newParticles(i,:) = particles(idx, :);
            end
        end
    end
end