%% Creating visualization and plotting results for the simulation



%% Extracting values
time_vec  = out.logsout.getElement('x').Values.Time;

% State vectors
x         = out.logsout.getElement('x').Values.Data; % true states
x_hat_L2O  = out.logsout.getElement('x_hat_L2O').Values.Data;  % Observed states (PGA-MHFDIA)
x_hat_L2O2 = out.logsout.getElement('x_hat_L2O2').Values.Data; % Observed states (Eig-MHFDIA)

BDD_res1        = out.logsout.getElement('BDD_res1').Values.Data; % Bad data residue(MHFDIA)
BDD_res2        = out.logsout.getElement('BDD_res2').Values.Data; % Bad data residue (Eig-MHFDIA)


%% Ploting/Visualization/Metric tables

%% 1. delta estimates
n_delta = size(x,2)/2;  % number of generator angles


LW = 1.5;  % linewidth
FS = 15;   % font size

N_start_attack = 0.2*N_samples+T;   % start attack injection

%% effectiveness
effect1 = vecnorm(x - x_hat_L2O,2,2);
effect1(1:N_start_attack)=0;
BDD_res1(1:N_start_attack)=0;
effect2 = vecnorm(x - x_hat_L2O2,2,2);
effect2(1:N_start_attack)=0;


figure,
subplot(2,2,1)
plot(time_vec,effect1,'k','LineWidth',LW)
ylabel('Effectiveness','FontWeight','bold')
title('MH-PGA-FDIA');
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([1 8])
ylim([0,0.06])

subplot(2,2,2)
plot(time_vec,effect2,'k','LineWidth',LW)
% ylabel('\alpha','FontWeight','bold')
title('MH-Eig-FDIA');
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([1 8])
ylim([0,0.06])

%% BDD_res
BDD_res2(1:N_start_attack)=0;
BDD_res1(1:N_start_attack)=0;

subplot(2,2,3)
plot(time_vec,BDD_res1,'k','LineWidth',LW), hold on
plot(time_vec,T1*BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
ylabel('Stealthiness','FontWeight','bold')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])

subplot(2,2,4)
plot(time_vec,BDD_res2,'k','LineWidth',LW), hold on
plot(time_vec,T1*BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
% ylabel('Bad Data Detection Residual','FontWeight','bold')
% title('MH-L2-FDIA')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
xlim([0 8])

% %% Error table
% error_LO = x - x_hat_LO;
% error_LO_delta = error_LO(:,1:n_delta).'; % NOTE THE TRANSPOSE
% 
% error_L1O = x - x_hat_L1O;
% error_L1O_delta = error_L1O(:,1:n_delta).';% NOTE THE TRANSPOSE
% 
% error_MMO = x - x_hat_MMO;
% error_MMO_delta = error_MMO(:,1:n_delta).';% NOTE THE TRANSPOSE
% 
% metric_rms = @(x,dim) sqrt(sum(x.^2,dim)/size(x,dim));
% metric_max = @(x,dim) max(abs(x),[],dim);
% error_table = [metric_rms(error_LO_delta,2) metric_rms(error_L1O_delta,2) metric_rms(error_MMO_delta,2) ...
%                metric_max(error_LO_delta,2) metric_max(error_L1O_delta,2) metric_max(error_MMO_delta,2)];

% yI = zeros(801-20,20*19);
% for iter=20:801
%     y_temp = y(iter-19:iter,:);
%     yI(iter,:) = y_temp(:).';
% end
    
