% usage: runtests('testOptimizer')
function tests = testOptimizer
    % Unit test for  all the optimizer routines
    tests = functiontests(localfunctions);
end


%% Tests Setup
function setupOnce(testCase)
    % The test case is build using random A,B,C with T = 10, tau = 0.5;

    % Testing case parameters
    n = 5; 
    m = 11;
    l = 3;
    k = round(.3*m); % number of attacked measurements

    A = rand(n);
    A = A/2/max(abs(eig(A))); % normalizing with 2*abs(lambda_max))
    B = rand(n,l);
    C = rand(m,n);

    T = 7;

    tau = 0.5;

    % TestCase Data
    testCase.TestData.n = n; 
    testCase.TestData.m = m;
    testCase.TestData.l = l;
    testCase.TestData.k = k;

    testCase.TestData.A = A;
    testCase.TestData.B = B;
    testCase.TestData.C = C;

    testCase.TestData.T = T;

    testCase.TestData.tau = tau;

    % Expected results
    testCase.TestData.exp_chi2_m  = chi2inv(tau,m);

    testCase.TestData.exp_Phi_T   = [C;C*A;C*(A^2);C*(A^3);C*(A^4);C*(A^5);C*(A^6)];
    
    testCase.TestData.exp_Theta_T = A^6;

    O = zeros(m,l);
    testCase.TestData.exp_H_T = [O O O O O O;
                                 C*B O O O O O;
                                 C*A*B C*B O O O O;
                                 C*(A^2)*B C*A*B C*B O O O;
                                 C*(A^3)*B C*(A^2)*B C*A*B C*B O O;
                                 C*(A^4)*B C*(A^3)*B C*(A^2)*B C*A*B C*B O;
                                 C*(A^5)*B C*(A^4)*B C*(A^3)*B C*(A^2)*B C*A*B C*B];
                             
    testCase.TestData.exp_G_T = [(A^5)*B (A^4)*B (A^3)*B (A^2)*B A*B B];
end


%% testing solver_call
function test_solver_call(testCase)

    % Test Scenario: 
    %     1. Propagate a known initial state through the dynamics.
    %     2. Collect the output data.
    %     3. Call the solver to recreate the initial condition
    %     4. Compare the result with original initial state
    %     5. Call solver with attacked measurement
    %     6. Compare for the attacked case
    
    
    % unpacking parameters
    A = testCase.TestData.A;
    B = testCase.TestData.B;
    C = testCase.TestData.C;
    
    T = testCase.TestData.T;
    n = testCase.TestData.n; 
    m = testCase.TestData.m;
    l = testCase.TestData.l;
    
    r_tau = testCase.TestData.exp_chi2_m;
    
    %     1. Propagate a known initial state through the dynamics.
    %     2. Collect the output data.
    % generate initial state
    x0 = rand(n,1);  % randomized initial condition
    x  = x0; % initialize dynamical propagation
    y  = [C*x0;zeros(m*(T-1),1)];
    u  = zeros(l*(T-1),1);
    for iter = 1:T-1
        u((iter-1)*l+1:iter*l) = 0.01*ones(l,1);
        x = A*x + B*u((iter-1)*l+1:iter*l);
        y(iter*m+1:(iter+1)*m) = C*x;
    end
    
    
    % Generating surrogate auxiliary model
    Y           = reshape(y,m,T);
    sigma_inv_k = rand(m,1); % surrogate inverse covariance values. Assume diagonal covariance matrix.
    mu_k        = mean(Y,2)/norm(mean(Y,2))*(r_tau/m/max(sigma_inv_k)); % normalized so that ||y-mu_k||_Sigma_inv_k <= r_tau
    Sigma_inv_k  = diag(sigma_inv_k);
    
    
    %     3. Call the solver to recreate the initial condition
    % calling solver
    Phi = testCase.TestData.exp_Phi_T;
    H   = testCase.TestData.exp_H_T;
    z_0 = zeros(n+m*T,1);
    z = solver_call(y,u,mu_k,Sigma_inv_k,z_0,H,Phi,r_tau);
    
    %     4. Compare the result with original initial state
    % extracting and comparing results
    x_hat = z(1:n);
    verifyEqual(testCase,x_hat,x0,'AbsTol',1e-6);
    
    %     5. Call solver with attacked measurement
    %     6. Compare for the attacked case
    % Generating attack vectors
    k = testCase.TestData.k; % number of attacked measurement per time
    y_attack = zeros(m*T,1); % initializing
    for iter = 1:T
        attack_indices = randi(m,k,1); % inidices of attack (maximum = m, size = [k 1])
        y_attack((iter-1)*m+attack_indices) = 1000*rand(k,1); % random attack with maximum 1000 (will try FDIA in simulink)
    end
    y_attacked = y + y_attack;
    
    % calling solver
    z = solver_call(y_attacked,u,mu_k,Sigma_inv_k,z_0,H,Phi,r_tau);
    
    % extracting and comparing results
    x_hat = z(1:n);
    verifyEqual(testCase,x_hat,x0,'AbsTol',1e-6);

end

%% testing opti_params
function test_opti_params(testCase)

    % Unpacking test case parameters
    T   = testCase.TestData.T;

    tau = testCase.TestData.tau;

    % Expected results
    exp_chi2_m = testCase.TestData.exp_chi2_m;

    exp_Phi_T  = testCase.TestData.exp_Phi_T;

    exp_H_T    = testCase.TestData.exp_H_T;
    
    exp_Theta_T    = testCase.TestData.exp_Theta_T;
    
    exp_G_T    = testCase.TestData.exp_G_T;

    % calling opti_params
    A = testCase.TestData.A;
    B = testCase.TestData.B;
    C = testCase.TestData.C;
    [Phi_T,H_T,Theta_T,G_T,chi2_m] = opti_params(A,B,C,T,tau);

    % verify results

    verifyEqual(testCase,Phi_T,exp_Phi_T);
    verifyEqual(testCase,H_T,exp_H_T);
    verifyEqual(testCase,Theta_T,exp_Theta_T);
    verifyEqual(testCase,G_T,exp_G_T);
    verifyEqual(testCase,chi2_m,exp_chi2_m);

end