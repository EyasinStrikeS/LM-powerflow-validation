function x0 = flat_start_x(mpc)

define_constants;

nb = size(mpc.bus,1);
[ref, ~, pq] = bustypes(mpc.bus, mpc.gen);

Va = zeros(nb,1);
Vm = ones(nb,1);

nonref = setdiff(1:nb, ref);

x0 = [Va(nonref); Vm(pq)];
end