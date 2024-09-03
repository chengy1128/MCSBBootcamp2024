% question3



% Initial conditions for v and w 
initial_conditions = [-1.1297 *ones(1,10), -0.6491*ones(1,10)];  % Steady state values

% Define the ODE system

%% Part a No injection(so no I(t)!!
function dXdt = fhn_ring(t, X)
% Define parameters
    eps = 0.08;
    a_2 = 1.0;
    b = 0.2;
    D = 0.9;
    
    v = X(1:10);
    w = X(11:20);
    % initiate functions
    dvdt = zeros(10, 1);
    dwdt = zeros(10, 1);
    
    %the first neuron
    dvdt(1) = v(1) - (1/3)*v(1).^3 - w(1) + D*(v(10) - 2*v(1) + v(2));
    dwdt(1) = eps*(v(1) + a_2 - b*w(1));
    
    %loop the next neuron
    for i = 2:9
        dvdt(i) = v(i) - (1/3)*v(i).^3 - w(i) + D*(v(i-1) - 2*v(i) + v(i+1));
        dwdt(i) = eps*(v(i) + a_2 - b*w(i));
    end
    
    % Neuron 10 (connected to neuron 9 and neuron 1)
    dvdt(10) = v(10) - (1/3)*v(10).^3 - w(10) + D*(v(9) - 2*v(10) + v(1));
    dwdt(10) = eps*(v(10) + a_2 - b*w(10));
    

    dXdt = [dvdt; dwdt];
end
% Solve the ODE 
[T, X] = ode45(@fhn_ring, [0,500], initial_conditions);
% Plot the time series of membrane potential v_i(t) for all 10 cells
figure;
plot(T, X(:,1:10), 'LineWidth', 2);
title('Membrane Potential of All 10 Cells Over Time');
xlabel('Time (t)');
ylabel('Membrane Potential (v_i)');
legend('Cell 1', 'Cell 2', 'Cell 3', 'Cell 4', 'Cell 5', 'Cell 6', 'Cell 7', 'Cell 8', 'Cell 9', 'Cell 10');
grid on;
% % movie
% figure;
% for nt = 1:numel(T)
%     clf; hold on; box on;
%     plot(X(nt,1:10), 'LineWidth', 2);
%     set(gca, 'ylim', [-2.5, 2.5]);
%     xlabel('Cell Number');
%     ylabel('Voltage');
%     title(['Time = ', num2str(T(nt))]);
%     drawnow;
% end

%% 
%% include I(t) current and stimulate at t=40~47

% % Current injection parameters
% I0 = 1.0;
% tStart = 40;
% tStop = 47;
% I = @(t) I0*(t > tStart).*(t < tStop); % Current injection function
