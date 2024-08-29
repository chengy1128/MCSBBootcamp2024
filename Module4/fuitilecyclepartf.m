% Define the range of Ktot values for the parameter sweep
Ktot_values = logspace(-3, 2, 100); % From 10^-3 to 10^2 µM
A_steady_state_100 = zeros(size(Ktot_values));

% Parameters that remain constant
params.kAon = 10; % s^-1µM^-1
params.kAoff = 10; % s^-1
params.kIon = 10; % s^-1µM^-1
params.kIoff = 10; % s^-1
params.kIcat = 10; % s^-1
params.kAcat = 100; % s^-1
params.Ptot = 1.0; % µM, total phosphatase concentration

% Initial conditions for I_tot = 100 µM (all protein is initially inactive)
Itot_100 = 100.0; % µM, total inactive protein concentration
initial_conditions_100 = [0, Itot_100, 0, 0]; % [A0, I0, AP0, IK0]

% Time span for simulation
tspan = [0 100]; % Adjust as needed

% Loop over each Ktot value
for i = 1:length(Ktot_values)
    params.Ktot = Ktot_values(i); % Update Ktot for this iteration
    [~, X] = ode45(@(t, X) futile_cycle_odes(t, X, params), tspan, initial_conditions_100);
    A_steady_state_100(i) = X(end, 1); % Take steady-state value of A (last value)
end

% Plot the steady-state concentration of A as a function of Ktot for I_tot = 100 µM
figure;
semilogx(Ktot_values, A_steady_state_100, 'LineWidth', 2);
xlabel('K_{tot} (\muM)');
ylabel('Steady State [A] (\muM)');
title('Dose-Response Curve with I_{tot} = 100 \muM');
grid on;

% Overlay the previous curve from I_tot = 1 µM for comparison
hold on;
semilogx(Ktot_values, A_steady_state, '--r', 'LineWidth', 2);
legend('I_{tot} = 100 \muM', 'I_{tot} = 1 \muM');
hold off;
