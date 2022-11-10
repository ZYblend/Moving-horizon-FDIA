%% Creating visualization and plotting results for the simulation



%% Extracting values
time_vec  = out.logsout.getElement('x').Values.Time;

% State vectors
x     = out.logsout.getElement('x').Values.Data; % 
y     = out.logsout.getElement('y').Values.Data;  % 
theta = out.logsout.getElement('theta').Values.Data; % 

x_t     = out.logsout.getElement('x_target').Values.Data; % 
y_t     = out.logsout.getElement('y_target').Values.Data;  % 
theta_t = out.logsout.getElement('theta_target').Values.Data; % 


%% Ploting/Visualization/Metric tables
LW = 1.5;  % linewidth
FS = 15;   % font size

T_start_attack = .2*T_final;
Ts = 0.01;
N_start_attack = round(T_start_attack/Ts);


%% effectiveness
real = [theta,x,y];
target = [theta_t,x_t,y_t];
effect = vecnorm(real-target,2,2)./vecnorm(real,2,2);
effect(1:N_start_attack)=0;

figure,
plot(x_t,y_t,'r--','LineWidth',LW)
hold on, plot(x,y,'k-','LineWidth',LW)
xlabel('x','FontWeight','bold')
ylabel('y','FontWeight','bold')
title('Path-tracking Performance');
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)

figure,
plot(time_vec,effect,'k','LineWidth',LW)
% ylabel('\alpha','FontWeight','bold')
title('Effectiveness');
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)
% xlim([1 8])
% ylim([0,0.002])

% %% BDD_res
% BDD_res2(1:N_start_attack)=0;
% BDD_res1(1:N_start_attack)=0;
% 
% subplot(2,2,3)
% plot(time_vec,BDD_res1,'k','LineWidth',LW), hold on
% plot(time_vec,T1*BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
% ylabel('Stealthiness','FontWeight','bold')
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)
% xlim([0 8])
% 
% subplot(2,2,4)
% plot(time_vec,BDD_res2,'k','LineWidth',LW), hold on
% plot(time_vec,T1*BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
% % ylabel('Bad Data Detection Residual','FontWeight','bold')
% % title('MH-L2-FDIA')
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)
% xlim([0 8])

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
    
