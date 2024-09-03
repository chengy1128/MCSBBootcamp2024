

% Define the ODE system
function dXdt = fhn_ring_with_injection(t, X)
% Define parameters
eps = 0.08;
a_2 = 1.0;
b = 0.2;
D = 0.9;


% Define the current injection for the fourth cell
I0 = 1.0;  % Current strength
tStart = 40;  % Start time for the injection
tStop = 47;  % Stop time for the injection
I = @(t) I0 * (t > tStart) .* (t < tStop);  % Current injection function

% Define the time span for the simulation
tspan = [0 100];  % Adjust as needed

% Initial conditions for v and w (10 cells, so 20 initial conditions)
% Initial conditions for v and w 
initial_conditions = [-1.1297 *ones(1,10), -0.6491*ones(1,10)];  % Steady state values
    v = X(1:10);   % Extract v_i for all cells
    w = X(11:20);  % Extract w_i for all cells
    
    dvdt = zeros(10, 1);
    dwdt = zeros(10, 1);
    
    % Neuron 1 (connected to neuron 10 and neuron 2)
    dvdt(1) = v(1) - (1/3)*v(1).^3 - w(1) + D*(v(10) - 2*v(1) + v(2));
    dwdt(1) = eps*(v(1) + a_2 - b*w(1));
    
    % Neuron 2 (connected to neuron 1 and neuron 3)
    dvdt(2) = v(2) - (1/3)*v(2).^3 - w(2) + D*(v(1) - 2*v(2) + v(3));
    dwdt(2) = eps*(v(2) + a_2 - b*w(2));
    
    % Neuron 3 (connected to neuron 2 and neuron 4)
    dvdt(3) = v(3) - (1/3)*v(3).^3 - w(3) + D*(v(2) - 2*v(3) + v(4));
    dwdt(3) = eps*(v(3) + a_2 - b*w(3));
    
    % Neuron 4 (receives the injection current, connected to neuron 3 and neuron 5)
    dvdt(4) = v(4) - (1/3)*v(4).^3 - w(4) + I(t) + D*(v(3) - 2*v(4) + v(5));
    dwdt(4) = eps*(v(4) + a_2 - b*w(4));
    
    % Neuron 5 to 9 (connected to their immediate neighbors)
    for i = 5:9
        dvdt(i) = v(i) - (1/3)*v(i).^3 - w(i) + D*(v(i-1) - 2*v(i) + v(i+1));
        dwdt(i) = eps*(v(i) + a_2 - b*w(i));
    end
    
    % Neuron 10 (connected to neuron 9 and neuron 1)
    dvdt(10) = v(10) - (1/3)*v(10).^3 - w(10) + D*(v(9) - 2*v(10) + v(1));
    dwdt(10) = eps*(v(10) + a_2 - b*w(10));
    
    % Combine dvdt and dwdt into a single vector
    dXdt = [dvdt; dwdt];
end

% Solve the ODE system using ode45
% Define the time span for the simulation
tspan = [0 1000];  % Adjust as needed
[T, X] = ode45(@fhn_ring_with_injection, tspan, initial_conditions);

% Plot the time series of membrane potential v_i(t) for all 10 cells
figure;
plot(T, X(:,1:10), 'LineWidth', 2);
title('Membrane Potential of All 10 Cells Over Time');
xlabel('Time (t)');
ylabel('Membrane Potential (v_i)');
legend('Cell 1', 'Cell 2', 'Cell 3', 'Cell 4', 'Cell 5', 'Cell 6', 'Cell 7', 'Cell 8', 'Cell 9', 'Cell 10');
grid on;

% Create a movie showing the voltage across all 10 cells over time
figure;
for nt = 1:numel(T)
    clf; hold on; box on;
    plot(X(nt,1:10), 'LineWidth', 2);
    set(gca, 'ylim', [-2.5, 2.5]);
    xlabel('Cell Number');
    ylabel('Voltage');
    title(['Time = ', num2str(T(nt))]);
    drawnow;
end
