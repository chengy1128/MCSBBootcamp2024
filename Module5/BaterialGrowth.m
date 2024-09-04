%% Using Jun's provided dataset
% % Define Parameters
% lambda = 1;
% theta = 10^3;
% alpha = 2;
initial = 200; % Initial N(0) = 200

% Define the ODE function
function dNdt = BacterialGrowth(t, N)
    lambda = 1; 
    theta = 10^3;
    alpha = 2;
    dNdt = lambda * N * (1 - N / theta)^alpha;
end

% Define the time span
tspan = linspace(0, 10, 49);;

% Solve the ODE using ode45
[T, N] = ode45(@(t, N) BacterialGrowth(t, N), tspan, initial);

% Plot the results
plot(T, N,"LineWidth",2);
xlabel('Time');
ylabel('N(t)');
title('Bacterial Growth Over Time');

%% Experimental Data
% Load the data (Copy from Jun)
data = readtable('bacterial_growth_data');


% Check names
disp(data.Properties.VariableNames);

% Extract the correct columns for time and bacterial growth
time = data.('Var1');  
growth = data.('Var2'); 
% Plot time vs bacterial growth
% figure;
hold on
plot(time, growth, '-o', 'LineWidth', 1.5);
xlabel('Time (hours)');
ylabel('Bacterial Growth');
title('Bacterial Growth Over Time');
grid on;
%% Calculate SSE


% Calculate the differences and square them
differences = N - growth;
squaredDifferences = differences .^ 2;

% Sum the squared differences
SSE = sum(squaredDifferences);

% Display the SSE
disp(['Sum of Squared Errors (SSE) = ', num2str(SSE)]);




