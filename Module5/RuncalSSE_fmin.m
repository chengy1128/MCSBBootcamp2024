% Define the initial guess for parameters and other constants
initialParams = [1; 1000; 2];  % Initial guesses for lambda, theta, alpha
dataPath = 'bacterial_growth_data.csv';  % Path to experimental data
initialN = 200;  % Initial bacterial count

% Objective function that only takes parameters as input
objectiveFunc = @(params) calSSE_fmin(dataPath, initialN, params);

% Use fminsearch to find the best fit parameters
optimalParams = fminsearch(objectiveFunc, initialParams);

% Display the found optimal parameters
disp(['Optimal Lambda: ', num2str(optimalParams(1))]);
disp(['Optimal Theta: ', num2str(optimalParams(2))]);
disp(['Optimal Alpha: ', num2str(optimalParams(3))]);
% Solve the ODE with optimal parameters
[T, Nsim] = ode45(@(t, N) optimalParams(1) * N * (1 - N / optimalParams(2))^optimalParams(3), linspace(0, 10, 49), initialN);

% Load the experimental data again for plotting
data = readtable(dataPath);
time = data{:, 1};
growth = data{:, 2};

% Plot both datasets
figure;
hold on;
plot(time, growth, 'ro', 'DisplayName', 'Experimental Data');
plot(T, Nsim, 'b-', 'DisplayName', 'Simulated Data');
xlabel('Time (hours)');
ylabel('Bacterial Growth (N(t))');
title('Comparison of Experimental and Simulated Bacterial Growth');
legend show;
grid on;
