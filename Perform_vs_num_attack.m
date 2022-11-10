%% Simulation for compare PGA performance with different iterations
clear all
close all
clc

%% common params
run_model;


%% simulation parameters
tot = 19;
N_Attack = round(linspace(1,tot,tot));
n_sample = 50;


%% Sim
% 1) Load model and initialize the pool.
% parpool;
model = 'System_model_discrete';
load_system(model);

% Build the Rapid Accelerator target
Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

% 2) Set up the iterations that we want to compute.


for idx = 2:tot

    % simulation inputs
    sim_inp = repmat(Simulink.SimulationInput(model),n_sample,1);
    for iter = 1:n_sample
        % load simulation params
        run_model_for_perform_vs_num_attack;

        sim_inp(iter) = sim_inp(iter).setVariable('A_bar_d',A_bar_d);
        sim_inp(iter) = sim_inp(iter).setVariable('B_bar_d',B_bar_d);
        sim_inp(iter) = sim_inp(iter).setVariable('C_obsv_d',C_obsv_d);
        sim_inp(iter) = sim_inp(iter).setVariable('D_obsv_d',D_obsv_d);
        sim_inp(iter) = sim_inp(iter).setVariable('n_gen',n_gen);
        sim_inp(iter) = sim_inp(iter).setVariable('n_bus',n_bus);
        sim_inp(iter) = sim_inp(iter).setVariable('n_meas',n_meas);
        sim_inp(iter) = sim_inp(iter).setVariable('n_states',n_states);
        sim_inp(iter) = sim_inp(iter).setVariable('n',n);
        sim_inp(iter) = sim_inp(iter).setVariable('l',l);
        sim_inp(iter) = sim_inp(iter).setVariable('load_buses',load_buses);
        sim_inp(iter) = sim_inp(iter).setVariable('T_final',T_final);
        sim_inp(iter) = sim_inp(iter).setVariable('T_sample',T_sample);
        sim_inp(iter) = sim_inp(iter).setVariable('T_start_opt',T_start_opt);
        sim_inp(iter) = sim_inp(iter).setVariable('T_start_attack',T_start_attack);
        sim_inp(iter) = sim_inp(iter).setVariable('BDD_thresh',BDD_thresh);
        sim_inp(iter) = sim_inp(iter).setVariable('U0',U0);
        sim_inp(iter) = sim_inp(iter).setVariable('Y0',Y0);
        sim_inp(iter) = sim_inp(iter).setVariable('x0',x0);
        sim_inp(iter) = sim_inp(iter).setVariable('x0_hat',x0_hat);
        sim_inp(iter) = sim_inp(iter).setVariable('L_obsv',L_obsv);


        sim_inp(iter) = sim_inp(iter).setVariable('PhiT',PhiT);
        sim_inp(iter) = sim_inp(iter).setVariable('HT',HT);
        sim_inp(iter) = sim_inp(iter).setVariable('T',T);
        sim_inp(iter) = sim_inp(iter).setVariable('T1',T1);
        sim_inp(iter) = sim_inp(iter).setVariable('I',I);  % attack support

        sim_inp(iter) = sim_inp(iter).setVariable('Theta_T',Theta_T);
        sim_inp(iter) = sim_inp(iter).setVariable('G_T',G_T);

        sim_inp(iter) = sim_inp(iter).setVariable('Ue11',Ue11);
        sim_inp(iter) = sim_inp(iter).setVariable('Ue12',Ue12);
        sim_inp(iter) = sim_inp(iter).setVariable('Se1',Se1);

        sim_inp(iter) = sim_inp(iter).setVariable('A1',A1);
        sim_inp(iter) = sim_inp(iter).setVariable('A2',A2);
        sim_inp(iter) = sim_inp(iter).setVariable('b1p',b1p);
        sim_inp(iter) = sim_inp(iter).setVariable('b2p',b2p);
        sim_inp(iter) = sim_inp(iter).setVariable('max_iter',max_iter);

        sim_inp(iter) = sim_inp(iter).setVariable('n_attack',N_Attack(idx));
        sim_inp(iter) = sim_inp(iter).setVariable('I_attack_ini',I_attack_ini);
        sim_inp(iter) = sim_inp(iter).setVariable('e_ini_matrix',e_ini_matrix);
    end

    simOut = parsim(sim_inp);  

    dir_simout = "sim_out/"+ num2str(idx)+"/sim_out.mat";
    save(dir_simout,'simOut','-v7.3');
           
end
    
    
    
