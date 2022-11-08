%% plotting file for perform vs num of attacks


%% load data

% load mean_effect_MHFDIA.mat
% load max_effect_MHFDIA.mat
% load min_effect_MHFDIA.mat
% 
% load Max_BDD_MHFDIA.mat
% load Mean_BDD_MHFDIA.mat
% load Min_BDD_MHFDIA.mat
% 
% load N_Attack.mat

N_Attack2 = [N_Attack, fliplr(N_Attack)];
BDD_thresh = 0.05;


LW = 1.5;  % linewidth
FS = 15;   % font size

%% plotting
figure,
subplot(1,2,1)
plot(N_Attack,mean_effect_MHFDIA,'k','LineWidth',LW)
ylabel('Eeffectiveness','FontWeight','bold')
xlabel('Num of Attacks')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)

inbetween_yc = [max_effect_MHFDIA.', fliplr(min_effect_MHFDIA.')];
hold on, h1 = fill(N_Attack2,inbetween_yc,'k');
set(h1,'facealpha',.3)
xlim([1,19])

subplot(1,2,2)
plot(N_Attack,Mean_BDD_MHFDIA,'k','LineWidth',LW)
ylabel('Stealthiness','FontWeight','bold')
xlabel('Num of Attacks')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)

inbetween_r = [Max_BDD_MHFDIA.', fliplr(Min_BDD_MHFDIA.')];
hold on, h2 = fill(N_Attack2,inbetween_r,'k');
set(h2,'facealpha',.3)
xlim([1,19])

hold on;
plot(N_Attack,0.9*T*BDD_thresh*ones(length(N_Attack),1),'r--','LineWidth',2*LW)
