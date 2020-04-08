function theta = crossoverAngle(theta1, theta2)
    theta = theta1 - theta2;

    if (theta < -1*pi)
        theta = theta + 2*pi;
    else if (theta > pi)
        theta = theta - 2*pi;
    end
end