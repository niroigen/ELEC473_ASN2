function plt = pltparticles(particles)
    plt=plot(particles(:,2)/10,particles(:,1)/10,'linestyle','none','marker','o', 'MarkerFaceColor','b', 'MarkerEdgeColor','r');
end