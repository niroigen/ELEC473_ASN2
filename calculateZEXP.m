function zexp = calculateZEXP(state, map_plt, laser_theta, Zmax)
    x_dist = 0;
    y_dist = 0;

    increment_x = 0;
    increment_y = 0;

    x_laser = state(1) + (25 * cos(laser_theta))/10;
    y_laser = state(2) + (25 * sin(laser_theta))/10;

    phi = state(3) + laser_theta;

    zexp = -1;

    if phi >= -pi/4 && phi <= pi/4
        increment_x = 10;
        increment_y = 10*tan(phi);
    elseif (phi >= 3*pi/4 && phi <= pi) || (phi <= -3*pi/4 && phi >= -1*pi)
        increment_x = -10;
        increment_y = -10 * tan(phi);
    elseif phi > pi/4 && phi < 3*pi/4
        increment_x = 10/tan(phi);
        increment_y = 10;
    else
        increment_x = -10/tan(phi);
        increment_y = -10;
    end        

    hit = false;

    while ~hit
        x_loc = x_laser  + x_dist;
        y_loc = y_laser + y_dist;

        if sqrt(x_dist^2 + y_dist^2) >= Zmax || round(x_loc) > 800 || round(x_loc) < 1 || round(y_loc) > 800 || round(y_loc) < 1
            zexp = Zmax;
            break;
        end

        if map_plt(round(x_loc), round(y_loc)) >= 0.25
            hit = true;
        else
            x_dist = x_dist+ increment_x;
            y_dist = y_dist+ increment_y;
        end

        % plt = plot(round(x_loc), round(y_loc), 'r');
        % drawnow ()
        % delete(plt);
    end

    if zexp == -1
        zexp = sqrt(x_dist^2 + y_dist^2);
    end
end