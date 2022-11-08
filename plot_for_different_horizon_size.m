%% plotting for differen size of horizon
clear all
clc

% Data1 = load('Data1.mat').Data;
% Data2 = load('Data.mat').Data;
% Data = cell(110,19);
% for idx = 1:10
%     for idx2 = 1:19
%        Data{idx,idx2} = Data1{idx,idx2}; 
%     end
% end
% 
% for idx = 11:110
%     for idx2 = 1:19
%        Data{idx,idx2} = Data2{idx-10,idx2}; 
%     end
% end
load Data.mat
load T1_array.mat

N_sample = 800;
T = 20;
N_start_opt=1.5*T;  % start time step of observer
N_start_attack = 0.2*N_sample;


[n_samples,n_iter] = size(Data);   
alpha = zeros(n_samples,n_iter);
r_max = zeros(n_samples,n_iter);

for idx = 1:n_iter
    for idx1 = 1:n_samples
        data = Data{idx1,idx};
        x = data{1,1};
        x_hat = data{1,2};
        r = data{1,3};

        alpha(idx1,idx) = max(vecnorm(x(N_start_opt:end,:)-x_hat(N_start_opt:end,:),2,2));
        r_max(idx1,idx) = max(r(N_start_attack+T+1:end));
    end
end

alpha_exp = mean(alpha,1);
r_max_exp = mean(r_max,1);


%% plotting
plot(T1_array,alpha_exp);
figure
plot(T1_array,r_max_exp);