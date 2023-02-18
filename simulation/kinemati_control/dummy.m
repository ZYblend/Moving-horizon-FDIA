clear all
clc
close all

t = linspace(0,50,1000);
theta = t;
theta_d = mod((theta*2)-pi,2*pi)-pi;

zd = [theta_d;
      sin(2*theta);         % x
      1-1*cos(2*theta)]; 

% unit circle (radius = 1; origin: (0,0))
% zd = [2*theta;
%       sin(2*theta);         % x
%       1-1*cos(2*theta)];  

theta_x = zeros(1,length(t))';
theta_y = zeros(1,length(t))';
theta_z = zd(1,:)';
figure()
plot(t,theta_z)

eul = [theta_z, theta_y, theta_x];
quat = eul2quat(eul);
figure()
plot(t,quat(:,1),t,quat(:,4))

eul_out = quat2eul(quat);
figure()
plot(t,eul_out(:,1))

figure()
plot(t,theta_d)