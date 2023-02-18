% Run_this_file_for_DDWMR_model
clear all
close all
clc

rosshutdown
rosinit('192.168.2.15')

%% parameter
% d  = 0.042;                        % distance between medium point of axis of wheels and center of mass(m)
d  = 0.0562; % perfect 
% d  = 0.0177;
r=1;         % radius of the path generation
% r=0.25;
% iter = 0;

rw=0.05;     %radius of wheels,(m)
L=0.235/2;  %1/2 distance between two wheels,(m)

%% Initial condition
% circle intilization
% theta0=pi/2;
% x0=r;
% y0=0;
theta0=0;
x0=0;
y0=-r;

z_initial = [theta0;x0;y0];   % initial for reference kinematic model
z_hat0 = z_initial;

z_initial = [theta0;x0;y0];   % initial for reference kinematic model

n_states  = 3;  % number of states
n_meas = 6;     % number of meansurement nodes
n_int = 2;      % number of control inputs

% y0 = zeros(n_meas,1);
y_0 = [x0*cos(theta0);
          y0*sin(theta0);
          x0;
          y0;
          0.25*x0/rw + 0.25*L*y0/rw;
          0.25*x0/rw - 0.25*L*y0/rw];
u0 = zeros(n_int,1);


%% covariance of measurement noise
R_meas = 1e-4;
R_diag = diag(kron(ones(1,n_meas),R_meas));

P_inp = 1e-8;
P_diag = P_inp * eye(n_states);


%
%% controller
% kx = ky = 0.02 % perfect
% kx = 0.05;
% ky = 0.05;

kx = 1;
ky = 1;
  
%% sampling time
Ts = 0.03;  % (s)
% T_final = 1000;

% Ts = 0.01;  % (s)
T_final = 100;
T_start_attack = .5*T_final;  % Time to begin attack

% %% covariance of measurement noise
% R = 1e-3;

%% lineraization in T horizon 
Ad = eye(n_states);
Bd = @(theta) [0 1;
               cos(theta) -d*sin(theta);
               sin(theta) d*cos(theta)] * Ts;
% C = @(x,y,theta) [-x*sin(theta) cos(theta) 0;
%                    y*cos(theta) 0 sin(theta);
%                    0 1 0;
%                    0 0 1;
%                    0 1/(4*r) L/(4*r);
%                    0 1/(4*r) -L/(4*r)];
% Cd = C(z_initial(2), z_initial(3), z_initial(1));

%% Attack Parameters
pa = 0.3;
n_attack =  round(pa*n_meas);
% I_single = sort(randperm(n_meas,n_attack)).';
I_single = [3;4];
max_iter = 2000;   % maximal number of iteration of PGA algorithm

%% Bad Data Detection
BDD_thresh = 1;  % Bad data detection tolerance
nominal_error_range = 0.6;
sim('circlepath_initial.slx')