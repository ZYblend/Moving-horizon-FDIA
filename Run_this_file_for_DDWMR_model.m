% Run_this_file_for_DDWMR_model
clear all
clc

addpath("Attack_Generators\");
addpath("Resilient_Optimizer\");

%% parameter
r  = 0.05;                       % wheel's radium (m)
mc = 10;                         % robot platform's weight (kg)
mw = 2.5;                        % Wheel's weight (kg)
m  = mc+2*mw;                    % total weight (kg)
L  = 0.235/2;                    % half of distance between two wheels (m)
d  = 0.1;                        % distance betwen medium point of axis of wheels and center of mass(m)
Ic = 0.05;                       % inertia of robot about vertical axis (kg.m^2)
Iw = 0.025;                      % inertia of wheel about wheel axis (kg.m^2)
Im = 0.025;                      % inertia of wheel about wheel diameter (kg.m^2)
I  = Ic +mc*d^2+2*mw*L^2+2*Im;   % inertia of whole robot (kg.m^2)

%% Initial condition
theta0=0;
x0=0;
y0=0;
v0=0.8;
omega0=0;

q_initial = [theta0;x0;y0];   % initial for reference kinematic model
V_initial = [v0;omega0];

n_states  = 3;  % number of states
n_meas = 6;     % number of meansurement nodes
n_int = 2;      % number of control inputs

  
%% sampling time
Ts = 0.01;  % (s)

T_final = 20;
T_start_attack = .2*T_final;  % Time to begin attack

%% covariance of measurement noise
R = 1e-3;


%% lineraization in T horizon 
T  = 6;

M = diag([m, m*d^2+I]);
D = [0 m*d*omega0;m*d*omega0 0];

C = [                  0,                       1,            0;
                        0,                       0,            1;
                        0,                      1/(4*r),     L/(4*r);
                        0,                      1/(4*r),     -L/(4*r); 
      -v0*sin(theta0)-d*omega0*cos(theta0),  cos(theta0), -d*sin(theta0);
       v0*cos(theta0)+d*omega0*sin(theta0),  sin(theta0),  d*cos(theta0)];
Cd = C;
 
%  A = [   0,           0,                       1;
%          0,           0,                  2*d*omega0;
%          0,    -m*d*omega0/(m*d^2+I),    -m*d*v0/(m*d^2+I) ];

A = [0 0 1;
     zeros(2,1) -inv(M)*D];
Ad = eye(n_states)+Ts*A;

B_temp = (1/r)*[1,1;L,-L];
B = [zeros(1,n_int);
     inv(M)*B_temp];
Bd = B*Ts;


%% Attack Parameters
pa = 0.4;
n_attack =  round(pa*n_meas);
T_start_attack = .2*T_final;  % Time to begin attack


%% Bad Data Detection
BDD_thresh = 0.5;  % Bad data detection tolerance

%% L2 moving-horizon attack generation
% initial T attacks (not injected in system, only for atatck design)
T1 = 2*T;   % time horizon for FDIA design
[PhiT1,HT1,Theta_T1,G_T1] = opti_params(Ad,Bd,Cd,T1);

I_single = sort(randperm(n_meas,n_attack)).';
% I_single = [1;2;9;11;12;16;17];
I_attack_ini = repmat(I_single,1,T1);           % fixed attack support

% flat attack support for T horizon
I_aux = linspace(0,(T1-1)*n_meas,T1);
I_aux = repmat(I_aux,n_attack,1);
I_attack = I_attack_ini+I_aux;
I_attack = I_attack(:);

% initial T attacks
e_ini = L2_FDIA(PhiT1,I_attack(:),0.8*T1*BDD_thresh);
e_ini_matrix = reshape(e_ini,n_meas,T1);

% moving-horizon FDIA parameters
[U,S,V] = svd(PhiT1);
U_history = U(1:(T1-1)*n_meas,:);
U_i = U((T1-1)*n_meas+1:end,:);
S1 = S(1:n_states,1:n_states);

IO = [eye(n_states) zeros(n_states,T1*n_meas-n_states)];
OI = [zeros(T1*n_meas-n_states,n_states) eye(T1*n_meas-n_states)];

A1 = inv(S1)*IO*U_i.';
A2 = OI*U_i.';
b1p = inv(S1)*IO*U_history.';
b2p = OI*U_history.';

max_iter = 2000;   % maximal number of iteration of PGA algorithm


%% L2 moving-horizon FDIA attack generation (Eigenvalue problem version)
Se1 = S(1:n_states,1:n_states);
Ue11 = U(I_attack(1:(T1-1)*n_attack),1:n_states);
Ue12 = U(I_attack((T1-1)*n_attack+1:end),1:n_states);