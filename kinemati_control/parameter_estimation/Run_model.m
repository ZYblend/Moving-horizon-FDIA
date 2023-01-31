% Run_this_file_for parameter estimation
clear all
clc

%% parameter
d  = 0.1;                        % distance betwen medium point of axis of wheels and center of mass(m)

%% sampling time
Ts = 0.01;

%% dataset
theta = load('dataset/dataset1').theta;
x     = load('dataset/dataset1').x;
y     = load('dataset/dataset1').y;

v     = load('dataset/dataset1').v;
w     = load('dataset/dataset1').w;

time_serise = linspace(0,round(Ts*size(theta,1)),size(theta,1)).';

theta_time = [time_serise, theta];
x_time =  [time_serise, x];
y_time =  [time_serise, y];
v_time =  [time_serise, v];
w_time =  [time_serise, w];

%% initial condition
z_initial = [theta(1); x(1); y(1)];
