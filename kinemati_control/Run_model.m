% Run_this_file_for_DDWMR_model
clear all
clc

%% parameter
d  = 0.1;                        % distance betwen medium point of axis of wheels and center of mass(m)
L=0.235/2;  %1/2 distance between two wheels,(m)
r=0.05;     %radius of wheels,(m)


%% Initial condition
theta0=0;
x0=1;
y0=0;

z_initial = [theta0;x0;y0];   % initial for reference kinematic model
z_hat0 = z_initial;

n_states  = 3;  % number of states
n_meas = 6;     % number of meansurement nodes
n_int = 2;      % number of control inputs

y0 = zeros(n_meas,1);
u0 = zeros(n_int,1);

%% sampling time
Ts = 0.01;  % (s)
T_final = 500;

%% controller
kx = 15;
ky = 15;


%% covariance of measurement noise
R_meas = 1e-4;
R_diag = diag(kron(ones(1,n_meas),R_meas));

P_inp = 1e-10;
P_diag = P_inp * eye(n_states);


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
% Cd = C(0,0,1.5);


%% Attack Parameters
pa = 0.4;
n_attack =  round(pa*n_meas);
T_start_attack = .2*T_final;  % Time to begin attack
I_single = sort(randperm(n_meas,n_attack)).';


%% Bad Data Detection
BDD_thresh = 1;  % Bad data detection tolerance

% %% L2 moving-horizon attack generation
% T = 10;
% % initial T attacks (not injected in system, only for atatck design)
% T1 = 2*T;   % time horizon for FDIA design
% [PhiT1,HT1,Theta_T1,G_T1] = opti_params(Ad,Bd,Cd,T1);
% 
% I_single = sort(randperm(n_meas,n_attack)).';
% % I_single = [1;2;9;11;12;16;17];
% I_attack_ini = repmat(I_single,1,T1);           % fixed attack support
% 
% % flat attack support for T horizon
% I_aux = linspace(0,(T1-1)*n_meas,T1);
% I_aux = repmat(I_aux,n_attack,1);
% I_attack = I_attack_ini+I_aux;
% I_attack = I_attack(:);
% 
% % initial T attacks
% e_ini = L2_FDIA(PhiT1,I_attack(:),0.8*T1*BDD_thresh);
% e_ini_matrix = reshape(e_ini,n_meas,T1);
% 
% % moving-horizon FDIA parameters
% [U,S,V] = svd(PhiT1);
% U_history = U(1:(T1-1)*n_meas,:);
% U_i = U((T1-1)*n_meas+1:end,:);
% S1 = S(1:n_states,1:n_states);
% 
% IO = [eye(n_states) zeros(n_states,T1*n_meas-n_states)];
% OI = [zeros(T1*n_meas-n_states,n_states) eye(T1*n_meas-n_states)];
% 
% A1 = inv(S1)*IO*U_i.';
% A2 = OI*U_i.';
% b1p = inv(S1)*IO*U_history.';
% b2p = OI*U_history.';
% 
max_iter = 2000;   % maximal number of iteration of PGA algorithm
% 
% 
% %% L2 moving-horizon FDIA attack generation (Eigenvalue problem version)
% Se1 = S(1:n_states,1:n_states);
% Ue11 = U(I_attack(1:(T1-1)*n_attack),1:n_states);
% Ue12 = U(I_attack((T1-1)*n_attack+1:end),1:n_states);