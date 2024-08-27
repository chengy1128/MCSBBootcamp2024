% Parameters
n =500;           % Number of years (time steps)
r = 2.5;          % Per-capita growth rate
K = 0.6;          % Carrying capacity
x0 = 0.2;         % Initial population

% Initialize population arrays
x_unbounded = zeros(1, n+1);
x_bounded = zeros(1, n+1);

% Set initial population
x_unbounded(1) = x0;
x_bounded(1) = x0;
%% Generate time series for unbounded and bounded population
for i = 1:n
    % Unbounded population model
    x_unbounded(i+1) = x_unbounded(i) + r * x_unbounded(i);

    % Bounded population model
    x_bounded(i+1) = x_bounded(i) + r * (1 - x_bounded(i)/K) * x_bounded(i);
end
% Plot the time series
figure;
subplot(2,1,1);
plot(0:n, x_unbounded, '-o');
title('Unbounded Population Growth x0=0.2 r=2.5 K=0.6');
xlabel('Time (Years)');
ylabel('Population');

subplot(2,1,2);
plot(0:n, x_bounded, '-*');
title('Bounded Population Growth x0=0.2 r=2.5 K=0.6');
xlabel('Time (Years)');
ylabel('Population');
% %% Experiment with different r values to find a 3-cycle
% r_values = [2.47, 2.48, 2.49, 2.6, 2.7];
% for r = r_values
%     x_bounded = zeros(1, n+1);
%     x_bounded(1) = x0;
% 
%     for i = 1:n
%         x_bounded(i+1) = x_bounded(i) + r * (1 - x_bounded(i)/K) * x_bounded(i);
%     end
% 
%     last_half = x_bounded(floor(n/2):end);
%     unique_values = unique(last_half);
% 
%     if length(unique_values) == 3
%         disp(['3-cycle found at r = ', num2str(r)]);
%         disp('Unique values in the last half of the time series:');
%         disp(unique_values);
%     end
% end
%% Parameters
K = 0.6;          % Carrying capacity
x0 = 0.2;         % Initial population
% Parameter sweep
r_values = linspace(0, 3, 1000);  % Parameter sweep for r
max_iter = 1000;  % Maximum iterations for each r value which is n
last_iter = 500;  % Analyze the last 500 iterations

% Initialize matrix to store results
cycle_values = [];

for r = r_values
    % Initialize population array
    x_bounded = zeros(1, max_iter+1);
    x_bounded(1) = x0;

    % Calculate the population for each time step
    for i = 1:max_iter
        x_bounded(i+1) = x_bounded(i) + r * (1 - x_bounded(i)/K) * x_bounded(i);
    end

    % Analyze the last few iterations
    last_half = x_bounded(end-last_iter:end);
    unique_values = unique(last_half);

    % Store the results
    cycle_values = [cycle_values; repmat(r, length(unique_values), 1), unique_values'];
end

% Plot the bifurcation diagram
figure;
plot(cycle_values(:,1), cycle_values(:,2), 'k.', 'MarkerSize', 1);
title('Bifurcation Diagram for 0 < r < 3.0 with K = 0.6');
xlabel('Growth Rate (r)');
ylabel('Population');
