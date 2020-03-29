clear

LASER_TIME_IDX = 187;
ODOMETRY_TIME_IDX = 4;
DELTA_T = 0.01;

[laser, odometry, end_time] = extract_data('robotdata1.log');

% Changes depending on the log file

curr_laser_data_idx = 1;
curr_odometry_data_idx = 1;

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

            for i = 8:187
                z_exp = calculateZEXP(current_state, 'OccupancyMapNew.dat', laser(curr_laser_data_idx, i) * pi / 180);
                disp(z_exp)
            end

            curr_laser_data_idx += 1;
            % disp(current_state)
        else
            curr_odometry_data = [odometry(curr_odometry_data_idx, 1), odometry(curr_odometry_data_idx, 2), odometry(curr_odometry_data_idx, 3)];
            current_state = curr_odometry_data;
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