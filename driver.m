clear

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

current_state = [398, 394, 0];

for t = 0:DELTA_T:end_time
    if curr_laser_data_idx <= size(laser,1) && laser(curr_laser_data_idx,LASER_TIME_IDX) >= t - DELTA_T && laser(curr_laser_data_idx,LASER_TIME_IDX) <= t
        if exist('curr_odometry_data', 'var') == 1
            previous_odometry_data = curr_odometry_data;
            curr_odometry_data = [laser(curr_laser_data_idx, 1), laser(curr_laser_data_idx, 2), laser(curr_laser_data_idx, 3)];

            delta_translation = sqrt((curr_odometry_data(1) - previous_odometry_data(1))^2 + (curr_odometry_data(2) - previous_odometry_data(2))^2);
            delta_rot1 = atan2(curr_odometry_data(1) - previous_odometry_data(1), curr_odometry_data(2) - previous_odometry_data(2)) - previous_odometry_data(3);
            delta_rot2 = curr_odometry_data(3) - previous_odometry_data(3) - delta_rot1;

            u = [delta_rot1, delta_rot2, delta_translation];

            current_state = motionModel(u, current_state);

            current_state(4) = sensorModel(current_state, Zmax, a_short, a_hit, a_max, a_rand, laser, 'OccupancyMapNew.dat', curr_laser_data_idx, sigma, lambda);

            curr_laser_data_idx += 1;
        else
            curr_odometry_data = [odometry(curr_odometry_data_idx, 1), odometry(curr_odometry_data_idx, 2), odometry(curr_odometry_data_idx, 3)];
        end

        %% PERFORM SENSOR MODEL UPDATE
        curr_laser_data_idx += 1;
    end

    if curr_odometry_data_idx <= size(odometry,1) && odometry(curr_odometry_data_idx,ODOMETRY_TIME_IDX) >= t - DELTA_T && odometry(curr_odometry_data_idx,ODOMETRY_TIME_IDX) <= t
        if exist('curr_odometry_data', 'var') == 1
            previous_odometry_data = curr_odometry_data;
            curr_odometry_data = [odometry(curr_odometry_data_idx, 1), odometry(curr_odometry_data_idx, 2), odometry(curr_odometry_data_idx, 3)];

            delta_translation = sqrt((curr_odometry_data(1) - previous_odometry_data(1))^2 + (curr_odometry_data(2) - previous_odometry_data(2))^2);
            delta_rot1 = atan2(curr_odometry_data(1) - previous_odometry_data(1), curr_odometry_data(2) - previous_odometry_data(2)) - previous_odometry_data(3);
            delta_rot2 = curr_odometry_data(3) - previous_odometry_data(3) - delta_rot1;

            u = [delta_rot1, delta_rot2, delta_translation];

            current_state = motionModel(u, current_state);

            % disp(current_state)
        else
            curr_odometry_data = [odometry(curr_odometry_data_idx, 1), odometry(curr_odometry_data_idx, 2), odometry(curr_odometry_data_idx, 3)];
            current_state = curr_odometry_data;
        end

        curr_odometry_data_idx += 1;
    end

    %% UPDATE BELIEF
end