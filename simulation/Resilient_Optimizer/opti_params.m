function [Phi_T,H_T,Theta_T,G_T] = opti_params(A,B,C,T)
% [Phi_T,H_T,Theta_T,G_T,chi2_m] = opti_params(A,B,C,T,tau)
%     Calculates the parameter for the optimization problem:
%        min:  ||y - H_T*u - Phi_T*x||_1
%        s.t:  ||Phi__T*x + H__T*u - mu_k||^2_Sigma_inv_k <= chi^2_m(tau)
%
% Input:
%   - A [n-by-n]          : System dynamic matrix
%   - B [n-by-l]          : System dynamic input matrix
%   - C [m-by-n]          : System dynamic output matrix
%   - T [Scalar (T>=n)]   : Observer receding horizon
%   - tau[Scalar 0<tau<1] : reliability level for the auxiliary model 
%                           chance constraint
%   
% Output:
%   - Phi_T [m*T-by-n]       : observer state-ouput linear map 
%                              (Phi__T is the last m-rows of Phi_T)
%   - H_T   [m*T-by-l*(T-1)] : observer input-output linear map
%                               (H__T is the last m-rows of H_T)
%   - Theta_T [n-by-n]       : Observer state-state propagation matrix
%                              Used for propagating the argmin value to the
%                              estimated state at the current instant
%   - G_T [m-by-l*(T-1)]     : Observer input-state propagation matrix
%                              Used for propagating the argmin value to the
%                              estimated state at the current instant
%   - chi2_m [Scalar]        : The value of the RHS for the quadratic
%                              inequality constraint 
%   

% Olugbenga Moses Anubi 2020

%% Extracting relevant sizes
[m,n] = size(C);   % m = number of measured outputs, n = number of states
l     = size(B,2); % number of inputs


%% Calculating Phi_T

% initializing
Phi_T   = zeros(m*T,n);  
Theta_T = mpower(A,T-1);

% building the body of Phi_T
for iter = 1:T
    Phi_T(m*(iter-1)+1:m*iter,:) = C*mpower(A,iter-1);
end


%% Calculating H_T

% initializing
H_T = zeros(m*T,l*(T-1));
G_T = zeros(n,l*(T-1));

% building the body of H_T
for iter_1 = 1:T-1
    for iter_2 = 1:iter_1
        row_indices = m*(iter_1)+1:m*(iter_1+1);
        col_indices = l*(iter_2-1)+1:l*(iter_2);
        
        H_T(row_indices,col_indices) = C*mpower(A,iter_1-iter_2)*B;
        
        if(iter_1>=T-1)
            G_T(:,col_indices) = mpower(A,iter_1-iter_2)*B;
        end
    end
end

end