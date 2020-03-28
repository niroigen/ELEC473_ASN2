function [newX] = motionModel(u, X)
    a1 = 0.0003;
    a2 = 0.0001;
    a3 = 0.006;
    a4 = 1;

    delta_rot1 = u(1) + irwin_hall(0, a1 * u(1)^2 + a2 * u(3)^2);
    delta_translation = u(3) + irwin_hall(0, a3 * u(3)^2 + a4 * (u(1)^2 + u(2)^2));
    delta_rot2 = u(2) + irwin_hall(0, a1 * u(2)^2 + a2 * u(3)^2);

    x = X(1) + delta_translation * cos(X(3) + delta_rot1);
    y = X(2) + delta_translation * sin(X(3) + delta_rot1);
    theta = X(3) + delta_rot1 + delta_rot2;

    newX = [x, y, theta];
end