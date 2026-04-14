function mpc_scaled = scale_case(mpc, lambda)

define_constants;

mpc_scaled = mpc;

% scale active and reactive loads
mpc_scaled.bus(:, PD) = lambda * mpc.bus(:, PD);
mpc_scaled.bus(:, QD) = lambda * mpc.bus(:, QD);

end