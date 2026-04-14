function [x, success, normF, iter_hist] = lm_pf(mpc, x0)

define_constants;

tol = 1e-6;
maxit = 50;
mu = 1e-2;
mu_inc = 10;
mu_dec = 0.3;

[ref, pv, pq] = bustypes(mpc.bus, mpc.gen);
[Ybus,~,~] = makeYbus(mpc.baseMVA, mpc.bus, mpc.branch);

x = x0;
iter_hist = zeros(maxit, 3);   % [iter, normF, mu]

for k = 1:maxit
    
    F = pf_mismatch(x, mpc, ref, pv, pq, Ybus);
    normF = norm(F, 2);
    iter_hist(k,:) = [k, normF, mu];
    
    if normF < tol
        success = 1;
        iter_hist = iter_hist(1:k,:);
        return;
    end
    
    % Numerical Jacobian
    J = numjac(@(z) pf_mismatch(z, mpc, ref, pv, pq, Ybus), x);
    
    % LM system
    A = J' * J + mu * eye(size(J,2));
    g = J' * F;
    dx = -A \ g;

    if norm(dx) < 1e-8
    success = 0;
    iter_hist = iter_hist(1:k,:);
    return;
    end
    
    % Trial step
    x_trial = x + dx;
    F_trial = pf_mismatch(x_trial, mpc, ref, pv, pq, Ybus);
    normF_trial = norm(F_trial, 2);
    
    if normF_trial < normF * 0.99   % require meaningful improvement
        % Accept step
        x = x_trial;
        mu = max(mu * mu_dec, 1e-8);
    else
        % Reject step, increase damping
        mu = min(mu * mu_inc, 1e8);
    end
end

success = 0;
iter_hist = iter_hist(1:maxit,:);
end