function y2 = encoder(z)
%encoder: measurement for Delta_S_l and Delta_S_r

theta = z(1);
x = z(2);
y = z(3);



L=0.235/2;  %1/2 distance between two wheels,(m)


% y2_1 = -2*L*(theta-theta_old)+2*(x-x_old)*cos(theta)+2*(y-y_old)*sin(theta);
% y2_2 = 2*L*(theta-theta_old);
% y2_2 = -2*L*(theta-theta_old)+2*(y-y_old)*sin(theta);
y2_1 = x*cos(theta);
y2_2 = y*sin(theta);

y2 = [y2_1;
      y2_2];

end

