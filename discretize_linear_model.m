function [A_d,B_d] = discretize_linear_model(A,B,T)
%% Discretizer
% Discretizers a linear model given a sample time (T)
%   x_(k+1) = A_d * x_k * B_d * u_k

n = size(A,1);
A_d = expm(A*T);
B_d = 0.5*T*(A_d+eye(n))*B;