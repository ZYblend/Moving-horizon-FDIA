function [stop_iter,e_i] = L2_MH_FDIA(A1,A2,b1p,b2p,I_history,e_history,I_i,T,n_meas,epsilon,max_iter)
%% This function is to generate moving-horizon attack by
 % solving the following optimization program:
% maximzie    ||A1*e_i + b1p*e_history||_2
% subject to  ||A2*e_i + b2p*e_history||_2 < epsilon
%
%
% Since e_history is known in advance, the above optimization is a concave
% QCQP problem generalized as follwoing:
%   maximize   ||obj_A*x+obj_b||_2 (= f)
%   subject to ||cons_A*x+cons_b||_2<=epsilon
%
% Solution (Projected gradient ascent):
%          x_{k+1} = QCQP_proj(x_{k}+ lambda*delta_f)
%    until: x_{k+1}-x_{k} < tau(convergency threshold)
%
% Inputs:
%        H: [T*n_meas-by-n] horizonal measurement matrix
%        I_history: [k-by-(T-1)]: support of the attack history
%        e_history: [n_meas-by-(T-1)]: sparse attack history
%        I_i: [vector]: support of the current attack
%        T: {scalar] time horizon
%        n_meas: [scalar] measurement dimension
%        epsilon: [scalar] constraint threshold
% Output:
%        e_i: current attack
%        fail_flag: fail flag (1: failed)
%
% Yu Zheng, Florida State University, Oct.3/2021

%% optimization parameters
m = n_meas;      % measurement dimension
n = size(A1,1);   % state dimension
n_attack = length(I_i);


% Flatten the attack support
I_aux_history = linspace(0,(T-2)*m,T-1);
I_aux_history = repmat(I_aux_history, n_attack,1);
I_history = I_history+I_aux_history;
I_history_flat = I_history(:);

% I_aux = (T-1)*m*ones(n_attack,1);
% I_i_flat = I_i+I_aux;

e_history_flat = e_history(:);
e_history_I = e_history_flat(I_history_flat); % attack on the support

%% generalized case
obj_A  = A1(:,I_i);
cons_A = A2(:,I_i);
b1 = b1p(:,I_history_flat);
b2 = b2p(:,I_history_flat);
obj_b  = b1*e_history_I;
cons_b = b2*e_history_I;

[~,n] = size(obj_A);
% m2 = length(cons_b);

[U2,S2,V2] = svd(cons_A);
U22        = U2(:,n+1:end);
U21        = U2(:,1:n);
S2         = S2(1:n,1:n);
sigma2_max = S2(1,1);   % biggest singular value of A2
A2_dagger  = V2*(S2\(U21.'));

% algorithm parameters
lambda_0 = 1e-4;
% max_iter = 1000;
tol      = 1e-4;

e_i = zeros(m,1);
stop_iter = 0;
if norm(U22.'*cons_b) < epsilon
    [~,X,~,stop_iter] = PGA_solver2(obj_A,cons_A,obj_b,cons_b,A2_dagger,sigma2_max,epsilon,lambda_0,max_iter,tol);
    %% Output
%     if stop_iter < max_iter
%         e_i(I_i) = X(:,stop_iter-1);
%     else
%         e_i(I_i) = X(:,end);
%     end
    e_i(I_i) = X(:,stop_iter-1);
end


end
