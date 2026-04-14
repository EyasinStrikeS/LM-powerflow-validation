clc;
clear;

define_constants;

mpc = loadcase('case14');
mpopt = mpoption('verbose', 0, 'out.all', 0);

lambda_values = 1.0:0.2:6.0;

success_vec = zeros(length(lambda_values),1);
vmin_vec = NaN(length(lambda_values),1);

for k = 1:length(lambda_values)
    
    lambda = lambda_values(k);
    
    mpc_scaled = scale_case(mpc, lambda);
    
    results = runpf(mpc_scaled, mpopt);
    
    success_vec(k) = results.success;
    
    if results.success == 1
        vmin_vec(k) = min(results.bus(:, VM));
    end
    
end

T = table(lambda_values', success_vec, vmin_vec, ...
    'VariableNames', {'Lambda','Success','MinVoltage'});

disp(T);