%Q2
% Define the system of differential equations with constants
function dydt = odefun2(t, y,a, b,e,I0, t_start, t_stop)
    dydt = zeros(2, 1);

 % Calculate I(t)
    if t >= t_start && t <= t_stop
        I = I0;
    else
        I = 0;
    end


    dydt(1) =  y(1)-1/3*y(1)^3-y(2)+I;%dv/dt = v-1/3v^3-w
    dydt(2) =e*(y(1)+a-b*y(2));%dw/dt=e(v+a-bw))
end

% Set the constants
e=0.08;
a=1;
b=0.2;

I0 = 1.0;      % Amplitude of the input current
t_start = 40;  % Start time of the input current
t_stop = 47;   % Stop time of the input current


% Set the time span and initial conditions
tspan = [0 170];
y0 = [0; -0.5];

% Create a function handle that includes the constants
odefun2_with_constants = @(t, y) odefun2(t, y, a, b,e,I0, t_start, t_stop);

% Solve the ODE system
[t, y] = ode45(odefun2_with_constants, tspan, y0);

% Plot the results
plot(t, y(:,1), 'b-', t, y(:,2), 'r--');
xlabel('Time');
ylabel('Solution');
legend('v - y(1)', 'w -y(2)');
title('Solution of the ODE System with FitzHughNagumo with I(t)');
grid on;