I = 1;
P_tot = 1;


k_A_on = 10;
k_A_off = 10;
k_I_on = 10;
k_I_off = 10;
k_I_cat = 10;
k_A_cat = 100;

sweep_vals = zeros(100);
K_tot_sweep=logspace(-2, 3, 100);

for i=1:length(K_tot_sweep)
K_tot = K_tot_sweep(i);

dAdt = @(A, AP, I, IK) (-k_A_on*A*(P_tot - AP) + k_A_off*AP + k_A_cat*IK);
dAPdt = @(A, AP, I, IK) (k_A_on*A*(P_tot - AP) - k_A_on*AP - k_I_cat*AP);
dIdt = @(A, AP, I, IK) (-k_I_off*I*(K_tot - IK) + k_I_off*IK + k_I_cat*AP);
dIKdt = @(A, AP, I, IK) (k_I_on*I*(K_tot - IK) - k_I_off*IK - k_A_cat*IK);

dxdt = @(t,x) [dAdt(x(1), x(2), x(3), x(4)); 
    dAPdt(x(1), x(2), x(3), x(4)); dIdt(x(1), x(2), x(3), x(4)); dIKdt(x(1), x(2), x(3), x(4))];

[T, X] = ode45(dxdt,[0,10], [0, 0, 1, 0]);

sweep_vals(i) = X(end,1);

end

figure;
plot(K_tot_sweep, sweep_vals)


%plot(T,X(:,1));

%xlabel('Time');
%ylabel('Activated Proteins');

