function weight = sensorModel(current_state, Zmax, a_short, a_hit, a_max, a_rand, laser, occupancy_map, curr_laser_data_idx, sigma, lambda)
    angles = [-89.5:1:89.5];

    weight = 1;

    for i = 1:10:180
        z_exp = calculateZEXP(current_state,occupancy_map, angles(i) * pi / 180, Zmax);
        z = laser(curr_laser_data_idx, 6+i);

        % pause;
        norm_z = 1;

        if ((z_exp - 2*sigma) < 0) || ((z_exp + 2*sigma) > Zmax)
            norm_z = 2/(erf((Zmax - z_exp)/(sqrt(2)*sigma))-erf((-1*z_exp)/(sqrt(2)*sigma)));
        end

        p_hit = norm_z * (1/sqrt(2 * pi * sigma^2)) * exp((-1*(z-z_exp)^2)/(2*sigma^2));

        p_short = 0;
        if z < z_exp
            norm_short = 1/(1-e^(-1*lambda*z_exp));
            p_short = norm_short * lambda * e^(-1*lambda*z);
        end
        
        p_max = 0;
        if(z > Zmax)
            p_max = 1;
        end

        p_rand = 1/Zmax;

        p = [a_hit, a_short, a_max, a_rand] * [p_hit; p_short; p_max; p_rand];

        weight = weight* p;
    end

end