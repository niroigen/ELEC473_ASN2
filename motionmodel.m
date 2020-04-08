function particles = motionmodel(u, particles, a1, a2, a3, a4)
    del_rot1 = u(1) + irwin_hall(0, a1 * u(1)^2 + a2 * u(3)^2);
    del_rot2 = u(2) + irwin_hall(0, a1 * u(2)^2 + a2 * u(3)^2);
    del_trans = u(3) + irwin_hall(0, a3 * u(3)^2 + a4 * (u(1)^2 + u(2)^2));

    particles(:,1) = particles(:,1) + del_trans * cos(particles(:,3) + del_rot1);
    particles(:,1) = particles(:,2) + del_trans * sin(particles(:,3) + del_rot1);
    particles(:,3) = particles(:,3) + del_rot1 + del_rot2;
end