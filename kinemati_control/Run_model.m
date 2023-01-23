% Run_this_file_for_DDWMR_model
clear all
clc

%% parameter
d  = 0.1;                        % distance betwen medium point of axis of wheels and center of mass(m)


%% Initial condition
theta0=0;
x0=0;
y0=0;

u0 = [0;0];

z_initial = [theta0;x0;y0];   % initial for reference kinematic model
z_hat0 = [0;0;0];

n_states  = 3;  % number of states
n_meas = 6;     % number of meansurement nodes
n_int = 2;      % number of control inputs

y0 = zeros(n_meas,1);
u0 = zeros(n_int,1);

%% controller
kx = 4;
ky = 4;

  
%% sampling time
Ts = 0.01;  % (s)
T_final = 500;

%% covariance of measurement noise
R = 1e-3;
R_diag = diag(kron(ones(1,n_meas),R));

P_diag = (1e-3)*eye(n_states);


%% lineraization in T horizon 

