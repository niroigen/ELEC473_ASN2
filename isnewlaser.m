function output = isnewlaser(curr_laser_data_idx, laser, LASER_TIME_IDX, t, DELTA_T)
    output = curr_laser_data_idx <= size(laser,1) && laser(curr_laser_data_idx,LASER_TIME_IDX) >= t - DELTA_T && laser(curr_laser_data_idx,LASER_TIME_IDX) <= t;
end