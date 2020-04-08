function zexp = calculateZEXP(state, map_plt, laser_theta, Zmax)
    x_dist = 0;
    y_dist = 0;

    increment_x = 0;
    increment_y = 0;

    x_laser = state(1) + 25 * cos(laser_theta);
    y_laser = state(2) + 25 * sin(laser_theta);

    % laser = plot(round(y_laser/10), round(x_laser/10), 'ys');

    phi = state(3) + laser_theta;

    zexp = -1;

    if phi > pi
        phi = phi - 2 * pi;
    elseif phi < -pi
        phi = phi + 2 * pi;
    end

    if phi > -pi/4 && phi < pi/4
        increment_x = 10;
        increment_y = 10*tan(phi);
    elseif (phi > 3*pi/4 && phi < pi) || (phi < -3*pi/4 && phi > -1*pi)
        increment_x = -10;
        increment_y = -10 * tan(phi);
    elseif phi > pi/4 && phi < 3*pi/4
        increment_x = 10/tan(phi);
        increment_y = 10;
    elseif phi > -3*pi/4 && phi < -pi/4
        increment_x = -10/tan(phi);
        increment_y = -10;
    else
        pause;
    end        

    hit = false;

    while ~hit
        x_loc = x_laser  + x_dist;
        y_loc = y_laser + y_dist;

        if sqrt(x_dist^2 + y_dist^2) >= Zmax 
            zexp = Zmax;
        elseif round(x_loc/10) > 800 || round(x_loc/10) < 1 || round(y_loc/10) > 800 || round(y_loc/10) < 1
            break;
        end

        if map_plt(round(x_loc/10), round(y_loc/10)) >= 0.25 || map_plt(round(x_loc/10), round(y_loc/10)) == -1
            hit = true;
        else
            x_dist = x_dist+ increment_x;
            y_dist = y_dist+ increment_y;
        end

        % plt = plot(round(y_loc/10), round(x_loc/10), 'r', 'LineWidth',12);
        % drawnow ()
        % disp("PLOTTED");
        % pause;
        % delete(plt);
    end

    if zexp == -1
        zexp = sqrt(x_dist^2 + y_dist^2);
    end

    % delete(laser);
end