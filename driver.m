LASER_TIME_IDX = 187;
ODOMETRY_TIME_IDX = 4;
DELTA_T = 0.01;

[laser, odometry, end_time] = extract_data('robotdata1.log');

curr_laser_data = 1;
curr_odometry_data = 1;

for t = 0:DELTA_T:end_time
    disp(t)

    if laser(curr_laser_data,LASER_TIME_IDX) >= t - DELTA_T && laser(curr_laser_data,LASER_TIME_IDX) <= t
        %% PERFORM SENSOR MODEL UPDATE
        curr_laser_data += 1;
    end

    if odometry(curr_odometry_data,ODOMETRY_TIME_IDX) >= t - DELTA_T && odometry(curr_odometry_data,ODOMETRY_TIME_IDX) <= t
        %% PERFORM MOTION MODEL UPDATE
        curr_odometry_data += 1;
    end

    %% UPDATE BELIEF
end