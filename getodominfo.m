function u = getodominfo(curr_odom, prev_odom)
    del_rot1 = sqrt((curr_odom(1) - prev_odom(1))^2 + (curr_odom(2) - prev_odom(2))^2);
    del_trans = crossoverAngle(atan2(curr_odom(2) - prev_odom(2), curr_odom(1) - prev_odom(1)), prev_odom(3));
    del_rot2 = crossoverAngle(curr_odom(3), crossoverAngle(prev_odom(3), del_rot1));

    if abs(del_trans) <= 10
       del_rot1 = 0;
       del_rot2 = crossoverAngle(curr_odom(3), prev_odom(3));
    end
    u = [del_rot1, del_rot2, del_trans];
end