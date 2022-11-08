%% Simulation for compare PGA performance with different iterations
clear variables
close all
clc

%% simulation parameters
tot = 19;
N_Attack = round(linspace(1,tot,tot));
Copy_of_run_model


%% Sim
% 1) Load model and initialize the pool.
% parpool;
model = 'System_model_discrete';
load_system(model);

% Build the Rapid Accelerator target
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

% 2) Set up the iterations that we want to compute.
mean_effect_MHFDIA = zeros(tot,1);
max_effect_MHFDIA = zeros(tot,1);
min_effect_MHFDIA = zeros(tot,1);
Max_BDD_MHFDIA = zeros(tot,1);
Mean_BDD_MHFDIA = zeros(tot,1);
Min_BDD_MHFDIA = zeros(tot,1);

parfor idx = 1:tot
    n_attack = N_Attack(idx);
    I_attack_ini = I_attack_ini_all{1,idx};
    e_ini_matrix = e_ini_matrix_all{1,idx};
    
    simOut{idx} = sim(model,'SimulationMode', 'rapid',...
                       'RapidAcceleratorUpToDateCheck', 'off',...
                       'SaveTime', 'on',...
                       'StopTime', num2str(10*idx));     
           
    time_vec  = simOut{idx}.logsout.getElement('x').Values.Time;
    x          = simOut{idx}.logsout.getElement('x').Values.Data; % true states
    x_hat_L2O  = simOut{idx}.logsout.getElement('x_hat_L2O').Values.Data;  % Observed states (MHFDIA)
    BDD_res1   = simOut{idx}.logsout.getElement('BDD_res1').Values.Data; % Bad data residue(MHFDIA)
    
    mean_effect_MHFDIA(idx) = mean(vecnorm(x-x_hat_L2O,2,2));
    max_effect_MHFDIA(idx) = max(vecnorm(x-x_hat_L2O,2,2));
    min_effect_MHFDIA(idx) = min(vecnorm(x-x_hat_L2O,2,2));
    
    Max_BDD_MHFDIA(idx) = max(BDD_res1);
    Mean_BDD_MHFDIA(idx) = mean(BDD_res1);
    Min_BDD_MHFDIA(idx) = min(BDD_res1);
end
    
    
    
