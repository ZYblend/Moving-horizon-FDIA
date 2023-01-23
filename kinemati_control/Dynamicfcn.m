function z_next = Dynamicfcn(z,u)

d=0.1;      %distance betwen medium point of axis of wheels and center of mass,(m)
Ts = 0.01;

%% unpacking inputs
theta=z(1);

v=u(1);
omega=u(2);

%% model
theta_dot=omega;
x_dot=v*cos(theta)-d*omega*sin(theta);
y_dot=v*sin(theta)+d*omega*cos(theta);

z_dot=[theta_dot;x_dot;y_dot];
z_next = z+z_dot*Ts;

