clear;
clc;
LASER_TIME_IDX = 187;
ODOMETRY_TIME_IDX = 4;
DELTA_T = 0.01;
NUM_PARTICLES = 1000;

ALPHA_1 = 0.0003;
ALPHA_2 = 0.0001;
ALPHA_3 = 0.006;
ALPHA_4 = 1;

Zmax = 8183;

a_short = 0.15;
a_hit = 0.1;
a_max = 0.01;
a_rand = 0.74;

sigma = 20;
lambda = 0.003;

curr_laser_data_idx = 1;
curr_odometry_data_idx = 1;

map=dlmread("OccupancyMapNew.dat");

particles = initializeParticles(NUM_PARTICLES, map);

imshow(map)

hold on
axis on

handle=pltparticles(particles);

[laser, odometry, end_time] = extract_data('robotdata1.log');

for t=0:DELTA_T:end_time
    if isnewlaser(curr_laser_data_idx, laser, LASER_TIME_IDX, t, DELTA_T)
        if curr_laser_data_idx == 1
            prev_odom = laser(curr_laser_data_idx, [1,2,3]);
        else
            curr_odom = odometry(curr_laser_data_idx, [1,2,3]);
            u = getodominfo(curr_odom, prev_odom);

            particles = motionmodel(u, particles, ALPHA_1, ALPHA_2, ALPHA_3, ALPHA_4);

            for i = 1:NUM_PARTICLES
                if particles(i,3) > pi
                    while(particles(i,3) > pi)
                        particles(i,3) = particles(i,3) - 2 * pi;
                    end
                elseif particles(i,3) < -pi
                    while(particles(i,3) < -pi)
                        particles(i,3) = particles(i,3) + 2 * pi;
                    end
                end
                particles(i,4) = sensorModel(particles(i,:), Zmax, a_short, a_hit, a_max, a_rand, laser, map, curr_laser_data_idx, sigma, lambda);
            end

            delete(handle)
            handle=pltparticles(particles);

            drawnow();

            curr_laser_data_idx= curr_laser_data_idx + 1;

            prev_odom = curr_odom;

            particles = updateBelief(particles);
        end

        curr_laser_data_idx = curr_laser_data_idx + 1;
    end

    if isnewodom(curr_odometry_data_idx, odometry, ODOMETRY_TIME_IDX, t, DELTA_T)
        if curr_odometry_data_idx == 1
            prev_odom = odometry(curr_odometry_data_idx, [1,2,3]);
        else
            curr_odom = odometry(curr_odometry_data_idx, [1,2,3]);
            u = getodominfo(curr_odom, prev_odom);

            particles = motionmodel(u, particles, ALPHA_1, ALPHA_2, ALPHA_3, ALPHA_4);

            delete(handle)
            handle=pltparticles(particles);

            drawnow();

            prev_odom = curr_odom;

            particles = updateBelief(particles);
        end

        curr_odometry_data_idx = curr_odometry_data_idx + 1;
    end
end