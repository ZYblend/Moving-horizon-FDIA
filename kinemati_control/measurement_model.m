function y_meas = measurement_model(z)

L=0.235/2;  %1/2 distance between two wheels,(m)
r=0.05;     %radius of wheels,(m)

%% unpacking inputs
theta = z(1);
x = z(2);
y = z(3);


%% measurement model
y_meas = [x*cos(theta);
     y*sin(theta);
     x;
     y;
     0.25*x/r + 0.25*L*y/r;
     0.25*x/r - 0.25*L*y/r];

