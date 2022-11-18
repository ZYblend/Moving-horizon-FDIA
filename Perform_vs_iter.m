%% Simulation for compare PGA performance with different iterations
clear variables
close all
clc

%% simulation parameters
tot = 20000;
num_iter = 50;
Max_iter = round(linspace(100,tot,num_iter));  % iterations of PGA algorithm
run_model
% 
% model = 'System_model_discrete';
% load_system(model);
% Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);


%% Sim
Mean_effect_MHFDIA = zeros(num_iter,1);
Max_effect_MHFDIA  = zeros(num_iter,1);
Min_effect_MHFDIA  = zeros(num_iter,1);
Max_BDD_MHFDIA     = zeros(num_iter,1);
Mean_BDD_MHFDIA    = zeros(num_iter,1);
Min_BDD_MHFDIA     = zeros(num_iter,1);

N_start_attack = 0.2*N_samples+T;   % start attack injection

for idx = 1:num_iter
    max_iter = Max_iter(idx);
    simOut = sim('System_model_discrete');       
           
    time_vec  = simOut.logsout.getElement('x').Values.Time;
    % State vectors
    x           = simOut.logsout.getElement('x').Values.Data; % true states
    x_hat_L2O   = simOut.logsout.getElement('x_hat_L2O').Values.Data;  % Observed states (MHFDIA)
%     x_hat_L2O2  = simOut.logsout.getElement('x_hat_L2O2').Values.Data;  % Observed states (eig FDIA)

    BDD_res1   = simOut.logsout.getElement('BDD_res1').Values.Data; % Bad data residue(MHFDIA)
%     BDD_res2   = simOut.logsout.getElement('BDD_res2').Values.Data; % Bad data residue (eig FDIA)
    
    % effectiveness
    effect1 = vecnorm(x - x_hat_L2O,2,2);
    effect1(1:N_start_attack) = 0;
%     effect2 = vecnorm(x - x_hat_L2O2,2,2);
%     effect2(1:N_start_attack) = 0;
    
    % BDD Residual
%     BDD_res2(1:N_start_attack)=0;
    BDD_res1(1:N_start_attack)=0;
    
    % MH_FDIA
    Mean_effect_MHFDIA(idx) = mean(effect1);
    Max_effect_MHFDIA(idx) = max(effect1);
    Min_effect_MHFDIA(idx) = min(effect1);

    Max_BDD_MHFDIA(idx) = max(BDD_res1);
    Mean_BDD_MHFDIA(idx) = mean(BDD_res1);
    Min_BDD_MHFDIA(idx) = min(BDD_res1);
     
end

save('sim_out/effect.mat', 'Mean_effect_MHFDIA', 'Max_effect_MHFDIA', 'Min_effect_MHFDIA', '-v7.3')

save('sim_out/stealth.mat', 'Mean_BDD_MHFDIA', 'Max_BDD_MHFDIA', 'Min_BDD_MHFDIA', '-v7.3')

save sim_out/Max_Iter.mat Max_iter

    
    
    
