%% plot results for static FDIA comparison

%% Extracting values
time_vec  = out.logsout.getElement('x_hat_L2O').Values.Time;

% State vectors
x          = load('x.mat').x; % true states
x_hat_L2O  = out.logsout.getElement('x_hat_L2O').Values.Data;  % Observed states (Eig-MHFDIA)
x_hat_L2O2 = out.logsout.getElement('x_hat_L2O2').Values.Data; % Observed states (PGA-MHFDIA)

BDD_res1        = out.logsout.getElement('BDD_res1').Values.Data; % Bad data residue(Eig-MHFDIA)
BDD_res2        = out.logsout.getElement('BDD_res2').Values.Data; % Bad data residue (MHFDIA)


%% Ploting/Visualization/Metric tables

%% 1. delta estimates
n_delta = size(x,2)/2;  % number of generator angles


LW = 1.5;  % linewidth
FS = 15;   % font size

%% effectiveness
effect1 = vecnorm(x - x_hat_L2O,2,2);
effect2 = vecnorm(x - x_hat_L2O2,2,2);

figure,
subplot(2,2,1)
plot(time_vec,effect2*100,'k','LineWidth',LW)
ylabel('Effectiveness','FontWeight','bold')
title('FDIA (Proposed)');
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])


subplot(2,2,2)
plot(time_vec,effect1*100,'k','LineWidth',LW)
% ylabel('\alpha','FontWeight','bold')
title('FDIA (literature)');
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])

N_start_attack = 0.2*N_samples+T;
BDD_res2(1:N_start_attack)=0;
BDD_res1(1:N_start_attack)=0;
%% BDD_res
subplot(2,2,3)
plot(time_vec,BDD_res2,'k','LineWidth',LW), hold on
plot(time_vec,BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
ylabel('Stealthiness','FontWeight','bold')
xlabel('time','FontWeight','bold')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])

subplot(2,2,4)
plot(time_vec,BDD_res1,'k','LineWidth',LW), hold on
plot(time_vec,BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
% ylabel('Bad Data Detection Residual','FontWeight','bold')
% title('MH-L2-FDIA')
xlabel('time','FontWeight','bold')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])


%% static design could be detected by the moving-horizon setup
x_hat_MH = out.logsout.getElement('x_hat_MH').Values.Data; % Observed states 
BDD_res_MH = out.logsout.getElement('BDD_res_MH').Values.Data; % Bad data residue

effect = vecnorm(x - x_hat_MH,2,2)/vecnorm(x,2,2);


figure,
subplot(1,2,1)
plot(time_vec,effect*100,'k','LineWidth',LW)
xlabel('time','FontWeight','bold')
ylabel('Effectiveness','FontWeight','bold')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])

subplot(1,2,2)
plot(time_vec,BDD_res_MH,'k','LineWidth',LW), hold on
plot(time_vec,BDD_thresh*T*ones(length(time_vec),1),'r--','LineWidth',2*LW)
ylabel('Stealthiness','FontWeight','bold')
xlabel('time','FontWeight','bold')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])
