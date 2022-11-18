%% plotting file for perform vs Max_iters number


%% load data
% load mean_effect_MHFDIA.mat
% load max_effect_MHFDIA.mat
% load min_effect_MHFDIA.mat
% 
% load Max_BDD_MHFDIA.mat
% load Mean_BDD_MHFDIA.mat
% load Min_BDD_MHFDIA.mat

run_model;

load('sim_out/effect.mat');
load('sim_out/stealth.mat');

load sim_out/Max_Iter.mat;

Max_Iter2 = [Max_iter, fliplr(Max_iter)];

LW = 1.5;  % linewidth
FS = 15;   % font size

%% plotting
% MH-FDIA 
figure,
subplot(1,2,1)
plot(Max_iter,Mean_effect_MHFDIA,'k','LineWidth',LW)
ylabel('Eeffectiveness','FontWeight','bold')
xlabel('Maximum iteration allowance')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)

inbetween_yc = [Max_effect_MHFDIA.', fliplr(Min_effect_MHFDIA.')];
hold on, h1 = fill(Max_Iter2,inbetween_yc,'k');
set(h1,'facealpha',.3)

subplot(1,2,2)
plot(Max_iter,Mean_BDD_MHFDIA,'k','LineWidth',LW)
ylabel('Stealthiness','FontWeight','bold')
xlabel('Maximum iteration allowance')
set(gca,'fontweight','bold','fontsize',12) 
set(gca,'LineWidth',LW)

inbetween_r = [Max_BDD_MHFDIA.', fliplr(Min_BDD_MHFDIA.')];
hold on, h2 = fill(Max_Iter2,inbetween_r,'k');
set(h2,'facealpha',.3)

hold on;
plot(Max_iter,T*BDD_thresh*ones(length(Max_iter),1),'r--','LineWidth',2*LW)

% % Eig-FDIA 
% subplot(2,2,2)
% plot(Max_iter,mean_effect_EIGFDIA,'k','LineWidth',LW)
% title('FDIA (literature)');
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)
% 
% inbetween_yc = [max_effect_EIGFDIA.', fliplr(min_effect_MHFDIA.')];
% hold on, h1 = fill(Max_Iter2,inbetween_yc,'k');
% set(h1,'facealpha',.3)
% 
% subplot(2,2,4)
% plot(Max_iter,Mean_BDD_EIGFDIA,'k','LineWidth',LW)
% xlabel('time')
% set(gca,'fontweight','bold','fontsize',12) 
% set(gca,'LineWidth',LW)
% 
% inbetween_r = [Max_BDD_EIGFDIA.', fliplr(Min_BDD_EIGFDIA.')];
% hold on, h2 = fill(Max_Iter2,inbetween_r,'k');
% set(h2,'facealpha',.3)
% 
% hold on;
% plot(Max_iter,0.9*T*BDD_thresh*ones(length(Max_iter),1),'r--','LineWidth',2*LW)
