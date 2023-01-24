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

%% sampling time
Ts = 0.01;  % (s)
T_final = 500;

%% controller
kx = 4;
ky = 4;

%% MPC Controller
L = 10;  % horizon
R = 0.1*eye(n_int);
Q = 5*eye(n_states);  
P = 5*eye(n_states); 
P_alpha = 0.01*eye(n_int);

u_up = [0.7; 1.5];
u_lo = [-0.7; -1.5];

rate_bound = 0.2;

D_bar = @(N,n)[zeros((N-1)*n,n), eye((N-1)*n)];
D_under = @(N,n)[eye((N-1)*n),zeros((N-1)*n,n)];
E = kron([1, zeros(1,L)],eye(n_states));
% E2 = kron([zeros(1,L),1],diag([0 1 1]));
% 
% E2_up = [0; 1; 2];
% E2_lo = [0; -1; 0];

A = @(z) [1 0 0;
     -Ts*sin(z(1))-d*Ts*cos(z(1)) 1 0;
     Ts*cos(z(1))-d*Ts*sin(z(1)) 0 1];
B = @(z) Ts*[0 1;
          cos(z(1)) -d*sin(z(1));
          sin(z(1)) d*cos(z(1))];

H1 = blkdiag(kron(eye(L),Q), P);
H2 = kron(eye(L),R);
H3 = kron(eye(L),P_alpha);
H = blkdiag(H1,H2,H3);

Aeq = @(z) [D_bar(L+1,n_states)-kron(eye(L),A(z))*D_under(L+1,n_states) -kron(eye(L),B(z)) zeros(L*n_states,n_int*L);
            E zeros(n_states,n_int*L) zeros(n_states,n_int*L)];

Aineq = [zeros(n_int*L,n_states*(L+1)) eye(n_int*L) -eye(n_int*L);
         zeros(n_int*L,n_states*(L+1)) -eye(n_int*L) -eye(n_int*L);
         zeros(n_int*(L-1),n_states*(L+1)) D_bar(L,n_int)-D_under(L,n_int) zeros(n_int*(L-1),n_int*L);
         zeros(n_int*(L-1),n_states*(L+1)) D_under(L,n_int)-D_bar(L,n_int) zeros(n_int*(L-1),n_int*L)];
bineq = [kron(ones(L,1),u_up);
         kron(ones(L,1),u_up);
         rate_bound*ones(n_int*(L-1),1);
         rate_bound*ones(n_int*(L-1),1)];



%% covariance of measurement noise
R_meas = 1e-3;
R_diag = diag(kron(ones(1,n_meas),R_meas));

P_diag = (1e-3)*eye(n_states);


%% lineraization in T horizon 

