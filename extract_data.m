function [laser, odometry, end_time] = extract_data(file)
    fid = fopen(file);
    tline = fgetl(fid);

    odometry_line = 1;
    laser_line = 1;
    end_time = 0;

    while ischar(tline)
        ans = strsplit(tline);

        if (strcmp(ans(1),'L'))
            laser(laser_line,1) = str2double(ans(2)); % x_robot
            laser(laser_line,2) = str2double(ans(3)); % y_robot
            laser(laser_line,3) = str2double(ans(4)); % theta_robot
            laser(laser_line,4) = str2double(ans(5)); % x_laser
            laser(laser_line,5) = str2double(ans(6)); % y_laser
            laser(laser_line,6) = str2double(ans(7)); % theta_laser

            for i = 8:187
                laser(laser_line,i-1) = str2double(ans(i)); % scanner measurement
            end

            laser(laser_line, 187) = str2double(ans(188)); % time_stamp

            laser_line += 1;
            end_time = str2double(ans(188));
        else
            odometry(odometry_line,1) = str2double(ans(2)); % x_robot
            odometry(odometry_line,2) = str2double(ans(3)); % y_robot
            odometry(odometry_line,3) = str2double(ans(4)); % theta_robot
            odometry(odometry_line,4) = str2double(ans(5)); % time_stamp
            odometry_line += 1;
            end_time = str2double(ans(5));
        end

        tline = fgetl(fid);
    end
end