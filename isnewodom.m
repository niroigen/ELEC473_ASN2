function output = isnewodom(curr_odometry_data_idx, odometry, ODOMETRY_TIME_IDX, t, DELTA_T)
    output = curr_odometry_data_idx <= size(odometry,1) && odometry(curr_odometry_data_idx,ODOMETRY_TIME_IDX) >= t - DELTA_T && odometry(curr_odometry_data_idx,ODOMETRY_TIME_IDX) <= t;
end