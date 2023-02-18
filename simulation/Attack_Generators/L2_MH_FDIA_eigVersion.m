function e_i = L2_MH_FDIA_eigVersion(e_history,I_history, I_i, T,n_meas,epsilon, Ue11,Ue12,Se1)
%% function e_i = L2_MH_FDIA_eigVersion(e_history,I_history, I_i, T,n_meas,epsilon, Ue11,Ue12,Se1)
%
%
%
%% optimization parameters
m = n_meas;      % measurement dimension
n = size(Se1,1);   % state dimension
n_attack = length(I_i);


% Flatten the attack support
I_aux_history = linspace(0,(T-2)*m,T-1);
I_aux_history = repmat(I_aux_history, n_attack,1);
I_history = I_history+I_aux_history;
I_history_flat = I_history(:);

e_history_flat = e_history(:);
e_history_I = e_history_flat(I_history_flat); % attack on the support

%% Algorithm
v1 = Se1*Ue11.'*e_history_I/norm(Se1*Ue11.'*e_history_I);

[~,~,V] = svd(Ue11.'*Ue11);
v2 = V(n,:).';

a = @(v) norm(Ue11*Se1*v)^2;
b = @(v) -abs(v.'*Se1*Ue11.'*e_history_I);
c = @(v) epsilon^2-norm(e_history_I)^2;
f = @(v) (-b(v)+sqrt(b(v)^2+4*a(v)*c(v)))/(2*a(v));
% alpha1 = (abs(v1.'*Se1*Ue11.'*e_history_I)+sqrt(abs(v1.'*Se1*Ue11.'*e_history_I)^2+4*a(v1)*c(v1)))/(2*a(v1));
% alpha2 = (abs(v2.'*Se1*Ue11.'*e_history_I)+sqrt(abs(v2.'*Se1*Ue11.'*e_history_I)^2+4*a(v2)*c(v2)))/(2*a(v2));

if f(v1) >= f(v2)
    v_star = v1;
    alpha_star = f(v1);
else
    v_star = v2;
    alpha_star = f(v2);
end

lambda_star = -sign(v_star.'*Se1*Ue11.'*e_history_I)*alpha_star;

% output
z = lambda_star*Ue12*Se1*v_star;
e_i = zeros(m,1);
e_i(I_i) = z;

end