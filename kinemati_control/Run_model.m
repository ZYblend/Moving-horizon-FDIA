% Run_this_file_for_DDWMR_model
clear all
clc

%% parameter
d  = 0.1;                        % distance betwen medium point of axis of wheels and center of mass(m)


%% Initial condition
theta0=0;
x0=0;
y0=0;

z_initial = [theta0;x0;y0];   % initial for reference kinematic model

n_states  = 3;  % number of states
n_meas = 6;     % number of meansurement nodes
n_int = 2;      % number of control inputs

%% controller
kx = 5;
ky = 5;

  
%% sampling time
Ts = 0.01;  % (s)

T_final = 20;
T_start_attack = .2*T_final;  % Time to begin attack

%% covariance of measurement noise
R = 1e-3;


%% lineraization in T horizon 

