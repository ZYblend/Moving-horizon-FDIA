function MHFDIA_Basics
clc
clear 

%% Sizes
m = 10;
T = 6;
n = 5;
k = 8;

%% ADMM parameters
rho      = .1;
tol      = 1e-6;
max_iter = 1000;



%% system matrices
H = randn(m*T,n);
H_perp = pinv(H);

[~,S,V] = svd(H_perp);

sigma_bar = S(1);
v         = V(:,1);

M = inv((H_perp.'*H_perp) + rho*eye(m*T));

tic
[w,y,u,terminal_iter] = ADMM_proj(v,m,k,rho,sigma_bar,M,tol,max_iter);
toc

[v w y proj(v,m,k)]
J = @(x) norm(H_perp*x);
[J(v) J(w) J(y) J(proj(v,m,k))]

keyboard

function [w,y,u,iter] = ADMM_proj(v,m,k,rho,sigma_bar,M,tol,max_iter)
% [w,y,u] = ADMM_proj(v,k,rho,sigma_bar,M,tol,max_iter) 
%    solves the projection problem
%        Minimize ||H_perp*(v-w)||_2, Subject to: w \in Sigma_k \cap B_2
%    using the ADMM splitting algorithm
%
% Inputs:
%   - v [n-vector]       : the vector to project
%   - m [scalar]         : size of each block in the vector v
%   - k [scalar]         : the sparsity level for Sigma_k
%   - rho [scalar]       : ADMM augmented Lagrangian regularization weight
%   - sigma_bar [scalar] : the biggest singular value of H_perp
%   - M [n-by-n matrix]  : (H_perp.'*H_perp + rho*I)^-1
%   - tol [scalar]       : termination criterion for ||w-y||
%   - max_iter           : The maximmum iteration allowed
%
% Outputs:
%   - w [n-vector] : The projected vector
%   - y [n-vector] : The split dummy variable (Should be tol-close to w at
%                    convergence
%   - u [n-vector] : The Lagrange multiplier

% Olugbenga Moses Anubi 9/21/2021

% Initializing 
y = proj(v,m,k);
u = zeros(size(v));

% ADMM iteration
for iter = 1:max_iter
    % ADMM primal update
    w = M*(sigma_bar^2*v + rho*(y-u));  % w-update
    y = proj(w+u,m,k); % y-update
    
    % termination criteria
    if(norm(w-y)<=tol) 
        break;
    end
    
    % ADMM dual upadte
    u = u + w - y;  
end

function x_proj = proj(x,m,k)
% x_proj = proj(x,m,k) projects the m*T vector to the sparsity patern 
%                      defined by Sigma_k = {e = [e_1 ... e_T] |
%                                                           |supp(e_i)|<=k}
%                      T will be clear from context and required from x
%
% Inputs:
%    - x: [T*m-vector]: input vector to project
%    - m: [scalar]    : size of each block of x
%    - k: [scalar]    : required sparsity level
% 
% Ouputs:
%    - x_proj [T*m-vector]: output unit vector with required sparsity
%                           pattern

% Olugbenga Moses Anubi 9/21/2021

% restricting the length of x to integerger multiple of m by dropping extra
% elements
n_x = length(x);
assert(n_x>=m);
T          = floor(n_x/m);

x_reshaped = reshape(x(1:T*m),m,T);

[~,I_sort] = sort(abs(x_reshaped),'desc');

% clipping the last (m-k)-rows to zero
clip_index = (k+1:m); % the index of the k-smallest values
x_reshaped(I_sort(clip_index,:) + repmat((0:T-1),m-k,1)*m) = 0; 

% % unitizing the columns of the clipped matrices
% x_reshaped_unitized = x_reshaped./repmat(sqrt(sum(x_reshaped.^2,1)),m,1);

x_proj = x_reshaped(:)/norm(x_reshaped(:));




