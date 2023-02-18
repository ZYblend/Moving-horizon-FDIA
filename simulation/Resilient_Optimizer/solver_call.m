function [z] = solver_call(y,u,mu_k,Sigma_inv_k,z_0,H,Phi,r_tau)
%% Function description comments

% Olugbenga Moses Anubi Jan 2020

%% Unpacking vector sizes
n  = size(Phi,2);  % the number of states
mT = length(y); % length of measured outputs over the entire receding horizon
m  = length(mu_k); % number of instantteneous measured output

%% Solver Parameters
% objective functions parameter
c = [zeros(n,1);  % coefficient of x
     ones(mT,1)   % coefficient of eta
     ];
 

 % Linear inequality constraints
 A_in = [-Phi -eye(mT);
          Phi -eye(mT)];
 
 b_in = [-y+H*u;
         y-H*u];


     
 % Quadratic inequality
 Phi_T = Phi(end-m+1:end,:);
 H_T   = H(end-m+1:end,:);
 
 Q = Phi_T.'*Sigma_inv_k*Phi_T;
 p = 2*((H_T*u-mu_k).'*Sigma_inv_k*Phi_T).';
 r = r_tau - (H_T*u-mu_k).'*Sigma_inv_k*(H_T*u-mu_k);
 
 
 
 %% Calling solver (fmincon): Switch later to a more dire ipopt call
 
 % Options:
 %   - Specify gradient function (objecive and contraints)
 %   - Specify hessian 
 options = optimoptions(@fmincon,'Algorithm','interior-point',...
    'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,...
    'HessianFcn',@(z,lambda)hessian(z,lambda,Q,n),'OptimalityTolerance',1e-20);

 % Anonymous functions for objection and quadratic constraints
 obj_fun        = @(z) obj(z,c);
 nonlin_con_fun = @(z) quad_constr(z,Q,p,r,n);
 
 
 % calling fmincon
 z = fmincon(obj_fun,z_0,A_in,b_in,[],[],[],[],nonlin_con_fun,options);
 
 
 
end
 
 %% Utility functions
 
 % Objection function
 function [J, grad_J] = obj(z,c)
     J = c.'*z;

     if nargout > 1
         grad_J = c;
     end
 end
 % Quadratic Constraint
 function [y,yeq,grad_y,grad_yeq] = quad_constr(z,Q,p,r,n)
     y   = z(1:n).'*Q*z(1:n) + p.'*z(1:n) - r;
     yeq = [];
     
     if nargout > 2
         grad_y      = zeros(size(z));
         grad_y(1:n) = 2*Q*z(1:n) + p;
         grad_yeq    = [];
     end      
 end
 % Hessian
 function H = hessian(z,lambda,Q,n)
     H          = zeros(length(z));
     H(1:n,1:n) = 2*lambda.ineqnonlin(1)*Q;
 end