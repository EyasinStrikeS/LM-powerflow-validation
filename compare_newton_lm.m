clc;
clear;

define_constants;

mpc = loadcase('case14');
mpopt = mpoption('verbose', 0, 'out.all', 0);

lambda_values = [3.6 3.8 4.0 4.1 4.2];

newton_success = zeros(length(lambda_values), 1);
lm_success = zeros(length(lambda_values), 1);
lm_residual = NaN(length(lambda_values), 1);

for k = 1:length(lambda_values)
    lambda = lambda_values(k);

    mpc_scaled = scale_case(mpc, lambda);

    % Newton / MATPOWER
    try
        res_nr = runpf(mpc_scaled, mpopt);
        newton_success(k) = res_nr.success;
    catch
        newton_success(k) = 0;
    end

    % LM initial guess
    if k == 1
        x0 = flat_start_x(mpc_scaled);
    else
        mpc_prev = scale_case(mpc, lambda_values(k-1));
        res_prev = runpf(mpc_prev, mpopt);

        if res_prev.success == 1
            Va = res_prev.bus(:, VA) * pi/180;
            Vm = res_prev.bus(:, VM);

            [ref, ~, pq] = bustypes(res_prev.bus, res_prev.gen);
            nb = size(res_prev.bus, 1);
            nonref = setdiff(1:nb, ref);

            x0 = [Va(nonref); Vm(pq)];
        else
            x0 = flat_start_x(mpc_scaled);
        end
    end

    % Run LM
    [~, ~, lm_residual(k), ~] = lm_pf(mpc_scaled, x0);

    % Relaxed LM success criterion
    if lm_residual(k) < 0.1
        lm_success(k) = 1;
    else
        lm_success(k) = 0;
    end
end

T = table(lambda_values', newton_success, lm_success, lm_residual, ...
    'VariableNames', {'Lambda', 'NewtonSuccess', 'LMSuccess', 'LMResidual'});

disp(T);

save('results.mat', 'lambda_values', 'newton_success', 'lm_success', 'lm_residual');