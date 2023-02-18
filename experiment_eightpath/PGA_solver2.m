function [alpha,X,lambda_k,stop_iter] = PGA_solver2(A1,A2,b1,b2,A2_dagger,sigma2_max,epsilon,lambda_0,max_iter,tol)
%% function [alpha,X] = PGA_solver2(A1,A2,b1,b2)
% This function is to implment a projected gradient ascent algorithm to
% solve the following optimization problem
%  Maximize ||A1*x+b1||_2
%  subject to ||A2*x+b2||_2 <= epsilon
%
%
% Assumptions:
%             1) A2 is full-rank (m2>n)
%             2) ||U_22.'*b2||_2 <= epsilon
% Solution:
%         (1) x0 = -V_2*Sigma_2^{-1}*U_{21}.'*b2;  (initial solution, it is
%             equal to argmin||A2*x+b2||_2)
%             where by singular value decomposition, A2 = [U_{21} U_{22}]*Sigma*V_2.'
%         (2) if ||A1.'*A1*x_k+A1.'*b1||_2 >=tol (zero tolerance parameter)
%                v_k = (A1.'*A1*x_k+A1.'*b1)/||A1.'*A1*x_k+A1.'*b1||_2
%             else
%                v_k = 0;
%         (3) x_{k+1} = x_k +lambda_k*v_k
%              where, if ||A2*x_k+lambda_0*A2*v_k+b2||_2 <=epsilon
%                        lambda_k = lambda_0
%                     else
%                        lambda_k = [-||A2*x_k+b2||_2+sqrt(sigma_2^2*epsilon^2)+(1-sigma_2^2)*||A2*x_k+b2||_2^2)]/sigma_2^2
%                        where, sigma_2 is the biggest singular value of A2
%
%  Inputs:
%        A1[m1-by-n],b1[m1-by-1]: objective parameters
%        A2[m2-by-n],b2[m2-by-1]: constraints parameters
%        epsilon [scalar]: constraints threshold
%        max_iter [scalar]: total interations of PGA algorithm
% Outputs:
%         x [n -by-1]: solution of the optimization program
%         alpha [max_iter-by-1]: collect of objective value for PGA iterations


%% optimization parameters


%% solver
                                 
% Initialization
n      = size(A2,2);
X      = zeros(n,max_iter);
X(:,1) = -A2_dagger*b2;

alpha    = zeros(max_iter,1);
alpha(1) = norm(A1*X(:,1)+b1);

lambda_k = zeros(max_iter-1,1);
stop_iter = 0;
for iter = 1:max_iter-1
    x    = X(:,iter);
    
    % search direction (gradient ascent)
    Delta_f = (A1.'*A1)*x + A1.'*b1;   % first derivative of the objective function f
                                       % f = 1/2||A1*x+b1||_2^2
    if norm(Delta_f) >= tol
        vk = Delta_f/norm(Delta_f)+0.01*rand(size(Delta_f));
    else
        vk = zeros(n,1)+0.01*rand(size(Delta_f));
    end
    
    % adjust learning rate to make sure x_plus is still in the convex set ||A2*x_plus+b2||<=epsilon
    if(norm(A2*x+lambda_0*A2*vk+b2) <= epsilon)
        lambda = lambda_0;
    else
        cons = norm(A2*x+b2);
        lambda = (-cons + sqrt(sigma2_max^2*epsilon^2+(1-sigma2_max^2)*cons^2))/sigma2_max^2;
    end
    
    if(~isreal(lambda) || lambda<0)
        stop_iter = iter-1;
        break  % stall when we reach the boundary
    end
    stop_iter = iter;
    lambda_k(iter) = lambda;
    
    % dynamical propogation
    X(:,iter+1)   = x + lambda_k(iter)*vk;    
    alpha(iter+1) = norm(A1*X(:,iter+1)+b1);    
    
end








                        