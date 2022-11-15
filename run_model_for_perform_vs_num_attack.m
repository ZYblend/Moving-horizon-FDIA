n_attack = N_Attack(idx);
I = sort(randperm(n_meas,n_attack)).';

I_attack_ini = repmat(I,1,T1);           % fixed attack support

% flat attack support for T horizon
I_aux = linspace(0,(T1-1)*m,T1);
I_aux = repmat(I_aux,n_attack,1);
I_attack = I_attack_ini+I_aux;
I_attack = I_attack(:);

% initial T attacks
e_ini = zeros(T*m,1);
for iter1 = 1:T-1
    e_ini((iter1-1)*m+1:iter1*m) = proj_tau(0.1*randn(m,1),I);
end
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

max_iter = 2000;   % maximal number of iteration of PGA algorithm

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


