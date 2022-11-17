%% plotting file for perform vs num of attacks
run_model;

%% load data
tot =19;

Mean_effect = zeros(tot,1);
Max_effect = zeros(tot,1);
Min_effect = zeros(tot,1);
Mean_BDD = zeros(tot,1);
Max_BDD = zeros(tot,1);
Min_BDD = zeros(tot,1);

for idx = 2:tot
    dir_simout = "sim_out/"+ num2str(idx)+"/sim_out.mat";
    load(dir_simout);

    n_sample = length(simOut);

    mean_effect_MHFDIA = zeros(n_sample,1);
    max_effect_MHFDIA = zeros(n_sample,1);
    min_effect_MHFDIA = zeros(n_sample,1);
    Max_BDD_MHFDIA = zeros(n_sample,1);
    Mean_BDD_MHFDIA = zeros(n_sample,1);
    Min_BDD_MHFDIA = zeros(n_sample,1);

    x          = simOut(1,1).logsout.getElement('x').Values.Data; % true states

    for iter = 1:n_sample
        
%         if idx == 1
%             time_vec  = simOut(iter,1).logsout.getElement('x2').Values.Time;
%             x          = simOut(iter,1).logsout.getElement('x2').Values.Data; % true states
%             x_hat_L2O  = simOut(iter,1).logsout.getElement('x_hat_L2O2').Values.Data;  % Observed states (MHFDIA)
%             BDD_res1   = simOut(iter,1).logsout.getElement('BDD_res2').Values.Data; % Bad data residue(MHFDIA)
%         else
%             time_vec  = simOut(iter,1).logsout.getElement('x').Values.Time;
%             x          = simOut(iter,1).logsout.getElement('x').Values.Data; % true states
%             x_hat_L2O  = simOut(iter,1).logsout.getElement('x_hat_L2O').Values.Data;  % Observed states (MHFDIA)
%             BDD_res1   = simOut(iter,1).logsout.getElement('BDD_res1').Values.Data; % Bad data residue(MHFDIA)
%         end
        
        time_vec  = simOut(iter,1).logsout.getElement('x').Values.Time;
        x_hat_L2O  = simOut(iter,1).logsout.getElement('x_hat_L2O').Values.Data;  % Observed states (MHFDIA)
        BDD_res1   = simOut(iter,1).logsout.getElement('BDD_res1').Values.Data; % Bad data residue(MHFDIA)

%         mean_effect_MHFDIA(iter) = mean(vecnorm(x(time_vec>T_start_attack)-x_hat_L2O(time_vec>T_start_attack),2,2)./vecnorm(x(time_vec>T_start_attack),2,2));
%         max_effect_MHFDIA(iter) = max(vecnorm(x(time_vec>T_start_attack)-x_hat_L2O(time_vec>T_start_attack),2,2)./vecnorm(x(time_vec>T_start_attack),2,2));
%         min_effect_MHFDIA(iter) = min(vecnorm(x(time_vec>T_start_attack)-x_hat_L2O(time_vec>T_start_attack),2,2)./vecnorm(x(time_vec>T_start_attack),2,2));

        mean_effect_MHFDIA(iter) = mean(vecnorm(x(time_vec>T_start_attack)-x_hat_L2O(time_vec>T_start_attack),2,2));
        max_effect_MHFDIA(iter) = max(vecnorm(x(time_vec>T_start_attack)-x_hat_L2O(time_vec>T_start_attack),2,2));
        min_effect_MHFDIA(iter) = min(vecnorm(x(time_vec>T_start_attack)-x_hat_L2O(time_vec>T_start_attack),2,2));
        
        Max_BDD_MHFDIA(iter) = max(BDD_res1(time_vec>T_start_attack));
        Mean_BDD_MHFDIA(iter) = mean(BDD_res1(time_vec>T_start_attack));
        Min_BDD_MHFDIA(iter) = min(BDD_res1(time_vec>T_start_attack));
    end
    Max_effect(idx) = max(max_effect_MHFDIA);
    Mean_effect(idx) = mean(mean_effect_MHFDIA);
    Min_effect(idx) = min(min_effect_MHFDIA);

    Max_BDD(idx) = max(Max_BDD_MHFDIA);
    Mean_BDD(idx) = mean(Mean_BDD_MHFDIA);
    Min_BDD(idx) = min(Min_BDD_MHFDIA); 
end

Max_effect = Max_effect(2:end);
Mean_effect = Mean_effect(2:end);
Min_effect = Min_effect(2:end);

Max_BDD = Max_BDD(2:end);
Mean_BDD = Mean_BDD(2:end);
Min_BDD = Min_BDD(2:end);

% x axis
N_attack = linspace(2,n_meas,n_meas-1);
N_Attack2 = [N_attack, fliplr(N_attack)];

LW = 1.5;  % linewidth
FS = 15;   % font size

%% plotting
figure,
subplot(1,2,1)
plot(N_attack,Mean_effect,'k','LineWidth',LW)
ylabel('Eeffectiveness','FontWeight','bold')
xlabel('Num of Attacks')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)

inbetween_yc = [Max_effect.', fliplr(Min_effect.')];
hold on, h1 = fill(N_Attack2,inbetween_yc,'k');
set(h1,'facealpha',.3)
xlim([1,n_meas])

subplot(1,2,2)
plot(N_attack,Mean_BDD,'k','LineWidth',LW)
ylabel('Stealthiness','FontWeight','bold')
xlabel('Num of Attacks')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)

inbetween_r = [Max_BDD.', fliplr(Min_BDD.')];
hold on, h2 = fill(N_Attack2,inbetween_r,'k');
set(h2,'facealpha',.3)
xlim([1,n_meas])

hold on,
plot(N_attack,T1*BDD_thresh*ones(length(N_attack),1),'r--','LineWidth',2*LW);
