clc;
clear;

define_constants;

% Load IEEE 14-bus system
mpc = loadcase('case14');

% Set options (no verbose output)
mpopt = mpoption('verbose', 1, 'out.all', 1);

% Run power flow
results = runpf(mpc, mpopt);

% Display result
disp(['Success = ', num2str(results.success)]);