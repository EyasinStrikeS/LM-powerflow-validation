clc;
clear;

define_constants;

mpc = loadcase('case14');

lambda = 1.2;   % increase load by 20%

mpc_scaled = scale_case(mpc, lambda);

mpopt = mpoption('verbose', 0, 'out.all', 0);

results = runpf(mpc_scaled, mpopt);

disp(['Success = ', num2str(results.success)]);
disp('Minimum Voltage:');
disp(min(results.bus(:, VM)));