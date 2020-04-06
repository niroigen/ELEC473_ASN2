clear;
clc;
LASER_TIME_IDX = 187;
ODOMETRY_TIME_IDX = 4;
DELTA_T = 0.01;

[laser, odometry, end_time] = extract_data('robotdata1.log');

% Changes depending on the log file

Zmax = 8183;


a_short = 0.15;
a_hit = 0.1;
a_max = 0.01;
a_rand = 0.74;

sigma = 20;
lambda = 0.003;

curr_laser_data_idx = 1;
curr_odometry_data_idx = 1;

NUM_PARTICLES = 500;

map=dlmread("OccupancyMapNew.dat");

particles = zeros(NUM_PARTICLES, 4);

for i = 1:NUM_PARTICLES
    valid = false;

    while ~valid
        x = round(350 + (500-350)*rand());
        y = round(350 + (425-350)*rand());

        valid = map(y,x) < 0.25;
    end 
    particles(i,1) = x;
    particles(i,2) = y;
end

imshow(map)

hold on
axis on

for t = 0:DELTA_T:end_time
    if curr_laser_data_idx <= size(laser,1) && laser(curr_laser_data_idx,LASER_TIME_IDX) >= t - DELTA_T && laser(curr_laser_data_idx,LASER_TIME_IDX) <= t
        if exist('curr_odometry_data', 'var') == 1
            previous_odometry_data = curr_odometry_data;
            curr_odometry_data = [laser(curr_laser_data_idx, 1), laser(curr_laser_data_idx, 2), laser(curr_laser_data_idx, 3)];

            delta_translation = sqrt((curr_odometry_data(1) - previous_odometry_data(1))^2 + (curr_odometry_data(2) - previous_odometry_data(2))^2);
            delta_rot1 = atan2(curr_odometry_data(1) - previous_odometry_data(1), curr_odometry_data(2) - previous_odometry_data(2)) - previous_odometry_data(3);
            delta_rot2 = curr_odometry_data(3) - previous_odometry_data(3) - delta_rot1;

            u = [delta_rot1, delta_rot2, delta_translation];

            for i = 1:NUM_PARTICLES
                particles(i,[1,2,3]) = motionModel(u, particles(i,[1,2,3]));
                particles(i,4) = sensorModel(particles(i,:), Zmax, a_short, a_hit, a_max, a_rand, laser, map, curr_laser_data_idx, sigma, lambda);
            end

            curr_laser_data_idx= curr_laser_data_idx + 1;
        else
            curr_odometry_data = [odometry(curr_odometry_data_idx, 1), odometry(curr_odometry_data_idx, 2), odometry(curr_odometry_data_idx, 3)];
        end

        %% PERFORM SENSOR MODEL UPDATE
        curr_laser_data_idx = curr_laser_data_idx + 1;

        particles = updateBelief(particles);

        if exist('plots', 'var') == 1
            delete(plots);
        end
    
        plots = plot(particles(:,1),particles(:,2),'rs');
        
        drawnow ()
    end

    if curr_odometry_data_idx <= size(odometry,1) && odometry(curr_odometry_data_idx,ODOMETRY_TIME_IDX) >= t - DELTA_T && odometry(curr_odometry_data_idx,ODOMETRY_TIME_IDX) <= t
        if exist('curr_odometry_data', 'var') == 1
            previous_odometry_data = curr_odometry_data;
            curr_odometry_data = [odometry(curr_odometry_data_idx, 1), odometry(curr_odometry_data_idx, 2), odometry(curr_odometry_data_idx, 3)];

            delta_translation = sqrt((curr_odometry_data(1) - previous_odometry_data(1))^2 + (curr_odometry_data(2) - previous_odometry_data(2))^2);
            delta_rot1 = atan2(curr_odometry_data(1) - previous_odometry_data(1), curr_odometry_data(2) - previous_odometry_data(2)) - previous_odometry_data(3);
            delta_rot2 = curr_odometry_data(3) - previous_odometry_data(3) - delta_rot1;

            u = [delta_rot1, delta_rot2, delta_translation];

            for i = 1:NUM_PARTICLES
                particles(i,[1,2,3]) = motionModel(u, particles(i,[1,2,3]));
            end
        else
            curr_odometry_data = [odometry(curr_odometry_data_idx, 1), odometry(curr_odometry_data_idx, 2), odometry(curr_odometry_data_idx, 3)];
        end

        curr_odometry_data_idx = curr_odometry_data_idx+ 1;

        if exist('plots', 'var') == 1
            delete(plots);
        end
    
        plots = plot(particles(:,1),particles(:,2),'rs');
        
        drawnow ()
    end
end