function F = pf_mismatch(x, mpc, ref, pv, pq, Ybus)

define_constants;

nb = size(mpc.bus,1);

Va = mpc.bus(:, VA) * pi/180;
Vm = mpc.bus(:, VM);

nonref = setdiff(1:nb, ref);

Va(nonref) = x(1:length(nonref));
Vm(pq) = x(length(nonref)+1:end);

V = Vm .* exp(1j*Va);

Sbus = makeSbus(mpc.baseMVA, mpc.bus, mpc.gen);

mis = V .* conj(Ybus*V) - Sbus;

F = [
    real(mis([pv; pq]));
    imag(mis(pq))
];
end