% Run_this_file_for parameter estimation
clear all
clc

%% parameter
d  = 0.1;                        % distance betwen medium point of axis of wheels and center of mass(m)

%% sampling time
Ts = 0.01;

%% dataset
theta = load('dataset/data1').theta;
x     = load('dataset/data1').x;
y     = load('dataset/data1').y;

v     = load('dataset/data1').v;
w     = load('dataset/data1').w;

%% initial condition
z_initial = [theta(1); x(1); y(1)];
