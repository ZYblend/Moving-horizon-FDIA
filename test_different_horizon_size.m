%% Test MH_FDIA for different size of horizon

pa = 0.35;
n_meas=19;
n_attack =  round(pa*n_meas);

num_sinario = 19;
T1_array = round(linspace(2,20,num_sinario));

num_iter = 20;
Data = cell(num_iter,num_sinario);
for iter1 = 1:num_iter
    I = sort(randperm(n_meas,n_attack)).';
    for iter = 1:num_sinario
        T1 = T1_array(iter);
        run_model;

        out = sim('System_model_discrete');

        x         = out.logsout.getElement('x').Values.Data; % true states
        x_hat_L2O  = out.logsout.getElement('x_hat_L2O2').Values.Data;
        BDD_res        = out.logsout.getElement('BDD_res2').Values.Data;

        data = {x, x_hat_L2O,BDD_res};
        Data{iter1,iter} = data;
    end
end
save('Data.mat', 'Data','-v7.3');
save('T1_array.mat', 'T1_array','-v7.3');