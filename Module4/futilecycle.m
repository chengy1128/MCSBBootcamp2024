% Parameters
params.kAon = 10; % s^-1µM^-1
params.kAoff = 10; % s^-1
params.kIon = 10; % s^-1µM^-1
params.kIoff = 10; % s^-1
params.kIcat = 10; % s^-1
params.kAcat = 100; % s^-1
params.Ptot = 1.0; % µM, total phosphatase concentration
params.Ktot = 1.0; % µM, total kinase concentration

% Initial conditions (assume all protein is initially inactive)
Itot = 1.0; % µM, total inactive protein concentration
A0 = 0;     % Initially all protein is inactive
I0 = Itot;
AP0 = 0;
IK0 = 0;
initial_conditions = [A0, I0, AP0, IK0];

% Time span for simulation
tspan = [0 50]; % Adjust as needed

% Solve the ODE system using ode45
[t, X] = ode45(@(t, X) futile_cycle_odes(t, X, params), tspan, initial_conditions);

% Extract results
A = X(:, 1);
I = X(:, 2);
AP = X(:, 3);
IK = X(:, 4);

% Plot the results
figure;
subplot(2,2,1);
plot(t, A, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('[A] (\muM)');
title('Concentration of Active Protein [A]');

subplot(2,2,2);
plot(t, I, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('[I] (\muM)');
title('Concentration of Inactive Protein [I]');

subplot(2,2,3);
plot(t, AP, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('[AP] (\muM)');
title('Concentration of Active-Phosphatase Complex [AP]');

subplot(2,2,4);
plot(t, IK, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('[IK] (\muM)');
title('Concentration of Inactive-Kinase Complex [IK]');

grid on;

