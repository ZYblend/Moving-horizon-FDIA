%% Creating visualization and plotting results for the simulation
% Plotting the following results:
%      1. The comparison among "target path", "estimated path without attack", "estimated path with attack"
%      2. The effectiveness
%      3. The velocity estimation error after attacks are injected
%      4. Bad Data Detection Results
%
% Author: Yu Zheng, Florida State University
% Date  : 11/11/2022



%% Extracting values
time_vec  = out.logsout.getElement('x').Values.Time;

% State vectors
x     = out.logsout.getElement('x').Values.Data; % 
y     = out.logsout.getElement('y').Values.Data;  % 
theta = out.logsout.getElement('theta').Values.Data; % 

x_t     = out.logsout.getElement('x_target').Values.Data; % 
y_t     = out.logsout.getElement('y_target').Values.Data;  % 
theta_t = out.logsout.getElement('theta_target').Values.Data; % 

x_est     = out.logsout.getElement('x_est').Values.Data; % 
y_est     = out.logsout.getElement('y_est').Values.Data;  % 
theta_est = out.logsout.getElement('theta_est').Values.Data; % 

v = out.logsout.getElement('v').Values.Data; %
w = out.logsout.getElement('w').Values.Data; %

v_t = out.logsout.getElement('desired_v').Values.Data; %
w_t = out.logsout.getElement('desired_w').Values.Data; %

v_hat = out.logsout.getElement('v_estimated').Values.Data; %
w_hat = out.logsout.getElement('w_estimated').Values.Data; %

BDD_res2 = out.logsout.getElement('BDD_res2').Values.Data; %BDD_res2

%% Ploting/Visualization/Metric tables
LW = 1.5;  % linewidth
FS = 15;   % font size

T_start_attack = .2*T_final;
Ts = 0.01;
N_start_attack = round(T_start_attack/Ts);


%% path comparison
real = [theta,x,y];
target = [theta_t,x_t,y_t];
effect = vecnorm(real-target,2,2)./vecnorm(real,2,2);
effect(1:N_start_attack)=0;

figure,
plot(x_t,y_t,'y-','LineWidth',5*LW)
hold on, plot(x,y,'k-','LineWidth',2*LW)
hold on, plot(x_est,y_est,'r-.','LineWidth',LW)
hold on, plot(x_est(4000),y_est(4000),'ro','LineWidth',LW)
xlabel('x','FontWeight','bold')
ylabel('y','FontWeight','bold')
title('Path-tracking Performance');
set(gca,'fontweight','bold','fontsize',15) 
set(gca,'LineWidth',LW)
legend('Target', 'No attack', 'Attacked')
xlim([-1,1.5])

% effectiveness on path value
figure,
plot(time_vec,effect,'k','LineWidth',LW)
% ylabel('\alpha','FontWeight','bold')
title('Effectiveness');
set(gca,'fontweight','bold','fontsize',15) 
set(gca,'LineWidth',LW)


%% velocity estimation comparison
figure,
% subplot(2,3,1)
% plot(time_vec,v_t,'k','LineWidth',LW);
% title("Target")
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)

subplot(1,2,1)
plot(time_vec,v_hat-v,'k','LineWidth',LW);
title("Error of v with attack")
ylabel('e_v')
xlabel('Time')
% xline(T_start_attack,'r--')
% legend('','Attack Injection')
set(gca,'fontweight','bold','fontsize',15) 
set(gca,'LineWidth',LW)

% subplot(2,2,2)
% plot(time_vec,v_hat-v_t,'k','LineWidth',LW);
% title('Attacked')
% xline(T_start_attack,'r--')
% xlabel('Time')
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)

% subplot(2,3,4)
% plot(time_vec,w_t,'k','LineWidth',LW);
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)
% ylabel('\omega')

subplot(1,2,2)
plot(time_vec,w_hat-w,'k','LineWidth',LW);
title('Error of \omega with attack')
ylabel('e_{\omega}')
xlabel('Time')
xline(T_start_attack,'r--')
set(gca,'fontweight','bold','fontsize',15) 
set(gca,'LineWidth',LW)

% subplot(2,2,4)
% plot(time_vec,w_hat,'k','LineWidth',LW);
% xlabel('Time')
% xline(T_start_attack,'r--')
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)



%% BDD_res
BDD_res2(time_vec<=T_start_attack)=0;
% BDD_res1(1:N_start_attack)=0;

figure
plot(time_vec,BDD_res2,'k','LineWidth',LW)
hold on, plot(time_vec,BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
ylabel('Stealthiness','FontWeight','bold')
set(gca,'fontweight','bold','fontsize',15) 
set(gca,'LineWidth',LW)
title('BDD Residual')

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
    
