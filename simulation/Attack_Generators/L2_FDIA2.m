function [stop_iter,e_i] = L2_FDIA2(H,I,eps,max_iter)
%% e = L2_FDIA(H,I_attack,tau,T)
%  Generates sparse attack vector that corrupts the L2 states estimates as
%  much as possible for the linear systeme given by: y = H*x 
%
% Yu Zheng, 09/19/2021, FSU

%% parameteres
[m,n] = size(H);

[U,S,V] = svd(H);
U1 = U(:,1:n);
U2 = U(:,n+1:end);
S1 = S(1:n,1:n);

A1 = inv(S1)*U1.';
A2 = U2.';
obj_A  = A1(:,I);
cons_A = A2(:,I);

cons_b = zeros(size(cons_A,1),1);
obj_b = zeros(size(obj_A,1),1);

[~,n] = size(obj_A);

[U2,S2,V2] = svd(cons_A);
U22        = U2(:,n+1:end);
U21        = U2(:,1:n);
S2         = S2(1:n,1:n);
sigma2_max = S2(1,1);   % biggest singular value of A2
A2_dagger  = V2*(S2\(U21.'));

lambda_0 = 1e-3;
% max_iter = 1000;
tol      = 1e-6;

e_i = zeros(m,1);
stop_iter = 0;
if norm(U22.'*cons_b) < eps
    [~,X,~,stop_iter] = PGA_solver2(obj_A,cons_A,obj_b,cons_b,A2_dagger,sigma2_max,eps,lambda_0,max_iter,tol);
    %% Output
    if stop_iter < max_iter
        e_i(I) = X(:,stop_iter);
    else
        e_i(I) = X(:,end);
    end
end


end
