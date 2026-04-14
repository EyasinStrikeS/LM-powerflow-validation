clc;
clear;

define_constants;

mpc = loadcase('case14');
lambda = 4.2;   % near / beyond Newton failure region

mpc_scaled = scale_case(mpc, lambda);

% get good initial point from lambda = 4.0
mpc_prev = scale_case(mpc, 4.0);
res_prev = runpf(mpc_prev, mpoption('verbose',0,'out.all',0));

if res_prev.success ~= 1
    error('Power flow at lambda = 4.0 did not converge, so cannot use it as initial guess.');
end

% extract state
Va = res_prev.bus(:, VA) * pi/180;
Vm = res_prev.bus(:, VM);

[ref, ~, pq] = bustypes(res_prev.bus, res_prev.gen);
nb = size(res_prev.bus,1);
nonref = setdiff(1:nb, ref);

x0 = [Va(nonref); Vm(pq)];

[x, success, normF, iter_hist] = lm_pf(mpc_scaled, x0);

disp(['LM Success = ', num2str(success)]);
disp(['Residual norm = ', num2str(normF)]);

disp('Iteration history: [iter, normF, mu]');
format long g
disp(iter_hist);