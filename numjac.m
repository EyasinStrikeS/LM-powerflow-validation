function J = numjac(fun, x)

fx = fun(x);
n = length(x);
m = length(fx);

J = zeros(m,n);
eps = 1e-6;

for i = 1:n
    dx = zeros(n,1);
    dx(i) = eps;
    J(:,i) = (fun(x+dx) - fx) / eps;
end
end