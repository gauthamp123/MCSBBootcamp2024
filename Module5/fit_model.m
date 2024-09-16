% Load experimental data
% Replace 'data.txt' with your actual data file name
data = readtable('BacteriaCulture_Amp.xlsx');
t_exp = table2array(data(:, 1));  % Assuming first column is time
N_exp = table2array(data(:, 2));  % Assuming second column is bacterial population

% Plot experimental data
figure;
hold on;
plot(t_exp, N_exp, 'o');
xlabel('Time');
ylabel('Bacterial Population');
title('Experimental Bacterial Growth Data');

% Define parameters
lambda = 0.035;
theta = 0.37;
alpha = 4;
N0 = 0.0025;

% Set up time span
tspan = [0 180];  % Adjust as needed

bacterial_growth =@(t, N, lambda, theta, alpha) lambda * N * (1 - (N / theta)^alpha);

% Solve ODE
[t, N] = ode45(@(t, N) bacterial_growth(t, N, lambda, theta, alpha), tspan, N0);

%plot(t, N);

error = @(params) compute_sse(params, N0, t_exp, N_exp);
best_params = fminsearch(error, [0.035, 1000, 4]);

[t_new, N_new] = ode45(@(t_new, N_new) bacterial_growth(t_new, N_new, best_params(1), best_params(2), best_params(3)), tspan, N0);
plot(t_new, N_new);