function weight = calculateZEXP(state, map, laser_theta)
    map_plt = dlmread(map);
    imshow(map_plt)
    hold on
    axis on

    plot(state(1), state(2), '.', 'MarkerSize',20)

    x_dist = 0;
    y_dist = 0;

    increment_x = 0;
    increment_y = 0;

    phi = state(3) + laser_theta;

    if phi >= -pi/4 && phi <= pi/4
        increment_x = 1;
        increment_y = tan(phi);
    elseif (phi >= 3*pi/4 && phi <= pi) || (phi <= -3*pi/4 && phi >= -1*pi)
        increment_x = -1;
        increment_y = -1 * tan(phi);
    elseif phi > pi/4 && phi < 3*pi/4
        increment_x = 1/tan(phi);
        increment_y = 1;
    else
        increment_x = -1/tan(phi);
        increment_y = -1;
    end        

    hit = false;

    while ~hit
        if map_plt(round(state(2) + x_dist), round(state(1) + y_dist))
            hit = true;
        else
            plot(state(1) + y_dist, state(2) + x_dist, 'r.', 'MarkerSize',10)
            x_dist += increment_x;
            disp(x_dist)
            y_dist += increment_y;
            disp(y_dist)
        end
    end

    disp(sqrt(x_dist^2 + y_dist^2))

    weight = 10;
end