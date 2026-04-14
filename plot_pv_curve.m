clc;
clear;

define_constants;

mpc = loadcase('case14');
mpopt = mpoption('verbose', 0, 'out.all', 0);

lambda_values = 1.0:0.1:4.2;
vmin_vec = NaN(size(lambda_values));

for k = 1:length(lambda_values)
    
    lambda = lambda_values(k);
    
    mpc_scaled = scale_case(mpc, lambda);
    results = runpf(mpc_scaled, mpopt);
    
    if results.success == 1
        vmin_vec(k) = min(results.bus(:, VM));
    end
    
end

% Plot
figure;
plot(lambda_values, vmin_vec, 'o-', 'LineWidth', 2);
xlabel('\lambda (Load Scaling)');
ylabel('Minimum Bus Voltage (p.u.)');
title('P-V Curve (Voltage Stability)');
grid on;