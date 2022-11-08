%% Simulation for compare PGA performance with different iterations
clear variables
close all
clc

%% simulation parameters
tot = 2000;
num_iter = 50;
Max_iter = round(linspace(100,tot,num_iter));  % iterations of PGA algorithm
run_model


%% Sim
mean_effect_MHFDIA = zeros(num_iter,1);
max_effect_MHFDIA  = zeros(num_iter,1);
min_effect_MHFDIA  = zeros(num_iter,1);
Max_BDD_MHFDIA     = zeros(num_iter,1);
Mean_BDD_MHFDIA    = zeros(num_iter,1);
Min_BDD_MHFDIA     = zeros(num_iter,1);

mean_effect_EIGFDIA = zeros(num_iter,1);
max_effect_EIGFDIA  = zeros(num_iter,1);
min_effect_EIGFDIA  = zeros(num_iter,1);
Max_BDD_EIGFDIA     = zeros(num_iter,1);
Mean_BDD_EIGFDIA    = zeros(num_iter,1);
Min_BDD_EIGFDIA     = zeros(num_iter,1);

N_start_attack = 0.2*N_samples+T;   % start attack injection

parfor idx = 1:num_iter
    max_iter = Max_iter(idx);
    simOut = sim('System_model_discrete');       
           
    time_vec  = simOut.logsout.getElement('x').Values.Time;
    % State vectors
    x           = simOut.logsout.getElement('x').Values.Data; % true states
    x_hat_L2O   = simOut.logsout.getElement('x_hat_L2O').Values.Data;  % Observed states (MHFDIA)
    x_hat_L2O2  = simOut.logsout.getElement('x_hat_L2O2').Values.Data;  % Observed states (MHFDIA)

    BDD_res1   = simOut.logsout.getElement('BDD_res1').Values.Data; % Bad data residue(MHFDIA)
    BDD_res2   = simOut.logsout.getElement('BDD_res2').Values.Data; % Bad data residue (eig FDIA)
    
    % effectiveness
    effect1 = vecnorm(x - x_hat_L2O,2,2)./vecnorm(x,2,2);
    effect1(1:N_start_attack) = 0;
    effect2 = vecnorm(x - x_hat_L2O2,2,2)./vecnorm(x,2,2);
    effect2(1:N_start_attack) = 0;
    
    % BDD Residual
    BDD_res2(1:N_start_attack)=0;
    BDD_res1(1:N_start_attack)=0;
    
    % MH_FDIA
    mean_effect_MHFDIA(idx) = mean(effect1);
    max_effect_MHFDIA(idx) = max(effect1);
    min_effect_MHFDIA(idx) = min(effect1);

    Max_BDD_MHFDIA(idx) = max(BDD_res1);
    Mean_BDD_MHFDIA(idx) = mean(BDD_res1);
    Min_BDD_MHFDIA(idx) = min(BDD_res1);
    
    % Eig_FDIA
    mean_effect_EIGFDIA(idx) = mean(effect2);
    max_effect_EIGFDIA(idx) = max(effect2);
    min_effect_EIGFDIA(idx) = min(effect2);
    
    Max_BDD_EIGFDIA(idx) = max(BDD_res2);
    Mean_BDD_EIGFDIA(idx) = mean(BDD_res2);
    Min_BDD_EIGFDIA(idx) = min(BDD_res2);   
end

save mean_effect_MHFDIA.mat mean_effect_MHFDIA
save max_effect_MHFDIA.mat max_effect_MHFDIA
save min_effect_MHFDIA.mat min_effect_MHFDIA

save Max_BDD_MHFDIA.mat Max_BDD_MHFDIA
save Mean_BDD_MHFDIA.mat Mean_BDD_MHFDIA
save Min_BDD_MHFDIA.mat Min_BDD_MHFDIA

save mean_effect_EIGFDIA.mat mean_effect_EIGFDIA
save max_effect_EIGFDIA.mat max_effect_EIGFDIA
save min_effect_EIGFDIA.mat min_effect_EIGFDIA

save Max_BDD_EIGFDIA.mat Max_BDD_EIGFDIA
save Mean_BDD_EIGFDIA.mat Mean_BDD_EIGFDIA
save Min_BDD_EIGFDIA.mat Min_BDD_EIGFDIA

save Max_Iter.mat Max_iter

    
    
    
