%% Run file
addpath('Resilient_Optimizer')
addpath('Attack_Generators')

%% system model
T_sample = 0.01;
load A_bar_d.mat;
load B_bar_d.mat;
load C_obsv_d.mat;
load D_obsv_d.mat;

n_gen       = 5; % number of generators
n_bus       = 14; % number of buses
n_states    = 2*n_gen;
p           = n_states + n_bus;
n_meas      = n_gen + n_bus;  % number of measurements
% disp('eigenvalues of linearized A')
% disp(eig(A_bar_d).')

%% system matrix unit testing
%controllability and observability
% disp('controllability')
% disp(rank(ctrb(A_bar_d,B_bar_d))) % fully controllable with PID controller
% disp('observability')
% disp(rank(obsv(A_bar_d,C_obsv_d))) % fully observable

%% Simulation Initialization
x0          = zeros(n_states,1);
x0_hat      = zeros(n_states,1);
load_buses  = [zeros(n_gen,1); ones(n_bus-n_gen,1)];
%% Observer Dynamics
%%% Pole Placement
P = .1 + .4*rand(2*n_gen,1);
L_obsv = place(A_bar_d.',C_obsv_d.',P).';

%% Observer Parameters

% parameters
n       = n_states;         % # of states
m       = n_meas;           % # of measurements
l       = n_meas;           % # of inputs
T       = round(2*n);     % receeding horizon

N_samples      = 800; % The total number of samples to run
T_final        = N_samples*T_sample;  % Total time for simulation

% tapped delay
U0      = zeros(m,T);
Y0      = zeros(m,T);

[PhiT,HT,Theta_T,G_T] = opti_params(A_bar_d,B_bar_d,C_obsv_d,T);

% turn on optimizers
T_start_opt(:)    = 1.5*T*T_sample; % start time for the optimization routines. Wait to collect enoguh data before calling the optimizers

%% Attack Parameters
pa = 0.2;
n_attack =  round(pa*n_meas);
% n_attack = 1;
T_start_attack = .2*T_final;  % Time to begin attack


%% Bad Data Detection
BDD_thresh = 0.05*0.6352;  % Bad data detection tolerance

%% L2 moving-horizon attack generation
% initial T attacks (not injected in system, only for atatck design)
T1 = 20;   % time horizon for FDIA design
[PhiT1,HT1,Theta_T1,G_T1] = opti_params(A_bar_d,B_bar_d,C_obsv_d,T1);

I = sort(randperm(n_meas,n_attack)).';
% I = [1;2;9;11;12;16;17];
I_attack_ini = repmat(I,1,T1);           % fixed attack support

% flat attack support for T horizon
I_aux = linspace(0,(T1-1)*m,T1);
I_aux = repmat(I_aux,n_attack,1);
I_attack = I_attack_ini+I_aux;
I_attack = I_attack(:);

% initial T attacks
e_ini = L2_FDIA(PhiT1,I_attack(:),0.3*T1*BDD_thresh);
% e_ini = zeros(T*m,1);
% for iter = 1:T-1
%     e_ini((iter-1)*m+1:iter*m) = proj_tau(0.1*randn(m,1),I);
% end
e_ini_matrix = reshape(e_ini,n_meas,T1);

% moving-horizon FDIA parameters
[U,S,V] = svd(PhiT1);
U_history = U(1:(T1-1)*m,:);
U_i = U((T1-1)*m+1:end,:);
S1 = S(1:n_states,1:n_states);

IO = [eye(n_states) zeros(n_states,T1*n_meas-n_states)];
OI = [zeros(T1*n_meas-n_states,n_states) eye(T1*n_meas-n_states)];

A1 = inv(S1)*IO*U_i.';
A2 = OI*U_i.';
b1p = inv(S1)*IO*U_history.';
b2p = OI*U_history.';

max_iter = 300;   % maximal number of iteration of PGA algorithm

% G1 = eye(T1*n_meas)-PhiT1*pinv(PhiT1,0.01); 
% G2 = eye(n_meas*T)-PhiT*pinv(PhiT,0.01);


%% L2 moving-horizon FDIA attack generation (Eigenvalue problem version)
Se1 = S(1:n_states,1:n_states);
Ue11 = U(I_attack(1:(T1-1)*n_attack),1:n);
Ue12 = U(I_attack((T1-1)*n_attack+1:end),1:n);


function x_proj = proj_tau(x,Tau)
% projects vector x to a specified sparsity patern given in the support Tau

% Inputs:
%   - x [n-vector]: input vector to project
%   - Tau [<=n vector]: support of the projected vector
%
% Ouput:
%   - x [n-vector]: output vector with specified sparsity pattern

% Olugbenga Moses Anubi 10/12/2021
x_proj = zeros(size(x(:)));
x_proj(Tau) = x(Tau);
end



