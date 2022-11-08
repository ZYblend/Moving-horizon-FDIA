%% Test file for projected gradient ascent (PGA) solver with QCQP projection program
clear
clc
close all

%% test PGA_solver2

% problem parameters
m1 = 10;
m2 = 361;
n = 4;
b1 = zeros(m1,1);
A1 = rand(m1,n);
b2 = zeros(m2,1);
A2 = rand(m2,n);

[U2,S2,V2] = svd(A2);
U22        = U2(:,n+1:end);
U21        = U2(:,1:n);
S2         = S2(1:n,1:n);
sigma2_max = S2(1,1);   % biggest singular value of A2
A2_dagger  = V2*(S2\(U21.'));

eps_slack = 0.5;
epsilon = norm(U22.'*b2) + eps_slack ;

% algorithm parameters
lambda_0 = 1e-3;
max_iter = 500;
tol      = 1e-6;

[alpha,X,lambda_history,stop_iter] = PGA_solver2(A1,A2,b1,b2,A2_dagger,sigma2_max,epsilon,lambda_0,max_iter,tol);
plot_iter = stop_iter+1;

figure, plot(alpha(1:plot_iter));
title('\alpha_k history')

norm_cons = sqrt(sum((A2*X(:,1:plot_iter)+repmat(b2,1,plot_iter)).^2,1));
figure, 
subplot(211), plot(lambda_history(1:plot_iter-1));
title('\lambda_k histrory')
subplot(212), plot(norm_cons,'*'), hold on, plot(epsilon*ones(1,plot_iter));
title('boundary tracking')


%% a more comprehensive test
n_cases = 100;
m1 = round(linspace(1,100,n_cases));
m2 = round(linspace(102,200,n_cases));
n = round(linspace(1,100,n_cases));
m1 = m1(randperm(length(m1)));
m2 = m2(randperm(length(m2)));
n = n(randperm(length(n)));

n_iteration = 1;
max_iter = 1000;    % number of iterations of PGA
Alpha = cell(1,n_iteration);
alpha = zeros(max_iter,n_cases);

for iter = 1:n_iteration
    parfor i_cases = 1:n_cases
        b1 = rand(m1(i_cases),1);
        A1 = rand(m1(i_cases),n(i_cases));
        b2 = rand(m2(i_cases),1);
        A2 = rand(m2(i_cases),n(i_cases));
        
        [U2,S2,V2] = svd(A2);
        U22 = U2(:,n(i_cases)+1:end);
        
        epsilon = norm(U22.'*b2)+5;

        [alpha(:,i_cases),~] = PGA_solver2(A1,A2,b1,b2,epsilon,max_iter);
    end
    Alpha(iter) = {alpha};
end

% check if there is non-increase cases on alpha
flag = zeros(n_cases,1);
Flag = cell(1,n_iteration);
for cell_idx = 1:n_iteration
    alpha = Alpha{1,cell_idx};
    parfor idx = 1:n_cases
        alpha_diff = diff(alpha(:,idx));
        flag(idx) = all(alpha_diff>=0);
    end
    Flag(cell_idx) = {flag};
end





















